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
    @MainActor private(set) var tracks = MusicItemCollection<Track>([])
    @MainActor private(set) var items: [TrackItem] = []
    @MainActor var onUpdate: (() -> Void)?
    let collectionID: MusicItemID
    
    private let source: TrackListSource
    
    private let pageSize: Int = 10
    
    private var currentTrackTask: Task<Void, Never>?
    
    private var cancellable: AnyCancellable?
    
    private let player = AppleMusicPlayer.shared
    
    init(source: TrackListSource) {
        self.source = source
        switch source {
        case .album(let album):
            title = album.title
            collectionID = album.id
        case .playlist(let playlist):
            title = playlist.name
            collectionID = playlist.id
        }
    }
    
    func fetchTracks() async {
        do {
            let content: MusicItemCollection<Track>
            switch source {
            case .album(let album):
                content = try await album.with(.tracks).tracks ?? MusicItemCollection<Track>([])
            case .playlist(let playlist):
                content = try await playlist.with(.tracks).tracks ?? MusicItemCollection<Track>([])
            }
            
            let items = content.map { track in
                return TrackItem(track: track, isPlaying: player.isPlaying(track: track))
            }
            await MainActor.run {
                tracks = content
                self.items = items
            }
        } catch {
            
        }
        
        await MainActor.run {
            onUpdate?()
        }
    }
    
    func observePlayingTrack() {
        cancellable = AppleMusicPlayer.shared.trackPublisher
            .receive(on: DispatchQueue.main)
            .print()
            .sink { [weak self] model in
                guard let self else { return }
                
                items = items.map {
                    TrackItem(track: $0.track, isPlaying: self.player.isPlaying(track: $0.track))
                }
                
                onUpdate?()
            }
//        guard currentTrackTask == nil || currentTrackTask?.isCancelled == true else { return }
//        currentTrackTask = Task {
//            for await model in AppleMusicPlayer.shared.trackPublisher.values {
//                print("INFO: \(model)")
//                guard let id = model?.id, let index = items.firstIndex(where: { $0.track.id.rawValue == id }) else { return }
//                
//                await MainActor.run {
//                    items[index] = TrackItem(track: items[index].track, isPlaying: true)
//                }
//            }
//        }
    }
    
    func loadNext() async {
        guard tracks.hasNextBatch else { return }
        do {
            guard let next = try await tracks.nextBatch(limit: pageSize) else { return }
            let items = next.map { track in
                return TrackItem(track: track, isPlaying: player.isPlaying(track: track))
            }
            
            await MainActor.run {
                tracks = next
                self.items = items
                onUpdate?()
            }
        } catch {
            
        }
    }
}
