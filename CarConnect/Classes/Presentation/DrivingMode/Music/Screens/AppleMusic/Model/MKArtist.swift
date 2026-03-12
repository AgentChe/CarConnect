//
//  MKArtist.swift
//  MusicKitSample
//
//  Created by Андрей Чернышев on 30.03.2023.
//

import MusicKit
import Foundation

@available(iOS 16.0, *)
public struct MKArtist: Hashable {
    public let id: MKMusicItemID
    public let albums: [MKAlbum]
    public let appearsOnAlbums: [MKAlbum]
    public let artwork: MKArtwork?
    public let compilationAlbums: [MKAlbum]
    public let featuredAlbums: [MKAlbum]
    public let featuredPlaylists: [MKPlaylist]
    public let fullAlbums: [MKAlbum]
    public let genreNames: [String]
    public let genres: [MKGenre]
    public let latestRelease: MKAlbum?
    public let liveAlbums: [MKAlbum]
    public let name: String
    public let playlists: [MKPlaylist]
    public let similarArtists: [MKArtist]
    public let singles: [MKAlbum]
    public let station: MKStation?
    public let topSongs: [MKSong]
    public let url: URL?
    
    init(artist: Artist) {
        self.id = MKMusicItemID(musicItemId: artist.id)
        self.albums = artist.albums?.compactMap { album -> MKAlbum? in
            MKAlbum(album: album)
        } ?? []
        self.appearsOnAlbums = artist.appearsOnAlbums?.compactMap { album -> MKAlbum? in
            MKAlbum(album: album)
        } ?? []
        self.artwork = MKArtwork(artwork: artist.artwork)
        self.compilationAlbums = artist.compilationAlbums?.compactMap { album -> MKAlbum? in
            MKAlbum(album: album)
        } ?? []
        self.featuredAlbums = artist.featuredAlbums?.compactMap { album -> MKAlbum? in
            MKAlbum(album: album)
        } ?? []
        self.featuredPlaylists = artist.featuredPlaylists?.map { playlist -> MKPlaylist in
            MKPlaylist(playlist: playlist)
        } ?? []
        self.fullAlbums = artist.fullAlbums?.compactMap { album -> MKAlbum? in
            MKAlbum(album: album)
        } ?? []
        self.genreNames = artist.genreNames ?? []
        self.genres = artist.genres?.compactMap { genre -> MKGenre? in
            MKGenre(genre: genre)
        } ?? []
        self.latestRelease = MKAlbum(album: artist.latestRelease)
        self.liveAlbums = artist.liveAlbums?.compactMap { album -> MKAlbum? in
            MKAlbum(album: album)
        } ?? []
        self.name = artist.name
        self.playlists = artist.playlists?.map { playlist -> MKPlaylist in
            MKPlaylist(playlist: playlist)
        } ?? []
        self.similarArtists = artist.similarArtists?.map { artist -> MKArtist in
            MKArtist(artist: artist)
        } ?? []
        self.singles = artist.singles?.compactMap { album -> MKAlbum? in
            MKAlbum(album: album)
        } ?? []
        self.station = MKStation(station: artist.station)
        self.topSongs = artist.topSongs?.map { song -> MKSong in
            MKSong(song: song)
        } ?? []
        self.url = artist.url
    }
}

