//
//  SpotifyMusicPlayer.swift
//  CarConnect
//
//  Управляет воспроизведением через Spotify App Remote.
//  Не создаёт собственный SPTAppRemote — получает готовый из SpotifyConnectionService.
//  Реализует только SPTAppRemotePlayerStateDelegate.
//

import Foundation
import Combine
import SpotifyiOS
import UIKit

// MARK: - SpotifyMusicPlayer

final class SpotifyMusicPlayer: NSObject {

    static let shared = SpotifyMusicPlayer()

    /// Публикует метаданные трека. Новый подписчик сразу получает текущее значение.
    let trackPublisher = CurrentValueSubject<TrackModel?, Never>(nil)

    /// Публикует состояние воспроизведения. Новый подписчик сразу получает текущее значение.
    let playbackPublisher = CurrentValueSubject<PlaybackModel?, Never>(nil)

    // MARK: Private

    /// Слабая ссылка — appRemote принадлежит SpotifyConnectionService.
    private weak var appRemote: SPTAppRemote?

    private var lastPlayerState: SPTAppRemotePlayerState?
    private var lastStateReceivedAt: Date = .distantPast
    private var progressTimer: AnyCancellable?

    private override init() {
        super.init()
        startProgressTimer()
    }

    // MARK: - Connection callbacks (вызывает SpotifyConnectionService)

    /// Вызывается из SpotifyConnectionService когда соединение установлено.
    /// Сохраняет ссылку на appRemote и подписывается на player state.
    func didConnect(to appRemote: SPTAppRemote) {
        self.appRemote = appRemote
        appRemote.playerAPI?.delegate = self
        appRemote.playerAPI?.subscribe(toPlayerState: { _, error in
            if let error { print("[SpotifyMusicPlayer] subscribe error:", error) }
        })
    }

    /// Вызывается из SpotifyConnectionService когда соединение разорвано.
    func didDisconnect() {
        appRemote = nil
        lastPlayerState = nil
        playbackPublisher.send(nil)
        trackPublisher.send(nil)
    }

    // MARK: - Playback controls (тот же интерфейс что у AppleMusicPlayer)

    var isPlaying: Bool { lastPlayerState?.isPaused == false }

    /// Воспроизвести / поставить на паузу текущий трек.
    func togglePlaybackStatus() {
        guard let api = appRemote?.playerAPI else { return }
        if appRemote?.isConnected == false {
            Task { @MainActor in
                _ = await SpotifyConnectionService.shared.autorize()
            }
        } else {
            isPlaying ? api.pause(nil) : api.resume(nil)
        }
    }

    func toggleShuffleMode() {
        guard let api = appRemote?.playerAPI else { return }
        let next = !(lastPlayerState?.playbackOptions.isShuffling ?? false)
        api.setShuffle(next, callback: nil)
    }

    func toggleRepeatMode() {
        guard let api = appRemote?.playerAPI else { return }
        let current = lastPlayerState?.playbackOptions.repeatMode ?? .off
        let next: SPTAppRemotePlaybackOptionsRepeatMode = current == .off ? .context : .off
        api.setRepeatMode(next, callback: nil)
    }

    /// Воспроизвести трек по Spotify URI (например "spotify:track:6rqhFgbbKwnb9MLmUQDhG6").
    func play(spotifyURI: String) {
        appRemote?.playerAPI?.play(spotifyURI, callback: nil)
    }

    /// Перемотать на заданную позицию (секунды).
    func seek(to time: TimeInterval) {
        appRemote?.playerAPI?.seek(toPosition: Int(time * 1000), callback: nil)
        // Оптимистично обновляем UI не дожидаясь следующего playerStateDidChange.
        if let state = lastPlayerState {
            emitPlaybackModel(from: state, overridePosition: time)
        }
    }

    /// Следующий трек.
    func skipToNextEntry() {
        appRemote?.playerAPI?.skip(toNext: nil)
    }

    /// Предыдущий трек.
    func skipToPreviousEntry() {
        appRemote?.playerAPI?.skip(toPrevious: nil)
    }

    // MARK: - Private helpers

    private func startProgressTimer() {
        progressTimer = Timer.publish(every: 0.25, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self, self.isPlaying, let state = self.lastPlayerState else { return }
                self.emitPlaybackModel(from: state)
            }
    }

    private func emitPlaybackModel(
        from state: SPTAppRemotePlayerState,
        overridePosition: TimeInterval? = nil
    ) {
        let basePosition = TimeInterval(state.playbackPosition) / 1000.0
        let elapsed = Date().timeIntervalSince(lastStateReceivedAt)
        let currentTime = overridePosition ?? (state.isPaused ? basePosition : basePosition + elapsed)
        let duration = TimeInterval(state.track.duration) / 1000.0

        let model = PlaybackModel(
            currentTime: min(currentTime, duration),
            duration: duration,
            isPlaying: !state.isPaused,
            repeatMode: RepeatMode(spotifyMode: state.playbackOptions.repeatMode),
            shuffleMode: state.playbackOptions.isShuffling ? .on : .off
        )
        playbackPublisher.send(model)
    }

    private func emitTrackModel(from track: SPTAppRemoteTrack) {
        appRemote?.imageAPI?.fetchImage(
            forItem: track,
            with: CGSize(width: 120, height: 120)
        ) { [weak self] image, _ in
            var artworkURL: URL? = nil
            if let uiImage = image as? UIImage, let data = uiImage.jpegData(compressionQuality: 0.85) {
                let tmp = FileManager.default.temporaryDirectory
                    .appendingPathComponent("spotify_artwork_\(track.uri.hashValue).jpg")
                try? data.write(to: tmp)
                artworkURL = tmp
            }
            self?.trackPublisher.send(TrackModel(
                title: track.name,
                subtitle: track.artist.name,
                artwork: artworkURL
            ))
        }
    }
}

// MARK: - SPTAppRemotePlayerStateDelegate
// Живёт здесь: SpotifyMusicPlayer отвечает только за состояние плеера,
// тогда как SPTAppRemoteDelegate (lifecycle соединения) живёт в SpotifyConnectionService.

extension SpotifyMusicPlayer: SPTAppRemotePlayerStateDelegate {

    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        let previousURI = lastPlayerState?.track.uri
        lastPlayerState = playerState
        lastStateReceivedAt = Date()

        emitPlaybackModel(from: playerState)

        if playerState.track.uri != previousURI {
            emitTrackModel(from: playerState.track)
        }
    }
}

// MARK: - RepeatMode mapping

private extension RepeatMode {
    init(spotifyMode: SPTAppRemotePlaybackOptionsRepeatMode) {
        switch spotifyMode {
        case .off:
            self = .none
        case .track:
            self = .one
        case .context:
            self = .all
        @unknown default: self = .none
        }
    }
}
