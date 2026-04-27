//
//  MusicLibraryItem.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 29.03.2026.
//

import Foundation
import MusicKit

// TODO: Разобраться с nonisolated
nonisolated struct MusicLibraryItem: Hashable, Sendable {
    let id: String
    let title: String
    let subtitle: String?
    let artworkURL: URL?
    let category: AppleMusicLibraryCategory
    let hasDetail: Bool
}

extension MusicLibraryItem {

    init(song: Song) {
        id = song.id.rawValue
        title = song.title
        subtitle = song.artistName
        artworkURL = song.artwork?.url(width: 120, height: 120)
        category = .songs
        hasDetail = false
    }
    
    init(album: Album) {
        id = album.id.rawValue
        title = album.title
        subtitle = album.artistName
        artworkURL = album.artwork?.url(width: 120, height: 120)
        category = .albums
        hasDetail = true
    }
    
    init(playlist: Playlist) {
        id = playlist.id.rawValue
        title = playlist.name
        subtitle = playlist.curatorName
        artworkURL = playlist.artwork?.url(width: 120, height: 120)
        category = .playlists
        hasDetail = true
    }
    
    init(artist: Artist) {
        id = artist.id.rawValue
        title = artist.name
        subtitle = nil
        artworkURL = artist.artwork?.url(width: 120, height: 120)
        category = .artists
        hasDetail = true
    }
}
