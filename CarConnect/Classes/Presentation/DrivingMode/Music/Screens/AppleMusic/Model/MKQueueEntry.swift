//
//  MKQueueEntry.swift
//  MusicKitSample
//
//  Created by Андрей Чернышев on 03.04.2023.
//

import MusicKit
import Foundation

@available(iOS 16.0, *)
public struct MKQueueEntry {
    public let id: String
    public let title: String
    public let subTitle: String?
    public let artwork: MKArtwork?
    public let startTime: TimeInterval?
    public let endTime: TimeInterval?
    public let song: MKSong?
    public let position: Int?
    
    init(entry: MusicPlayer.Queue.Entry, position: Int?) {
        self.id = entry.id
        self.title = entry.title
        self.subTitle = entry.subtitle
        self.artwork = MKArtwork(artwork: entry.artwork)
        self.startTime = entry.startTime
        self.endTime = entry.endTime
        self.position = position
        
        if case let .song(song) = entry.item {
            self.song = MKSong(song: song)
        } else {
            self.song = nil
        }
    }
}
