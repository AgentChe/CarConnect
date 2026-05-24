//
//  AppleMusicCollectionType.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 24.04.2026.
//

import Foundation
import MusicKit

nonisolated enum AppleMusicCollectionType: Identifiable, Hashable, Equatable, Sendable {
    case playlist(Playlist)
    case album(Album)
    case artist(Artist)
    case track(Track, isPlaying: Bool)
    
    var id: MusicItemID {
        switch self {
        case .playlist(let playlist):
            playlist.id
        case .album(let album):
            album.id
        case .artist(let artist):
            artist.id
        case .track(let track, _):
            track.id
        }
    }
    
    var lastPlayed: Date? {
        switch self {
        case .playlist(let playlist):
            playlist.lastPlayedDate
        case .album(let album):
            album.lastPlayedDate
        case .artist:
            nil
        case .track(let track, _):
            track.lastPlayedDate
        }
    }
}
