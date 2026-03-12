//
//  MKRadioShow.swift
//  MusicKitSample
//
//  Created by Андрей Чернышев on 30.03.2023.
//

import MusicKit
import Foundation

@available(iOS 16.0, *)
public struct MKRadioShow: Hashable {
    public let id: MKMusicItemID
    public let hostName: String?
    public let artwork: MKArtwork?
    public let name: String
    public let playlists: [MKPlaylist]
    public let url: URL?
    
    init?(radioShow: RadioShow?) {
        guard let radioShow = radioShow else {
            return nil
        }
        
        self.id = MKMusicItemID(musicItemId: radioShow.id)
        self.hostName = radioShow.hostName
        self.artwork = MKArtwork(artwork: radioShow.artwork)
        self.name = radioShow.name
        self.playlists = radioShow.playlists?.map { playlist -> MKPlaylist in
            MKPlaylist(playlist: playlist)
        } ?? []
        self.url = radioShow.url
    }
}
