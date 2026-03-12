//
//  MKAlbum.swift
//  MusicKitSample
//
//  Created by Андрей Чернышев on 30.03.2023.
//

import MusicKit
import Foundation

@available(iOS 16.0, *)
public struct MKAlbum: Hashable {
    public let id: MKMusicItemID
    public let lastPlayedDate: Date?
    public let appearsOn: [MKPlaylist]
    public let artistName: String
    public let artistUrl: URL?
    public let artists: [MKArtist]
    public let artwork: MKArtwork?
    public let contentRating: MKContentRating?
    public let copyright: String?
    public let genreNames: [String]
    public let genres: [MKGenre]
    public let isCompilation: Bool?
    public let isComplete: Bool?
    public let isSingle: Bool?
    public let otherVersions: [MKAlbum]
    public let recordLabelName: String?
    public let recordLabels: [MKRecordLabel]
    public let relatedAlbums: [MKAlbum]
    public let releaseDate: Date?
    public let title: String
    public let trackCount: Int
    public let tracks: [MKTrack]
    public let upc: String?
    public let url: URL?
    
    init?(album: Album?) {
        guard let album = album else {
            return nil
        }
        
        self.id = MKMusicItemID(musicItemId: album.id)
        self.lastPlayedDate = album.lastPlayedDate
        self.appearsOn = album.appearsOn?.map { playlist -> MKPlaylist in
            MKPlaylist(playlist: playlist)
        } ?? []
        self.artistName = album.artistName
        self.artistUrl = album.artistURL
        self.artists = album.artists?.map { artist -> MKArtist in
            MKArtist(artist: artist)
        } ?? []
        self.artwork = MKArtwork(artwork: album.artwork)
        self.contentRating = MKContentRating(contentRating: album.contentRating)
        self.copyright = album.copyright
        self.genreNames = album.genreNames
        self.genres = album.genres?.compactMap { genre -> MKGenre? in
            MKGenre(genre: genre)
        } ?? []
        self.isCompilation = album.isCompilation
        self.isComplete = album.isComplete
        self.isSingle = album.isSingle
        self.otherVersions = album.otherVersions?.compactMap { album -> MKAlbum? in
            MKAlbum(album: album)
        } ?? []
        self.recordLabelName = album.recordLabelName
        self.recordLabels = album.recordLabels?.map { recordLabel -> MKRecordLabel in
            MKRecordLabel(recordLabel: recordLabel)
        } ?? []
        self.relatedAlbums = album.relatedAlbums?.compactMap { album -> MKAlbum? in
            MKAlbum(album: album)
        } ?? []
        self.releaseDate = album.releaseDate
        self.title = album.title
        self.trackCount = album.trackCount
        self.tracks = album.tracks?.map { track -> MKTrack in
            MKTrack(track: track)
        } ?? []
        self.upc = album.upc
        self.url = album.url
    }
}
