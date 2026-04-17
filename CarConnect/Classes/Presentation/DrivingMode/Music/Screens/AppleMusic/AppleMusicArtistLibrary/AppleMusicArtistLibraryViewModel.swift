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
    @MainActor private(set) var albums = MusicItemCollection<Album>([])
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
            
            await MainActor.run {
                albums = content
                onUpdate?()
            }
        } catch {
            
        }
    }
    
    func loadNext() async {
        guard albums.hasNextBatch else { return }
        do {
            guard let next = try await albums.nextBatch(limit: pageSize) else { return }
            
            await MainActor.run {
                albums = next
                onUpdate?()
            }
        } catch {
            
        }
    }
}
