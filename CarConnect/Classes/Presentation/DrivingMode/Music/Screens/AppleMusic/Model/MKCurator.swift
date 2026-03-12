//
//  MKCurator.swift
//  MusicKitSample
//
//  Created by Андрей Чернышев on 30.03.2023.
//

import MusicKit
import Foundation

@available(iOS 16.0, *)
public struct MKCurator: Hashable {
    public let id: MKMusicItemID
    public let artwork: MKArtwork?
    public let kind: Kind?
    public let name: String
    public let playlists: [MKPlaylist]
    public let url: URL?
    
    init(curator: Curator) {
        self.id = MKMusicItemID(musicItemId: curator.id)
        self.artwork = MKArtwork(artwork: curator.artwork)
        self.kind = Kind(kind: curator.kind)
        self.name = curator.name
        self.playlists = curator.playlists?.compactMap { playlist -> MKPlaylist? in
            MKPlaylist(playlist: playlist)
        } ?? []
        self.url = curator.url
    }
}

// MARK: Kind
@available(iOS 16.0, *)
extension MKCurator {
    public enum Kind: Hashable {
        case editorial, external

        init?(kind: Curator.Kind?) {
            guard let kind = kind else {
                return nil
            }
            
            switch kind {
            case .editorial:
                self = .editorial
            case .external:
                self = .external
            default:
                return nil
            }
        }
    }
}
