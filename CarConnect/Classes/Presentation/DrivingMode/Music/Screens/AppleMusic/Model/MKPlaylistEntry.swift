//
//  MKPlaylistEntry.swift
//  MusicKitSample
//
//  Created by Андрей Чернышев on 30.03.2023.
//

import MusicKit
import Foundation

@available(iOS 16.0, *)
public struct MKPlaylistEntry: Hashable {
    public let id: MKMusicItemID
    public let albumTitle: String?
    public let artistName: String
    public let artwork: MKArtwork?
    public let contentRating: MKContentRating?
    public let duration: TimeInterval?
    public let genreNames: [String]
    public let isrc: String?
    public let item: Item?
    public let lastPlayedDate: Date?
    public let libraryAddedDate: Date?
    public let playCount: Int?
    public let position: Int
    public let previewAssets: [MKPreviewAsset]
    public let releaseDate: Date?
    public let title: String
    public let url: URL?
    
    init(entry: Playlist.Entry) {
        self.id = MKMusicItemID(musicItemId: entry.id)
        self.albumTitle = entry.albumTitle
        self.artistName = entry.artistName
        self.artwork = MKArtwork(artwork: entry.artwork)
        self.contentRating = MKContentRating(contentRating: entry.contentRating)
        self.duration = entry.duration
        self.genreNames = entry.genreNames
        self.isrc = entry.isrc
        self.item = MKPlaylistEntry.Item(item: entry.item)
        self.lastPlayedDate = entry.lastPlayedDate
        self.libraryAddedDate = entry.libraryAddedDate
        self.playCount = entry.playCount
        self.position = entry.position
        self.previewAssets = entry.previewAssets?.map { previewAsset -> MKPreviewAsset in
            MKPreviewAsset(previewAsset: previewAsset)
        } ?? []
        self.releaseDate = entry.releaseDate
        self.title = entry.title
        self.url = entry.url
    }
}

// MARK: Item
@available(iOS 16.0, *)
public extension MKPlaylistEntry {
    enum Item: Hashable {
        case song(MKSong)
        
        init?(item: Playlist.Entry.Item?) {
            guard let item = item else {
                return nil
            }
            
            switch item {
            case .song(let song):
                let mkSong = MKSong(song: song)
                self = .song(mkSong)
            default:
                return nil
            }
        }
    }
}
