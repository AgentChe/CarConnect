//
//  MKGenre.swift
//  MusicKitSample
//
//  Created by Андрей Чернышев on 30.03.2023.
//

import MusicKit
import Foundation

@available(iOS 16.0, *)
public struct MKGenre: Hashable {
    public let id: MKMusicItemID
    public let libraryAddedDate: Date?
    public let name: String
    
    init?(genre: Genre?) {
        guard let genre = genre else {
            return nil
        }
        
        self.id = MKMusicItemID(musicItemId: genre.id)
        self.libraryAddedDate = genre.libraryAddedDate
        self.name = genre.name
    }
}
