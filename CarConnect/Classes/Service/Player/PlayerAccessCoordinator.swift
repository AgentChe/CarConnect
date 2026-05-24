//
//  PlayerAccessCoordinator.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 24.05.2026.
//

import Foundation
import Combine

final class PlayerSourceAccessService {
    let source: MusicSource
    private let appleMusicService: AppleMusicService
    private let spotifyConnectionService: SpotifyConnectionService
    
    private var spotifyStateCancellable: AnyCancellable?
    
    init(source: MusicSource) {
        self.source = source
        appleMusicService = .init()
        spotifyConnectionService = .shared
    }
    
    func checkAccessAppleMusic() -> Bool {
        return appleMusicService.isAuthorized
    }
    
    func checkAccessSpotify(handle: @escaping @MainActor (SpotifyConnectionState) -> Void) {
        spotifyConnectionService.checkSpotifyAvailability()
        
        spotifyStateCancellable = spotifyConnectionService.statePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: handle)
    }
    
    func requestAuthorizationAppleMusic() async -> Bool {
        guard MusicAuthorization.currentStatus == .notDetermined else { return false }
        return await MusicAuthorization.request() == .authorized
    }
    
    func requestAuthorizationSpotify() {
        let value = spotifyConnectionService.statePublisher.value
        
        switch value {
        case .spotifyNotInstalled:
            spotifyConnectionService.openSpotifyInAppStore()
        case .notAuthorized, .idle:
            spotifyConnectionService.authorize()
        case .authorizing, .connecting, .connected, .disconnected, .failed:
            break
        }
    }
}

import UIKit
import MusicKit

final class PlayerAccessCoordinator {
    private let navigationController: UINavigationController
    private let source: MusicSource
    private let accessService: PlayerSourceAccessService
    
    // Храним слабую ссылку на текущий «корневой» контроллер этого flow,
    // чтобы не дублировать его при повторных вызовах
    private weak var currentRootVC: UIViewController?
    
    init(navigationController: UINavigationController, source: MusicSource) {
        self.navigationController = navigationController
        self.source = source
        self.accessService = PlayerSourceAccessService(source: source)
    }
    
    func start() {
        switch source {
        case .appleMusic:
            accessService.checkAccessAppleMusic()
                ? setRoot(AppleMusicMainViewController.make(), animated: true)
                : showAuthorizationRequired()
        case .spotify:
            accessService.checkAccessSpotify { [weak self] in
                self?.handleState($0)
            }
        case .radio:
            break
        }
        
    }
    
    @MainActor
    private func handleState(_ state: SpotifyConnectionState) {
        switch state {

        case .spotifyNotInstalled:
            // Показать: "Spotify не установлен. Установить?"
            // Кнопка «Установить» вызывает:
            // SpotifyConnectionService.shared.openSpotifyInAppStore()
            showAuthorizationRequired()

        case .notAuthorized:
            // Показать: "Войдите в Spotify для воспроизведения"
            // Кнопка «Войти» вызывает:
            // SpotifyConnectionService.shared.authorize()
            showAuthorizationRequired()

        case .authorizing, .connecting:
            // Показать лоадер
            break

        case .connected:
            // Показать полноценный плеер
            setRoot(AppleMusicPlayerViewController(source: .spotify), animated: true)

        case .disconnected:
            // Соединение прервалось (Spotify ушёл в фон).
            // Можно показать "Нет соединения" или тихо переподключиться:
             SpotifyConnectionService.shared.connect()

        case .failed:
            showAuthorizationRequired()

        case .idle:
            showAuthorizationRequired()
        }
    }
    
    private func showAuthorizationRequired() {
        let vc = AuthorizationRequiredViewController(source: source)
        vc.delegate = self
        setRoot(vc, animated: true)
    }
    
    private func setRoot(_ viewController: UIViewController, animated: Bool) {
        currentRootVC = viewController
        navigationController.setViewControllers([viewController], animated: animated)
    }
}

extension PlayerAccessCoordinator: AuthorizationRequiredViewControllerDelegate {
    func didTapButton() {
        switch source {
        case .appleMusic:
            Task { @MainActor in
                let granted = await accessService.requestAuthorizationAppleMusic()
                if granted {
                    setRoot(AppleMusicMainViewController.make(), animated: true)
                }
            }
        case .spotify:
            accessService.requestAuthorizationSpotify()
        case .radio:
            break
        }
    }
}
