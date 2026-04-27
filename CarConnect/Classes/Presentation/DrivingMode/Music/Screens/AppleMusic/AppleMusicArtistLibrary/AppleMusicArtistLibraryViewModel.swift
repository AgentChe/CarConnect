//
//  AppleMusicArtistLibraryViewModel.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 09.04.2026.
//

import Foundation
import MusicKit

final class AppleMusicArtistLibraryModel {
    
    @MainActor let title: String
    @MainActor private var albums = MusicItemCollection<Album>([])
    @MainActor private(set) var items: [Album] = []
    @MainActor var onUpdate: (() -> Void)?
    
    private let artist: Artist
    private let pageSize: Int = 10
    
    init(artist: Artist) {
        self.artist = artist
        title = artist.name
    }
    
    func fetchAlbums() async {
        do {
            let content = try await artist.with([.albums]).albums ?? MusicItemCollection<Album>([])
            let elements = content.map { $0 }
            await MainActor.run {
                albums = content
                items = elements
                onUpdate?()
            }
        } catch {
            
        }
    }
    
    func loadNext() async {
        guard albums.hasNextBatch else { return }
        do {
            guard let next = try await albums.nextBatch(limit: pageSize) else { return }
            let newItems = items.merge(new: next.map { $0 })
            await MainActor.run {
                albums = next
                items = newItems
                onUpdate?()
            }
        } catch {
            
        }
    }
}

extension Array where Element: Identifiable {
    func merge(new: [Element]) -> Self {
        var containsIDs: Set<Element.ID> = []
        
        return (self + new)
            .compactMap { item -> Element? in
                guard !containsIDs.contains(item.id) else { return nil }
                containsIDs.insert(item.id)
                return item
            }
    }
}
