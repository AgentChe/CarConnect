//
//  MusicPlayerViewModel.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 24.03.2026.
//

import Foundation
import MusicKit
import Combine

final class MusicPlayerViewModel {
    
    @MainActor var onUpdateTrack: ((TrackModel) -> Void)?
    @MainActor var onUpdateState: ((PlaybackModel) -> Void)?
    @MainActor var showMessage: ((String) -> Void)?
    
    private var cancellation: [AnyCancellable] = []
    
    private let source: Source
    
    init(source: Source) {
        self.source = source
    }
    
    func start() {
        switch source {
        case .appleMusic(let startItem, let musicItemCollection, let parentCollectionID):
            startAppleMusic(startItem: startItem, trackList: musicItemCollection, parentCollectionID: parentCollectionID)
        case .spotify:
            startSpotifyMusic()
        }
    }
    
    private func startAppleMusic(startItem: Track, trackList: MusicItemCollection<Track>?, parentCollectionID: MusicItemID?) {
        let player = AppleMusicPlayer.shared
        
        player.trackPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let model else { return }
                self?.onUpdateTrack?(model)
            }
            .store(in: &cancellation)
        
        player.playbackPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let model else { return }
                self?.onUpdateState?(model)
            }
            .store(in: &cancellation)
        
        player.play(startItem, in: trackList, with: parentCollectionID)
    }
    
    private func startSpotifyMusic() {
        let player = SpotifyMusicPlayer.shared
        
        player.trackPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let model else { return }
                self?.onUpdateTrack?(model)
            }
            .store(in: &cancellation)
        
        player.playbackPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let model else { return }
                self?.onUpdateState?(model)
            }
            .store(in: &cancellation)
        
        player.play(spotifyURI: "")
    }
}

extension MusicPlayerViewModel {
    enum Source {
        case appleMusic(startItem: Track, trackList: MusicItemCollection<Track>?, parentCollectionID: MusicItemID?)
        case spotify
    }
}

extension MusicPlayerViewModel: MusicPlayerProgressDelegate {
    func valueDidChange(value: TimeInterval) {
        switch source {
        case .appleMusic:
            AppleMusicPlayer.shared.seek(to: value)
        case .spotify:
            if SpotifyConnectionService.shared.userIsPremium.value {
                SpotifyMusicPlayer.shared.seek(to: value)
            } else {
                Task { @MainActor in
                    showMessage?("Spotify.CapabilitiesWarning.Seek".localized)
                }
            }
        }
    }
}

extension MusicPlayerViewModel: MusicPlayerControlsDelegate {
    func didTapNext() {
        switch source {
        case .appleMusic:
            AppleMusicPlayer.shared.skipToNextEntry()
        case .spotify:
            SpotifyMusicPlayer.shared.skipToNextEntry()
        }
    }
    
    func didTapPrevios() {
        switch source {
        case .appleMusic:
            AppleMusicPlayer.shared.skipToPreviousEntry()
        case .spotify:
            SpotifyMusicPlayer.shared.skipToPreviousEntry()
        }
    }
    
    func didTapPlayPause() {
        switch source {
        case .appleMusic:
            AppleMusicPlayer.shared.togglePlaybackStatus()
        case .spotify:
            SpotifyMusicPlayer.shared.togglePlaybackStatus()
        }
    }
    
    func didTapShuffleMode() {
        switch source {
        case .appleMusic:
            AppleMusicPlayer.shared.toggleShuffleMode()
        case .spotify:
            if SpotifyConnectionService.shared.userIsPremium.value {
                SpotifyMusicPlayer.shared.toggleShuffleMode()
            } else {
                showMessage?("Spotify.CapabilitiesWarning.Shuffle".localized)
            }
        }
    }
    
    func didTapRepeatMode() {
        switch source {
        case .appleMusic:
            AppleMusicPlayer.shared.toggleRepeatMode()
        case .spotify:
            if SpotifyConnectionService.shared.userIsPremium.value {
                SpotifyMusicPlayer.shared.toggleRepeatMode()
            } else {
                showMessage?("Spotify.CapabilitiesWarning.Repeat".localized)
            }
        }
    }
}
