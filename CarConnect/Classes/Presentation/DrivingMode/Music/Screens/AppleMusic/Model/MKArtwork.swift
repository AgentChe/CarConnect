//
//  MKArtwork.swift
//  MusicKitSample
//
//  Created by Андрей Чернышев on 30.03.2023.
//

import MusicKit
import Foundation

@available(iOS 16.0, *)
public struct MKArtwork: Hashable {
    public let url: URL?
    public let original: Artwork?
    
    init?(artwork: Artwork?) {
        guard let artwork = artwork else {
            return nil
        }
        
        self.original = artwork
        self.url = artwork.url(width: artwork.maximumWidth, height: artwork.maximumHeight)
    }
}
