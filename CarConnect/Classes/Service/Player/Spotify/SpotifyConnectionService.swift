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

// MARK: - Supporting types

/// Состояние, которое UI должен отображать при выборе Spotify.
enum SpotifyConnectionState: Equatable {
    /// Начальное — ещё не проверяли ничего.
    case idle
    /// Spotify не установлен на устройстве.
    case spotifyNotInstalled
    /// Spotify установлен, но пользователь ещё не авторизовался.
    case notAuthorized
    /// Идёт процесс авторизации (ушли в Spotify, ждём редиректа).
    case authorizing
    /// Авторизованы, устанавливаем соединение с App Remote.
    case connecting
    /// Подключены и готовы к работе.
    case connected(capabilities: SpotifyUserCapabilities)
    /// Соединение разорвано (Spotify ушёл в фон и т.п.).
    case disconnected
    /// Произошла ошибка.
    case failed(SpotifyConnectionError)
}

/// Возможности пользователя — определяют, что показывать в UI.
struct SpotifyUserCapabilities: Equatable {
    /// `true` = Premium: можно играть любой трек по URI, управлять shuffle/repeat.
    /// `false` = Free: только play/pause, треки по требованию недоступны.
    let canPlayOnDemand: Bool

    /// Удобный флаг для UI: показывать ли баннер «Нужен Premium».
    var requiresPremiumBanner: Bool { !canPlayOnDemand }
}

enum SpotifyConnectionError: Equatable {
    /// Пользователь отменил авторизацию или она завершилась с ошибкой.
    case authorizationFailed(reason: String)
    /// App Remote не смог установить соединение.
    case connectionFailed(reason: String)
}

// MARK: - SpotifyConnectionService

final class SpotifyConnectionService: NSObject {

    static let shared = SpotifyConnectionService()

    private let clientID = "bc37361b992e4d579a2327aa20c95d9c"
    private let redirectURI = URL(string: "carconnectapp://spotify-callback")!

    // MARK: Public

    /// Текущее состояние соединения. UI и SpotifyMusicPlayer подписываются на этот publisher.
    let statePublisher = CurrentValueSubject<SpotifyConnectionState, Never>(.idle)

    /// Готовый к использованию appRemote. SpotifyMusicPlayer берёт его отсюда,
    /// а не создаёт свой собственный экземпляр.
    private(set) lazy var appRemote: SPTAppRemote = {
        let remote = SPTAppRemote(configuration: configuration, logLevel: .error)
        remote.delegate = self
        return remote
    }()

    // MARK: Private

    private lazy var configuration = SPTConfiguration(clientID: clientID, redirectURL: redirectURI)

    /// Используется только для проверки isSpotifyAppInstalled —
    /// это свойство есть у SPTSessionManager, но не у SPTAppRemote.
    private lazy var sessionManager = SPTSessionManager(configuration: configuration, delegate: nil)

    private var isSpotifyInstalled: Bool { sessionManager.isSpotifyAppInstalled }

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

    // MARK: - Public API

    /// Проверить наличие Spotify на устройстве и статус авторизации.
    /// Вызывать при открытии экрана выбора источника музыки.
    func checkSpotifyAvailability() {
        if isSpotifyInstalled {
            statePublisher.send(savedAccessToken != nil ? .disconnected : .notAuthorized)
        } else {
            statePublisher.send(.spotifyNotInstalled)
        }
    }

    /// Запустить авторизацию через приложение Spotify.
    ///
    /// Вызывать по нажатию кнопки «Войти в Spotify».
    /// Пустой URI → Spotify возобновит последний трек пользователя.
    /// После редиректа обратно вызовется handleURL(_:).
    func authorize() {
        guard isSpotifyInstalled else {
            statePublisher.send(.spotifyNotInstalled)
            return
        }

        statePublisher.send(.authorizing)

        appRemote.authorizeAndPlayURI("") { [weak self] spotifyInstalled in
            // Коллбэк вызывается синхронно до редиректа обратно в приложение.
            // spotifyInstalled = false: Spotify удалили пока мы проверяли.
            if !spotifyInstalled {
                self?.statePublisher.send(.spotifyNotInstalled)
            }
        }
    }

    /// Открыть App Store на странице Spotify.
    /// Вызывать по нажатию кнопки «Установить Spotify».
    @discardableResult
    func openSpotifyInAppStore() -> Bool {
        let itemID = SPTAppRemote.spotifyItunesItemIdentifier()
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/id\(itemID)") else { return false }
        guard UIApplication.shared.canOpenURL(url) else { return false }
        UIApplication.shared.open(url)
        return true
    }

    /// Подключиться к App Remote, используя сохранённый токен.
    /// Вызывать в sceneDidBecomeActive — восстанавливает соединение без повторного логина.
    func connect() {
        guard !appRemote.isConnected, let token = savedAccessToken else { return }
        appRemote.connectionParameters.accessToken = token
        statePublisher.send(.connecting)
        appRemote.connect()
    }

    /// Отключиться от App Remote.
    /// Вызывать в sceneDidEnterBackground — освобождает соединение корректно.
    func disconnect() {
        guard appRemote.isConnected else { return }
        appRemote.disconnect()
    }

    /// Разлогинить пользователя (например, кнопка «Выйти» в настройках).
    /// Удаляет токен — следующий вход потребует повторной авторизации.
    func revokeAuthorization() {
        savedAccessToken = nil
        appRemote.connectionParameters.accessToken = nil
        if appRemote.isConnected { appRemote.disconnect() }
        statePublisher.send(.notAuthorized)
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
            statePublisher.send(.connecting)
            appRemote.connect()
        } else if let error = params?[SPTAppRemoteErrorDescriptionKey] as? String {
            statePublisher.send(.failed(.authorizationFailed(reason: error)))
        }
    }

    // MARK: - Private helpers

    private func fetchUserCapabilities() {
        appRemote.userAPI?.delegate = self
        appRemote.userAPI?.fetchCapabilities { [weak self] result, error in
            if let error {
                // Не удалось получить capabilities — показываем connected без Premium.
                self?.statePublisher.send(.connected(
                    capabilities: SpotifyUserCapabilities(canPlayOnDemand: false)
                ))
                print("[SpotifyConnectionService] fetchCapabilities error:", error.localizedDescription)
                return
            }
            if let caps = result as? SPTAppRemoteUserCapabilities {
                self?.statePublisher.send(.connected(
                    capabilities: SpotifyUserCapabilities(canPlayOnDemand: caps.canPlayOnDemand)
                ))
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
        statePublisher.send(.disconnected)
    }

    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        let reason = error?.localizedDescription ?? "Unknown error"
        statePublisher.send(.failed(.connectionFailed(reason: reason)))
    }
}

// MARK: - SPTAppRemoteUserAPIDelegate

extension SpotifyConnectionService: SPTAppRemoteUserAPIDelegate {

    /// Вызывается при изменении подписки в реальном времени (subscribeToCapabilityChanges).
    func userAPI(_ userAPI: SPTAppRemoteUserAPI, didReceive capabilities: SPTAppRemoteUserCapabilities) {
        statePublisher.send(.connected(
            capabilities: SpotifyUserCapabilities(canPlayOnDemand: capabilities.canPlayOnDemand)
        ))
    }
}
