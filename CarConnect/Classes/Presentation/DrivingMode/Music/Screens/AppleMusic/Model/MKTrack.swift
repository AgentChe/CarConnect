//
//  MKTrack.swift
//  MusicKitSample
//
//  Created by Андрей Чернышев on 30.03.2023.
//

import MusicKit
import Foundation

@available(iOS 16.0, *)
public struct MKTrack: Hashable {
    public let id: MKMusicItemID
    public let albumTitle: String?
    public let albums: [MKAlbum]
    public let artistName: String
    public let artistUrl: URL?
    public let artists: [MKArtist]
    public let artwork: MKArtwork?
    public let contentRating: MKContentRating?
    public let discNumber: Int?
    public let duration: TimeInterval?
    public let genreNames: [String]
    public let genres: [MKGenre]
    public let isrc: String?
    public let lastPlayedDate: Date?
    public let libraryAddedDate: Date?
    public let playCount: Int?
    public let previewAssets: [MKPreviewAsset]
    public let releaseDate: Date?
    public let title: String
    public let trackNumber: Int?
    public let url: URL?
    public let workName: String?
    
    init(track: Track) {
        self.id = MKMusicItemID(musicItemId: track.id)
        self.albumTitle = track.albumTitle
        self.albums = track.albums?.compactMap { album -> MKAlbum? in
            MKAlbum(album: album)
        } ?? []
        self.artistName = track.artistName
        self.artistUrl = track.artistURL
        self.artists = track.artists?.compactMap { artist -> MKArtist? in
            MKArtist(artist: artist)
        } ?? []
        self.artwork = MKArtwork(artwork: track.artwork)
        self.contentRating = MKContentRating(contentRating: track.contentRating)
        self.discNumber = track.discNumber
        self.duration = track.duration
        self.genreNames = track.genreNames
        self.genres = track.genres?.compactMap { genre -> MKGenre? in
            MKGenre(genre: genre)
        } ?? []
        self.isrc = track.isrc
        self.lastPlayedDate = track.lastPlayedDate
        self.libraryAddedDate = track.libraryAddedDate
        self.playCount = track.playCount
        self.previewAssets = track.previewAssets?.compactMap { previewAsset -> MKPreviewAsset? in
            MKPreviewAsset(previewAsset: previewAsset)
        } ?? []
        self.releaseDate = track.releaseDate
        self.title = track.title
        self.trackNumber = track.trackNumber
        self.url = track.url
        self.workName = track.workName
    }
}
