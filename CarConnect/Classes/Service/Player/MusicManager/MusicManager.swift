//
//  MusicManager.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 07.06.2026.
//

import Foundation
import Combine
import RxSwift
import RxCocoa

protocol MusicSourceDelegate: AnyObject {
    func sourceDidChange(to source: MusicSource)
}

final class MusicManager {

    static let shared = MusicManager()

    private let trackRelay = BehaviorRelay<TrackModel?>(value: nil)
    private let playbackRelay = BehaviorRelay<PlaybackModel?>(value: nil)
    private let currentSourceRelay = BehaviorRelay<MusicSource?>(value: nil)
    private let playerRouteRelay = PublishRelay<MusicPlayerRoute>()
    
    var trackInfo: Driver<TrackModel?> { trackRelay.asDriver() }
    var playbackInfo: Driver<PlaybackModel?> { playbackRelay.asDriver() }
    var musicSource: Driver<MusicSource?> { currentSourceRelay.asDriver() }
    var playerRoute: Signal<MusicPlayerRoute> { playerRouteRelay.asSignal() }

    private(set) var currentSource: MusicSource?

    weak var sourceDelegate: MusicSourceDelegate?

    // MARK: - Private

    private let appleMusicPlayer: AppleMusicPlayer = .shared
    private let spotifyMusicPlayer: SpotifyMusicPlayer = .shared

    private var playerSubscriptions: Set<AnyCancellable> = []

    private init() {}
    
    func play(_ source: PlayMusicSource) {
        switch source {
        case .appleMusic(let startItem, let trackList):
            changeSource(to: .appleMusic)
            appleMusicPlayer.play(startItem, in: trackList)
        case .spotify:
            changeSource(to: .spotify)
            spotifyMusicPlayer.togglePlaybackStatus()
        }
    }
    
    var isPlaying: Bool {
        playbackRelay.value != nil
    }
    
    func showMusicScreen(for source: MusicSource) {
        changeSource(to: source)
    }

    func changeSource(to newSource: MusicSource) {
        guard currentSource != newSource else { return }

        pauseCurrentPlayer()

        currentSource = newSource
        currentSourceRelay.accept(newSource)

        switch newSource {
        case .appleMusic:
            bind(to: appleMusicPlayer)

        case .spotify:
            bind(to: spotifyMusicPlayer)

        case .radio:
            playerSubscriptions.removeAll()
            trackRelay.accept(nil)
            playbackRelay.accept(nil)
        }
    }
    
    func showPlayer(route: MusicPlayerRoute) {
        playerRouteRelay.accept(route)
    }

    func togglePlaybackStatus() {
        switch currentSource {
        case .appleMusic:
            appleMusicPlayer.togglePlaybackStatus()
        case .spotify:
            spotifyMusicPlayer.togglePlaybackStatus()
        case .radio, .none:
            break
        }
    }

    func toggleShuffleMode() {
        switch currentSource {
        case .appleMusic:
            appleMusicPlayer.toggleShuffleMode()
        case .spotify:
            spotifyMusicPlayer.toggleShuffleMode()
        case .radio, .none:
            break
        }
    }

    func toggleRepeatMode() {
        switch currentSource {
        case .appleMusic:
            appleMusicPlayer.toggleRepeatMode()
        case .spotify:
            spotifyMusicPlayer.toggleRepeatMode()
        case .radio, .none:
            break
        }
    }

    func seek(to time: TimeInterval) {
        switch currentSource {
        case .appleMusic:
            appleMusicPlayer.seek(to: time)
        case .spotify:
            spotifyMusicPlayer.seek(to: time)
        case .radio, .none:
            break
        }
    }

    func next() {
        switch currentSource {
        case .appleMusic:
            appleMusicPlayer.skipToNextEntry()
        case .spotify:
            spotifyMusicPlayer.skipToNextEntry()
        case .radio, .none:
            break
        }
    }

    func previos() {
        switch currentSource {
        case .appleMusic:
            appleMusicPlayer.skipToPreviousEntry()
        case .spotify:
            spotifyMusicPlayer.skipToPreviousEntry()
        case .radio, .none:
            break
        }
    }

    private func bind(to player: MusicPlayerProtocol) {
        playerSubscriptions.removeAll()

        player.trackPublisher
            .sink { [weak self] in self?.trackRelay.accept($0) }
            .store(in: &playerSubscriptions)

        player.playbackPublisher
            .sink { [weak self] in self?.playbackRelay.accept($0) }
            .store(in: &playerSubscriptions)
    }

    private func pauseCurrentPlayer() {
        switch currentSource {
        case .appleMusic:
            appleMusicPlayer.pause()
        case .spotify:
            spotifyMusicPlayer.pause()
        case .radio, .none:
            break
        }
    }
}
