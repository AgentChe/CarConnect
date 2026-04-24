//
//  AppleMusicTrackListViewModel.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 31.03.2026.
//

import Foundation
import MusicKit
import Combine

final class AppleMusicTrackListViewModel {
    // MARK: - Output

    @MainActor let title: String
    @MainActor private(set) var trackCollection = MusicItemCollection<Track>([])
    @MainActor private(set) var items: [TrackItem] = []
    @MainActor private(set) var isLoading: Bool = false
    @MainActor var onUpdate: (() -> Void)?
    
    let collectionID: MusicItemID
    
    private let source: AppleMusicTrackListSource
    private let player = AppleMusicPlayer.shared
    private var cancellable: AnyCancellable?
    
    init(source: AppleMusicTrackListSource) {
        self.source = source
        switch source {
        case .album(let album):
            title = album.title
            collectionID = album.id
        case .playlist(let playlist):
            title = playlist.name
            collectionID = playlist.id
        }
        
        observePlayingTrack()
    }
    
    func fetchTracks() async {
        await MainActor.run {
            isLoading = true
            onUpdate?()
        }
        let content: MusicItemCollection<Track>
        switch source {
        case .album(let album):
            content = (try? await album.with(.tracks).tracks) ?? MusicItemCollection<Track>([])
        case .playlist(let playlist):
            content = (try? await playlist.with(.tracks).tracks) ?? MusicItemCollection<Track>([])
        }
        
        let elements = content.map { TrackItem(track: $0) }
        
        await MainActor.run {
            trackCollection = content
            items = elements
            isLoading = false
            onUpdate?()
        }
    }
    
    func loadNext() async {
        guard trackCollection.hasNextBatch else { return }
        guard let next = try? await trackCollection.nextBatch(limit: 10) else { return }
        
        let elements = next.map { TrackItem(track: $0)}
        let newItems = items.merge(new: elements)
        
        await MainActor.run {
            trackCollection = next
            items = newItems
            onUpdate?()
        }
    }
}

private extension AppleMusicTrackListViewModel {
    func observePlayingTrack() {
        cancellable = AppleMusicPlayer.shared.trackPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                items = items.map { TrackItem(track: $0.track) }
                onUpdate?()
            }
    }
}

private extension TrackItem {
    init(track: Track) {
        self.track = track
        self.isPlaying = AppleMusicPlayer.shared.isPlaying(track: track)
    }
}
