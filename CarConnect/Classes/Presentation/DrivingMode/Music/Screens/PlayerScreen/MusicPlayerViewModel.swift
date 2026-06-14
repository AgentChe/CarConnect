//
//  MusicPlayerViewModel.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 24.03.2026.
//

import Foundation
import MusicKit
import Combine
import RxSwift
import RxCocoa

enum PlayMusicSource {
    case appleMusic(startItem: Track, trackList: MusicItemCollection<Track>?)
    case spotify
}

final class MusicPlayerViewModel {
    
    let source: PlayMusicSource
    
    private let playerManager = MusicManager.shared
    private let messageRelay = PublishRelay<String?>()
    
    struct Input {}
    struct Output {
        let trackInfo: Driver<TrackModel?>
        let playbackInfo: Driver<PlaybackModel?>
        let message: Signal<String?>
    }
    
    init(source: PlayMusicSource) {
        self.source = source
    }
    
    func configure(input: Input) -> Output {
        playerManager.play(source)
        
        return Output(
            trackInfo: playerManager.trackInfo,
            playbackInfo: playerManager.playbackInfo,
            message: messageRelay.asSignal()
        )
    }
}

extension MusicPlayerViewModel: MusicPlayerProgressDelegate {
    func valueDidChange(value: TimeInterval) {
        
        switch source {
        case .appleMusic:
            playerManager.seek(to: value)
        case .spotify:
            if SpotifyConnectionService.shared.userIsPremium.value {
                playerManager.seek(to: value)
            } else {
                messageRelay.accept("Spotify.CapabilitiesWarning.Seek".localized)
            }
        }
    }
}

extension MusicPlayerViewModel: MusicPlayerControlsDelegate {
    func didTapNext() {
        playerManager.next()
    }
    
    func didTapPrevios() {
        playerManager.previos()
    }
    
    func didTapPlayPause() {
        playerManager.togglePlaybackStatus()
    }
    
    func didTapShuffleMode() {
        switch source {
        case .appleMusic:
            playerManager.toggleShuffleMode()
            AppleMusicPlayer.shared.toggleShuffleMode()
        case .spotify:
            if SpotifyConnectionService.shared.userIsPremium.value {
                playerManager.toggleShuffleMode()
            } else {
                messageRelay.accept("Spotify.CapabilitiesWarning.Shuffle".localized)
            }
        }
    }
    
    func didTapRepeatMode() {
        switch source {
        case .appleMusic:
            playerManager.toggleRepeatMode()
        case .spotify:
            if SpotifyConnectionService.shared.userIsPremium.value {
                playerManager.toggleRepeatMode()
            } else {
                messageRelay.accept("Spotify.CapabilitiesWarning.Repeat".localized)
            }
        }
    }
}
