//
//  SpotifyConnectionService.swift
//  CarConnect
//
//  Отвечает за авторизацию и lifecycle подключения к Spotify App Remote.
//  Владеет единственным экземпляром SPTAppRemote и реализует SPTAppRemoteDelegate.
//  UI-логики не содержит — только данные и команды.
//
//  Интеграция:
//  1. SceneDelegate.scene(_:openURLContexts:)  → SpotifyConnectionService.shared.handleURL(_:)
//  2. SceneDelegate.sceneDidBecomeActive       → SpotifyConnectionService.shared.connect()
//  3. SceneDelegate.sceneDidEnterBackground    → SpotifyConnectionService.shared.disconnect()
//

import Foundation
import Combine
import SpotifyiOS
import UIKit

// MARK: - SpotifyConnectionService

final class SpotifyConnectionService: NSObject {

    static let shared = SpotifyConnectionService()

    private let clientID = "bc37361b992e4d579a2327aa20c95d9c"
    private let redirectURI = URL(string: "\(DeepLink.Constants.scheme)://\(DeepLink.Constants.spotifyModeNavigator)")!
    
    let userIsPremium = CurrentValueSubject<Bool, Never>(false)

    /// Готовый к использованию appRemote. SpotifyMusicPlayer берёт его отсюда,
    /// а не создаёт свой собственный экземпляр.
    private(set) lazy var appRemote: SPTAppRemote = {
        let remote = SPTAppRemote(configuration: configuration, logLevel: .error)
        remote.delegate = self
        return remote
    }()

    // MARK: Private

    private lazy var configuration = SPTConfiguration(clientID: clientID, redirectURL: redirectURI)

    private var savedAccessToken: String? {
        get { UserDefaults.standard.string(forKey: "spotify_access_token") }
        set { UserDefaults.standard.set(newValue, forKey: "spotify_access_token") }
    }

    private override init() {
        super.init()
        if let token = savedAccessToken {
            appRemote.connectionParameters.accessToken = token
        }
    }
    
    func checkSpotifyAvailability() -> Bool {
        appRemote.isConnected
    }
    
    func autorize() async -> Bool {
        let spotifyInstalled = await withCheckedContinuation { [weak self] continuation in
            self?.appRemote.authorizeAndPlayURI("") { spotifyInstalled in
                continuation.resume(with: .success(spotifyInstalled))
            }
        }
        if !spotifyInstalled {
            Task { @MainActor in
                self.openSpotifyInAppStore()
            }
        }
        
        return spotifyInstalled
    }

    /// Открыть App Store на странице Spotify.
    /// Вызывать по нажатию кнопки «Установить Spotify».
    @MainActor
    func openSpotifyInAppStore() {
        let itemID = SPTAppRemote.spotifyItunesItemIdentifier()
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/id\(itemID)") else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    /// Подключиться к App Remote, используя сохранённый токен.
    /// Вызывать в sceneDidBecomeActive — восстанавливает соединение без повторного логина.
    func connect() {
        guard !appRemote.isConnected, let token = savedAccessToken else { return }
        appRemote.connectionParameters.accessToken = token
        appRemote.connect()
    }

    /// Отключиться от App Remote.
    /// Вызывать в sceneDidEnterBackground — освобождает соединение корректно.
    func disconnect() {
        guard appRemote.isConnected else { return }
        appRemote.disconnect()
    }

    /// Передать URL из SceneDelegate после возврата из Spotify.
    ///
    /// ```swift
    /// // SceneDelegate.swift
    /// func scene(_ scene: UIScene, openURLContexts contexts: Set<UIOpenURLContext>) {
    ///     if let url = contexts.first?.url {
    ///         SpotifyConnectionService.shared.handleURL(url)
    ///     }
    /// }
    /// ```
    func handleURL(_ url: URL) {
        let params = appRemote.authorizationParameters(from: url)

        if let token = params?[SPTAppRemoteAccessTokenKey] as? String {
            savedAccessToken = token
            appRemote.connectionParameters.accessToken = token
            appRemote.connect()
        }
    }

    // MARK: - Private helpers

    private func fetchUserCapabilities() {
        appRemote.userAPI?.delegate = self
        appRemote.userAPI?.fetchCapabilities { [weak self] result, error in
            if let error {
                // Не удалось получить capabilities — показываем connected без Premium.
                print("[SpotifyConnectionService] fetchCapabilities error:", error.localizedDescription)
                return
            }
            if let caps = result as? SPTAppRemoteUserCapabilities {
                self?.userIsPremium.send(caps.canPlayOnDemand)
            }
        }
    }
}

// MARK: - SPTAppRemoteDelegate
// Живёт здесь, потому что SpotifyConnectionService владеет appRemote
// и управляет всем lifecycle соединения.

extension SpotifyConnectionService: SPTAppRemoteDelegate {

    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        // Соединение готово — запрашиваем тип подписки, затем уведомляем плеер через statePublisher.
        fetchUserCapabilities()
        // Подписываем плеер на player state — он сам установит себя делегатом playerAPI.
        SpotifyMusicPlayer.shared.didConnect(to: appRemote)
    }

    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        SpotifyMusicPlayer.shared.didDisconnect()
    }

    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        let reason = error?.localizedDescription ?? "Unknown error"
    }
}

// MARK: - SPTAppRemoteUserAPIDelegate

extension SpotifyConnectionService: SPTAppRemoteUserAPIDelegate {

    /// Вызывается при изменении подписки в реальном времени (subscribeToCapabilityChanges).
    func userAPI(_ userAPI: SPTAppRemoteUserAPI, didReceive capabilities: SPTAppRemoteUserCapabilities) {
        userIsPremium.send(capabilities.canPlayOnDemand)
    }
}
