//
//  PlayerAccessCoordinator.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 24.05.2026.
//

import Foundation
import Combine
import StoreKit

final class PlayerSourceAccessService {
    private let source: MusicSource
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
    
    func checkAccessSpotify() -> Bool {
        return spotifyConnectionService.checkSpotifyAvailability()
    }
    
    func requestAuthorizationAppleMusic() async -> Bool {
        guard MusicAuthorization.currentStatus == .notDetermined else { return false }
        return await MusicAuthorization.request() == .authorized
    }
    
    func requestAuthorizationSpotify() {
        spotifyConnectionService.autorize()
    }
}

import UIKit
import MusicKit

final class PlayerAccessCoordinator: NSObject {
    private let navigationController: UINavigationController
    private let source: MusicSource
    private let accessService: PlayerSourceAccessService
    
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
            accessService.checkAccessSpotify()
                ? setRoot(MusicPlayerViewController(source: .spotify), animated: true)
                : showAuthorizationRequired()
        case .radio:
            break
        }
        
    }
    
    private func showAuthorizationRequired() {
        let vc = AuthorizationRequiredViewController(source: source)
        vc.delegate = self
        setRoot(vc, animated: true)
    }
    
    private func setRoot(_ viewController: UIViewController, animated: Bool) {
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
