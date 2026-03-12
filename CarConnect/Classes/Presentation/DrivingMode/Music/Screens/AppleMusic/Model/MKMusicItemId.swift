//
//  MKMusicItemId.swift
//  MusicKitSample
//
//  Created by Андрей Чернышев on 30.03.2023.
//

import MusicKit

@available(iOS 16.0, *)
public struct MKMusicItemID: Hashable {
    public let rawValue: String
    
    init(musicItemId: MusicItemID) {
        self.rawValue = musicItemId.rawValue
    }
}
