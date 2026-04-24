//
//  AppleMusicService.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 26.03.2026.
//

import MusicKit
import UIKit

final class AppleMusicService {
    var isAuthorized: Bool {
        MusicAuthorization.currentStatus == .authorized
    }
    
    func requestAuthorization() async -> Bool {
        switch MusicAuthorization.currentStatus {
        case .notDetermined:
            let status = await MusicAuthorization.request()
            return status == .authorized
        case .denied:
            return false
        case .authorized:
            return true
        case .restricted:
            return false
        @unknown default:
            return false
        }
    }
    
    func fetchRecentlyPlayed(limit: Int, offset: Int) async throws -> [AppleMusicCollectionType] {
        let recentRequest: MusicRecentlyPlayedRequest<RecentlyPlayedMusicItem> = {
            var request = MusicRecentlyPlayedRequest<RecentlyPlayedMusicItem>()
            request.limit = limit
            request.offset = offset
            return request
        }()

        let tracksRequest: MusicRecentlyPlayedRequest<Track> = {
            var request = MusicRecentlyPlayedRequest<Track>()
            request.limit = limit
            request.offset = offset
            return request
        }()
        
        async let recentResponse = recentRequest.response()
        async let tracksResponse = tracksRequest.response()
        
        let (recent, tracks) = try await (recentResponse, tracksResponse)
        
        let recentItems: [(lastPlayed: Date?, content: AppleMusicCollectionType)] = recent.items
            .compactMap { item in
                switch item {
                case .album(let album):
                    return (album.lastPlayedDate, .album(album))
                case .playlist(let playlist):
                    return (playlist.lastPlayedDate, .playlist(playlist))
                case .station:
                    return nil
                @unknown default:
                    return nil
                }
            }
        
        let tracksItems: [(lastPlayed: Date?, content: AppleMusicCollectionType)] = tracks.items
            .compactMap { track in
                return (track.lastPlayedDate, .track(track, isPlaying: false))
            }
        
        return (recentItems + tracksItems)
            .sorted { ($0.lastPlayed ?? Date.distantPast) > ($1.lastPlayed ?? Date.distantPast) }
            .map(\.content)
    }
    
    
    func search(term: String, limit: Int) async throws -> MusicCatalogSearchSuggestionsResponse {
        var request = MusicCatalogSearchSuggestionsRequest(
            term: term,
            includingTopResultsOfTypes: [Album.self, Song.self, Artist.self]
        )
        
        request.limit = limit
        
        return try await request.response()
    }
    
    func fetchAlbums(limit: Int, offset: Int) async throws -> [AppleMusicCollectionType] {
        var request = MusicLibraryRequest<Album>()
        request.limit = limit
        request.offset = offset
        request.sort(by: \.title, ascending: true)
        
        let response = try await request.response()
        return response.items.map { .album($0) }
    }
    
    func fetchPlaylists(limit: Int, offset: Int) async throws -> [AppleMusicCollectionType] {
        var request = MusicLibraryRequest<Playlist>()
        request.limit = limit
        request.offset = offset
        request.sort(by: \.name, ascending: true)
        
        let response = try await request.response()
        return response.items.map { .playlist($0) }
    }
    
    func fetchTracks(limit: Int, offset: Int) async throws -> [AppleMusicCollectionType] {
        var request = MusicLibraryRequest<Track>()
        request.limit = limit
        request.offset = offset
        request.sort(by: \.title, ascending: true)
        
        let response = try await request.response()
        return response.items.map { .track($0, isPlaying: AppleMusicPlayer.shared.isPlaying(track: $0)) }
    }
    
    func fetchArtists(limit: Int, offset: Int) async throws -> [AppleMusicCollectionType] {
        var request = MusicLibraryRequest<Artist>()
        request.limit = limit
        request.offset = offset
        request.sort(by: \.name, ascending: true)
        
        let response = try await request.response()
        return response.items.map { .artist($0)}
    }
    
    func fetchLibraryContent(category: AppleMusicLibraryCategory, limit: Int, offset: Int) async throws -> [AppleMusicCollectionType] {
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
