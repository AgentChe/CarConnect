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
    func fetchRecentlyPlayed(limit: Int, offset: Int) async throws -> [CollectionType] {
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
        
        let recentItems: [(lastPlayed: Date?, content: CollectionType)] = recent.items
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
        
        let tracksItems: [(lastPlayed: Date?, content: CollectionType)] = tracks.items
            .compactMap { track in
                return (track.lastPlayedDate, .track(track))
            }
        
        return (recentItems + tracksItems)
            .sorted { ($0.lastPlayed ?? Date.distantPast) > ($1.lastPlayed ?? Date.distantPast) }
            .map(\.content)
    }
    
//    func fetchRecentlyPlayed(limit: Int, offset: Int) async throws -> [AppleMusicLibraryRecentItem] {
//        let recentRequest: MusicRecentlyPlayedRequest<RecentlyPlayedMusicItem> = {
//            var request = MusicRecentlyPlayedRequest<RecentlyPlayedMusicItem>()
//            request.limit = limit
//            request.offset = offset
//            return request
//        }()
//
//        let songsRequest: MusicRecentlyPlayedRequest<Track> = {
//            var request = MusicRecentlyPlayedRequest<Track>()
//            request.limit = limit
//            request.offset = offset
//            return request
//        }()
//        
//        async let recentResponse = recentRequest.response()
//        async let songsResponse = songsRequest.response()
//        
//        let (recent, songs) = try await (recentResponse, songsResponse)
//
//        let recentItems: [AppleMusicLibraryRecentItem] = recent.items
//            .compactMap { item in
//                AppleMusicLibraryRecentItem(item: item)
//            }
//        let songItems = songs.items.map { item in
//            AppleMusicLibraryRecentItem(
//                id: item.id,
//                title: item.title,
//                type: .song,
//                artworkURL: item.artwork?.url(width: 100, height: 100),
//                lastPlayed: item.lastPlayedDate
//            )
//        }
//        
//        return (recentItems + songItems)
//            .sorted { ($0.lastPlayed ?? Date.distantPast) > ($1.lastPlayed ?? Date.distantPast) }
//    }
    
    func fetchAlbums(limit: Int, offset: Int) async throws -> [MusicLibraryItem] {
        var request = MusicLibraryRequest<Album>()
        request.limit = limit
        request.offset = offset
        request.sort(by: \.title, ascending: true)
        
        let response = try await request.response()
        return response.items.map(MusicLibraryItem.init)
    }
    
    func fetchAlbums(limit: Int, offset: Int, artistID: String) async throws -> [MusicLibraryItem] {
        var request = MusicLibraryRequest<Album>()
        request.limit = limit
        request.offset = offset
        request.sort(by: \.title, ascending: true)
        
        let response = try await request.response()
        return response.items.map(MusicLibraryItem.init)
    }
    
    func fetchPlaylists(limit: Int, offset: Int) async throws -> [MusicLibraryItem] {
        var request = MusicLibraryRequest<Playlist>()
        request.limit = limit
        request.offset = offset
        request.sort(by: \.name, ascending: true)
        
        let response = try await request.response()
        return response.items.map(MusicLibraryItem.init)
    }
    
    func fetchSongs(limit: Int, offset: Int) async throws -> [MusicLibraryItem] {
        var request = MusicLibraryRequest<Song>()
        request.limit = limit
        request.offset = offset
        request.sort(by: \.title, ascending: true)
        
        let response = try await request.response()
        return response.items.map(MusicLibraryItem.init)
    }
    
    func fetchArtists(limit: Int, offset: Int) async throws -> [MusicLibraryItem] {
        var request = MusicLibraryRequest<Artist>()
        request.limit = limit
        request.offset = offset
        request.sort(by: \.name, ascending: true)
        
        let response = try await request.response()
        return response.items.map(MusicLibraryItem.init)
    }
    
    func fetchLibraryContent(category: AppleMusicLibraryCategory, limit: Int, offset: Int) async throws -> [MusicLibraryItem] {
        switch category {
        case .playlists:
            try await fetchPlaylists(limit: limit, offset: offset)
        case .artists:
            try await fetchArtists(limit: limit, offset: offset)
        case .albums:
            try await fetchAlbums(limit: limit, offset: offset)
        case .songs:
            try await fetchSongs(limit: limit, offset: offset)
        }
    }
    
}

//private extension AppleMusicLibraryRecentItem {
//    init?(item: RecentlyPlayedMusicItem) {
//        let contentType: ContentType?
//        let lastPlayedDate: Date?
//        switch item {
//        case let .album(album):
//            lastPlayedDate = album.lastPlayedDate
//            contentType = .album
//        case let .playlist(playlist):
//            lastPlayedDate = playlist.lastPlayedDate
//            contentType = .playlist
//        case let .station(station):
//            lastPlayedDate = nil
//            contentType = .station
//        @unknown default:
//            lastPlayedDate = nil
//            contentType = nil
//        }
//        
//        guard let contentType else { return nil }
//        
//        self.init(
//            id: item.id,
//            title: item.title,
//            type: contentType,
//            artworkURL: item.artwork?.url(width: 320, height: 320),
//            lastPlayed: lastPlayedDate
//        )
//    }
//}
