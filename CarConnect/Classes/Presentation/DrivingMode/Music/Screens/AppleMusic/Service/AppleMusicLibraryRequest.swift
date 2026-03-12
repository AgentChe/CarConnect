//
//  AppleMusicLibraryRequest.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 12.03.2026.
//

import MusicKit
import Foundation

final class AppleMusicLibraryRequest {
    func albums(limit: Int, offset: Int, completion: @escaping ([MKAlbum]?, Error?) -> Void) {
        Task {
            var request = MusicLibraryRequest<Album>()
            request.limit = limit
            request.offset = offset
            
            do {
                let response = try await request.response()
                
                let albums = response.items.compactMap { album -> MKAlbum? in
                    MKAlbum(album: album)
                }
                
                DispatchQueue.main.async {
                    completion(albums, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    func albumDetails(id: String, completion: @escaping (MKAlbum?, Error?) -> Void) {
        Task {
            var request = MusicLibraryRequest<Album>()
            request.limit = 0
            request.offset = 0
            
            do {
                let response = try await request.response()
                
                guard let album = try await response.items.first(where: { $0.id.rawValue == id })?.with([.tracks]) else {
                    DispatchQueue.main.async {
                        completion(nil, NSError(domain: "Album not found", code: 404))
                    }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    completion(MKAlbum(album: album), nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    func artists(limit: Int, offset: Int, completion: @escaping ([MKArtist]?, Error?) -> Void) {
        Task {
            var request = MusicLibraryRequest<Artist>()
            request.limit = limit
            request.offset = offset
            
            do {
                let response = try await request.response()
                let artists = try await withThrowingTaskGroup(of: MKArtist?.self) { group in
                    for artist in response.items {
                        group.addTask {
                            let artistWithAlbums = try await artist.with([.albums])
                            return MKArtist(artist: artistWithAlbums)
                        }
                    }
                    
                    var results = [MKArtist]()
                    for try await artist in group {
                        if let artist = artist {
                            results.append(artist)
                        }
                    }
                    return results
                }
                
                DispatchQueue.main.async {
                    completion(artists, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    func genres(limit: Int, offset: Int, completion: @escaping ([MKGenre]?, Error?) -> Void) {
        Task {
            var request = MusicLibraryRequest<Genre>()
            request.limit = limit
            request.offset = offset
            
            do {
                let response = try await request.response()
                
                let genres = response.items.compactMap { genre -> MKGenre? in
                    MKGenre(genre: genre)
                }
                
                DispatchQueue.main.async {
                    completion(genres, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    func playlists(limit: Int, offset: Int, completion: @escaping ([MKPlaylist]?, Error?) -> Void) {
        Task {
            var request = MusicLibraryRequest<Playlist>()
            request.limit = limit
            request.offset = offset
            
            do {
                let response = try await request.response()
                
                let playlists = response.items.compactMap { playlist -> MKPlaylist? in
                    MKPlaylist(playlist: playlist)
                }
                
                DispatchQueue.main.async {
                    completion(playlists, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    func playlistDetails(id: String, completion: @escaping (MKPlaylist?, Error?) -> Void) {
        Task {
            var request = MusicLibraryRequest<Playlist>()
            request.limit = 0
            request.offset = 0
            
            do {
                let response = try await request.response()
                
                guard let playlist = try await response.items.first(where: { $0.id.rawValue == id })?.with([.tracks]) else {
                    DispatchQueue.main.async {
                        completion(nil, NSError(domain: "Album not found", code: 404))
                    }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    completion(MKPlaylist(playlist: playlist, filterLocalOnly: true), nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    func entries(limit: Int, offset: Int, completion: @escaping ([MKPlaylistEntry]?, Error?) -> Void) {
        Task {
            var request = MusicLibraryRequest<Playlist.Entry>()
            request.limit = limit
            request.offset = offset
            
            do {
                let response = try await request.response()
                
                let entries = response.items.compactMap { entry -> MKPlaylistEntry? in
                    MKPlaylistEntry(entry: entry)
                }
                
                DispatchQueue.main.async {
                    completion(entries, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    func songs(limit: Int, offset: Int, term: String? = nil, completion: @escaping ([MKSong]?, Error?) -> Void) {
        Task {
            var request = MusicLibraryRequest<Song>()
            request.limit = limit
            request.offset = offset
            
            if let searchTerm = term, !searchTerm.isEmpty {
                request.filter(text: searchTerm)
            }
            
            do {
                let response = try await request.response()
                
                let songs = response.items.compactMap { song -> MKSong? in
                    MKSong(song: song)
                }
                
                DispatchQueue.main.async {
                    completion(songs, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    func tracks(limit: Int, offset: Int, completion: @escaping ([MKTrack]?, Error?) -> Void) {
        Task {
            var request = MusicLibraryRequest<Track>()
            request.limit = limit
            request.offset = offset
            
            do {
                let response = try await request.response()
                
                let tracks = response.items.compactMap { track -> MKTrack? in
                    MKTrack(track: track)
                }
                
                DispatchQueue.main.async {
                    completion(tracks, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    func fetchArtistAlbums(id: String, completion: @escaping ([MKAlbum]?, Error?) -> Void) {
        Task {
            var request = MusicLibraryRequest<Artist>()
            request.filter(matching: \.id, equalTo: MusicItemID(id))
            
            do {
                let response = try await request.response()
                
                guard let artist = try await response.items.first(where: { $0.id.rawValue == id })?.with([.albums]) else {
                    DispatchQueue.main.async {
                        completion(nil, NSError(domain: "Artist not found", code: 404))
                    }
                    
                    return
                }
                
                let albums = artist.albums?.compactMap { album -> MKAlbum? in
                    MKAlbum(album: album)
                }
                
                DispatchQueue.main.async {
                    completion(albums, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    func recentlyPlayed(completion: @escaping ([Any]?, Error?) -> Void) {
        Task {
            do {
                let limit = 5
                
                // 1. Songs: Use Library request sorted by lastPlayedDate
                var songsRequest = MusicLibraryRequest<Song>()
                songsRequest.sort(by: \.lastPlayedDate, ascending: false)
                songsRequest.limit = limit
                
                // 2. Playlists: Use Library request sorted by lastPlayedDate
                var playlistsRequest = MusicLibraryRequest<Playlist>()
                playlistsRequest.sort(by: \.lastPlayedDate, ascending: false)
                playlistsRequest.limit = limit
                
                // 3. Albums: Use Library request sorted by lastPlayedDate
                var albumsRequest = MusicLibraryRequest<Album>()
                albumsRequest.sort(by: \.lastPlayedDate, ascending: false)
                albumsRequest.limit = limit
                
                // Execute requests concurrently
                async let songsResponse = try? songsRequest.response()
                async let playlistsResponse = try? playlistsRequest.response()
                async let albumsResponse = try? albumsRequest.response()
                
                let (songs, playlists, albums) = await (songsResponse, playlistsResponse, albumsResponse)
                
                // Convert to wrappers
                let mkSongs = songs?.items.map { MKSong(song: $0) } ?? []
                let mkPlaylists = playlists?.items.map { MKPlaylist(playlist: $0) } ?? []
                let mkAlbums = albums?.items.compactMap { MKAlbum(album: $0) } ?? []
                
                // Merge all items
                var allItems: [Any] = []
                allItems.append(contentsOf: mkSongs)
                allItems.append(contentsOf: mkPlaylists)
                allItems.append(contentsOf: mkAlbums)
                
                // Sort by lastPlayedDate (newest first)
                let sortedItems = allItems.sorted { item1, item2 -> Bool in
                    let date1: Date?
                    let date2: Date?
                    
                    if let s = item1 as? MKSong { date1 = s.lastPlayedDate }
                    else if let p = item1 as? MKPlaylist { date1 = p.lastPlayedDate }
                    else if let a = item1 as? MKAlbum { date1 = a.lastPlayedDate }
                    else { date1 = nil }
                    
                    if let s = item2 as? MKSong { date2 = s.lastPlayedDate }
                    else if let p = item2 as? MKPlaylist { date2 = p.lastPlayedDate }
                    else if let a = item2 as? MKAlbum { date2 = a.lastPlayedDate }
                    else { date2 = nil }
                    
                    // Items without date go to the end
                    return (date1 ?? Date.distantPast) > (date2 ?? Date.distantPast)
                }
                
                // Limit result to 15 items
                let result = Array(sortedItems.prefix(15))
                
                DispatchQueue.main.async {
                    completion(result, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
}
