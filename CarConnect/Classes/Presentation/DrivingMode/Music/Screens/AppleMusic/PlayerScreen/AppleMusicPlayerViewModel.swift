//
//  AppleMusicPlayerViewModel.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 24.03.2026.
//

import Foundation
import MusicKit
import Combine

final class AppleMusicPlayerViewModel {
    
    private let startItem: Track
    private let trackList: MusicItemCollection<Track>?
    private let parentCollectionID: MusicItemID?
    
    @MainActor var onUpdateTrack: ((AppleMusicPlayer.TrackModel) -> Void)?
    @MainActor var onUpdateState: ((AppleMusicPlayer.PlaybackModel) -> Void)?
    
    private let player = AppleMusicPlayer.shared
    
    private var cancellation: [AnyCancellable] = []
    
    init(startItem: Track, trackList: MusicItemCollection<Track>?, parentCollectionID: MusicItemID?) {
        self.startItem = startItem
        self.trackList = trackList
        self.parentCollectionID = parentCollectionID
    }
    
    func start() {
        player.trackPublisher
            .receive(on: DispatchQueue.main)
            .print()
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
        
        AppleMusicPlayer.shared.play(startItem, in: trackList, with: parentCollectionID)
    }
}

extension AppleMusicPlayerViewModel: MusicPlayerProgressDelegate {
    func valueDidChange(value: TimeInterval) {
        player.seek(to: value)
    }
}

extension AppleMusicPlayerViewModel: MusicPlayerControlsDelegate {
    func didTapNext() {
        player.skipToNextEntry()
    }
    
    func didTapPrevios() {
        player.skipToPreviousEntry()
    }
    
    func didTapPlayPause() {
        player.togglePlaybackStatus()
    }
    
    func didTapShuffleMode() {
        player.toggleShuffleMode()
    }
    
    func didTapRepeatMode() {
        player.toggleRepeatMode()
    }
}
