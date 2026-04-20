//
//  AppleMusicCollectionService.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 05.04.2026.
//

import MusicKit
import Foundation

// TODO: Разобраться с nonisolated
nonisolated enum CollectionType: Identifiable, Hashable, Equatable, Sendable {
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

enum TrackListSource {
    case album(Album)
    case playlist(Playlist)
}

final class AppleMusicCollectionService {
    
    func fetchAlbums(limit: Int, offset: Int) async throws -> [CollectionType] {
        var request = MusicLibraryRequest<Album>()
        request.limit = limit
        request.offset = offset
        request.sort(by: \.title, ascending: true)
        
        let response = try await request.response()
        return response.items.map { .album($0) }
    }
    
    func fetchPlaylists(limit: Int, offset: Int) async throws -> [CollectionType] {
        var request = MusicLibraryRequest<Playlist>()
        request.limit = limit
        request.offset = offset
        request.sort(by: \.name, ascending: true)
        
        let response = try await request.response()
        return response.items.map { .playlist($0) }
    }
    
    func fetchTracks(limit: Int, offset: Int) async throws -> [CollectionType] {
        var request = MusicLibraryRequest<Track>()
        request.limit = limit
        request.offset = offset
        request.sort(by: \.title, ascending: true)
        
        let response = try await request.response()
        return response.items.map { .track($0, isPlaying: AppleMusicPlayer.shared.isPlaying(track: $0)) }
    }
    
    func fetchArtists(limit: Int, offset: Int) async throws -> [CollectionType] {
        var request = MusicLibraryRequest<Artist>()
        request.limit = limit
        request.offset = offset
        request.sort(by: \.name, ascending: true)
        
        let response = try await request.response()
        return response.items.map { .artist($0)}
    }
    
    func fetchLibraryContent(category: AppleMusicLibraryCategory, limit: Int, offset: Int) async throws -> [CollectionType] {
        switch category {
        case .playlists:
            try await fetchPlaylists(limit: limit, offset: offset)
        case .artists:
            try await fetchArtists(limit: limit, offset: offset)
        case .albums:
            try await fetchAlbums(limit: limit, offset: offset)
        case .songs:
            try await fetchTracks(limit: limit, offset: offset)
        }
    }
}
