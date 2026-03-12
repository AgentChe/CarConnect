//
//  MKSong.swift
//  MusicKitSample
//
//  Created by Андрей Чернышев on 30.03.2023.
//

import MusicKit
import Foundation

@available(iOS 16.0, *)
public struct MKSong: Hashable {
    public let id: MKMusicItemID
    public let albumTitle: String?
    public let albums: [MKAlbum]
    public let artistName: String
    public let artistURL: URL?
    public let artists: [MKArtist]
    public let artwork: MKArtwork?
    public let attribution: String?
    public let audioVariants: [MKAudioVariant]
    public let composerName: String?
    public let composers: [MKArtist]
    public let contentRating: MKContentRating?
    public let discNumber: Int?
    public let duration: TimeInterval?
    public let genreNames: [String]
    public let genres: [MKGenre]
    public let hasLyrics: Bool
    public let isAppleDigitalMaster: Bool?
    public let isrc: String?
    public let lastPlayedDate: Date?
    public let libraryAddedDate: Date?
    public let movementCount: Int?
    public let movementName: String?
    public let movementNumber: Int?
    public let playCount: Int?
    public let previewAssets: [MKPreviewAsset]
    public let releaseDate: Date?
    public let station: MKStation?
    public let title: String
    public let trackNumber: Int?
    public let url: URL?
    public let workName: String?
    
    init(song: Song) {
        self.id = MKMusicItemID(musicItemId: song.id)
        self.albumTitle = song.albumTitle
        self.albums = song.albums?.compactMap { album -> MKAlbum? in
            MKAlbum(album: album)
        } ?? []
        self.artistName = song.artistName
        self.artistURL = song.artistURL
        self.artists = song.artists?.compactMap { artist -> MKArtist? in
            MKArtist(artist: artist)
        } ?? []
        self.artwork = MKArtwork(artwork: song.artwork)
        self.attribution = song.attribution
        self.audioVariants = song.audioVariants?.compactMap { audioVariant -> MKAudioVariant? in
            MKAudioVariant(audioVariant: audioVariant)
        } ?? []
        self.composerName = song.composerName
        self.composers = song.composers?.compactMap { artist -> MKArtist? in
            MKArtist(artist: artist)
        } ?? []
        self.contentRating = MKContentRating(contentRating: song.contentRating)
        self.discNumber = song.discNumber
        self.duration = song.duration
        self.genreNames = song.genreNames
        self.genres = song.genres?.compactMap { genre -> MKGenre? in
            MKGenre(genre: genre)
        } ?? []
        self.hasLyrics = song.hasLyrics
        self.isAppleDigitalMaster = song.isAppleDigitalMaster
        self.isrc = song.isrc
        self.lastPlayedDate = song.lastPlayedDate
        self.libraryAddedDate = song.libraryAddedDate
        self.movementCount = song.movementCount
        self.movementName = song.movementName
        self.movementNumber = song.movementNumber
        self.playCount = song.playCount
        self.previewAssets = song.previewAssets?.compactMap { previewAsset -> MKPreviewAsset? in
            MKPreviewAsset(previewAsset: previewAsset)
        } ?? []
        self.releaseDate = song.releaseDate
        self.station = MKStation(station: song.station)
        self.title = song.title
        self.trackNumber = song.trackNumber
        self.url = song.url
        self.workName = song.workName
    }
}
