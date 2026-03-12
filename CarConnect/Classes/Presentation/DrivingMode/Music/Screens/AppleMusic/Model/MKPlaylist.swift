//
//  MKPlaylist.swift
//  MusicKitSample
//
//  Created by Андрей Чернышев on 30.03.2023.
//

import MusicKit
import Foundation

@available(iOS 16.0, *)
public struct MKPlaylist: Hashable {
    public let id: MKMusicItemID
    public let isFavorite: Bool
    public let artwork: MKArtwork?
    public let curatorName: String?
    public let entries: [MKPlaylistEntry]
    public let featuredArtists: [MKArtist]
    public let isChart: Bool?
    public let kind: Kind?
    public let lastModifiedDate: Date?
    public let lastPlayedDate: Date?
    public let libraryAddedDate: Date?
    public let moreByCurator: [MKPlaylist]
    public let name: String
    public let radioShow: MKRadioShow?
    public let shortDescription: String?
    public let standardDescription: String?
    public let tracks: [MKTrack]
    public let url: URL?
    
    init(playlist: Playlist, filterLocalOnly: Bool = false) {
        self.id = MKMusicItemID(musicItemId: playlist.id)
        self.isFavorite = playlist.kind == .personalMix
        self.artwork = MKArtwork(artwork: playlist.artwork)
        self.curatorName = playlist.curatorName
        self.entries = playlist.entries?.map { entry -> MKPlaylistEntry in
            MKPlaylistEntry(entry: entry)
        } ?? []
        self.featuredArtists = playlist.featuredArtists?.map { artist -> MKArtist in
            MKArtist(artist: artist)
        } ?? []
        self.isChart = playlist.isChart
        self.kind = Kind(kind: playlist.kind)
        self.lastModifiedDate = playlist.lastModifiedDate
        self.lastPlayedDate = playlist.lastPlayedDate
        self.libraryAddedDate = playlist.libraryAddedDate
        self.moreByCurator = playlist.moreByCurator?.map { playlist -> MKPlaylist in
            MKPlaylist(playlist: playlist)
        } ?? []
        self.name = playlist.name
        self.radioShow = MKRadioShow(radioShow: playlist.radioShow)
        self.shortDescription = playlist.shortDescription
        self.standardDescription = playlist.standardDescription
        self.tracks = playlist.tracks?.compactMap { track -> MKTrack? in
            if filterLocalOnly {
                var addedDate: Date?
                switch track {
                case .song(let song):
                    addedDate = song.libraryAddedDate
                case .musicVideo(let video):
                    addedDate = video.libraryAddedDate
                @unknown default:
                    break
                }
                
                guard addedDate != nil else { return nil }
            }
            return MKTrack(track: track)
        } ?? []
        self.url = playlist.url
    }
}

//MARK: Kind
@available(iOS 16.0, *)
extension MKPlaylist {
    public enum Kind: Hashable {
        case editorial, external, personalMix, replay, userShared
        
        init?(kind: Playlist.Kind?) {
            guard let kind = kind else {
                return nil
            }
            
            switch kind {
            case .editorial:
                self = .editorial
            case .external:
                self = .external
            case .personalMix:
                self = .personalMix
            case .replay:
                self = .replay
            case .userShared:
                self = .userShared
            default:
                return nil
            }
        }
    }
}
