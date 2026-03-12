//
//  MKRecordLabel.swift
//  MusicKitSample
//
//  Created by Андрей Чернышев on 30.03.2023.
//

import MusicKit
import Foundation

@available(iOS 16.0, *)
public struct MKRecordLabel: Hashable {
    public let id: MKMusicItemID
    public let artwork: MKArtwork?
    public let latestReleases: [MKAlbum]
    public let name: String
    public let shortDescription: String?
    public let standardDescription: String?
    public let topReleases: [MKAlbum]
    public let url: URL?
    
    init(recordLabel: RecordLabel) {
        self.id = MKMusicItemID(musicItemId: recordLabel.id)
        self.artwork = MKArtwork(artwork: recordLabel.artwork)
        self.latestReleases = recordLabel.latestReleases?.compactMap { album -> MKAlbum? in
            MKAlbum(album: album)
        } ?? []
        self.name = recordLabel.name
        self.shortDescription = recordLabel.shortDescription
        self.standardDescription = recordLabel.standardDescription
        self.topReleases = recordLabel.topReleases?.compactMap { album -> MKAlbum? in
            MKAlbum(album: album)
        } ?? []
        self.url = recordLabel.url
    }
}
