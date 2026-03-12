//
//  MKPreviewAsset.swift
//  MusicKitSample
//
//  Created by Андрей Чернышев on 30.03.2023.
//

import MusicKit
import Foundation

@available(iOS 16.0, *)
public struct MKPreviewAsset: Hashable {
    public let artwork: MKArtwork?
    public let hlsUrl: URL?
    public let url: URL?
    
    init(previewAsset: PreviewAsset) {
        self.artwork = MKArtwork(artwork: previewAsset.artwork)
        self.hlsUrl = previewAsset.hlsURL
        self.url = previewAsset.url
    }
}
