//
//  AppleMusicLibraryItem.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 25.03.2026.
//

import Foundation
import MusicKit

struct AppleMusicLibraryRecentItem: Hashable {
    let id: MusicItemID
    let title: String
    let type: ContentType
    let artworkURL: URL?
    
    enum ContentType: Hashable {
        case album
        case playlist
        case station
        case song
    }
}

extension AppleMusicLibraryRecentItem.ContentType {
    var title: String {
        switch self {
        case .album:
            "AppleMusic.RecentContent.Album".localized
        case .playlist:
            "AppleMusic.RecentContent.Playlist".localized
        case .station:
            "AppleMusic.RecentContent.Station".localized
        case .song:
            "AppleMusic.RecentContent.Song".localized
        }
    }
}

extension AppleMusicLibraryRecentItem {
    init(collection: CollectionType) {
        switch collection {
        case .playlist(let playlist):
            id = playlist.id
            title = playlist.name
            type = .playlist
            artworkURL = playlist.artwork?.url(width: 100, height: 100)
        case .album(let album):
            id = album.id
            title = album.title
            type = .album
            artworkURL = album.artwork?.url(width: 100, height: 100)
        case .artist(let artist):
            id = artist.id
            title = artist.name
            type = .album
            artworkURL = artist.artwork?.url(width: 100, height: 100)
        case .track(let track, _):
            id = track.id
            title = track.title
            type = .song
            artworkURL = track.artwork?.url(width: 100, height: 100)
        }
    }
}

// TODO: Разобраться с nonisolated
nonisolated enum AppleMusicLibraryItem: Hashable {
    case recent(item: CollectionType)
    case category(AppleMusicLibraryCategory)
    case searchResult(item: CollectionType)
}
