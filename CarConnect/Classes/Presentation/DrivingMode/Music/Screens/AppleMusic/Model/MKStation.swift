//
//  MKStation.swift
//  MusicKitSample
//
//  Created by Андрей Чернышев on 30.03.2023.
//

import MusicKit
import Foundation

@available(iOS 16.0, *)
public struct MKStation: Hashable {
    public let id: MKMusicItemID
    public let artwork: MKArtwork?
    public let contentRating: MKContentRating?
    public let duration: TimeInterval?
    public let episodeNumber: Int?
    public let isLive: Bool
    public let name: String
    public let stationProviderName: String?
    public let url: URL?
    
    init?(station: Station?) {
        guard let station = station else {
            return nil
        }
        
        self.id = MKMusicItemID(musicItemId: station.id)
        self.artwork = MKArtwork(artwork: station.artwork)
        self.contentRating = MKContentRating(contentRating: station.contentRating)
        self.duration = station.duration
        self.episodeNumber = station.episodeNumber
        self.isLive = station.isLive
        self.name = station.name
        self.stationProviderName = station.stationProviderName
        self.url = station.url
    }
}
