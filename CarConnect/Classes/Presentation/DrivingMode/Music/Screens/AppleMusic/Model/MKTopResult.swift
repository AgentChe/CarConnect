//
//  MKTopResult.swift
//  MusicKitSample
//
//  Created by Андрей Чернышев on 31.03.2023.
//

import MusicKit

@available(iOS 16.0, *)
public enum MKTopResult {
    case album(MKAlbum)
    case artist(MKArtist)
    case curator(MKCurator)
    case playlist(MKPlaylist)
    case radioShow(MKRadioShow)
    case recordLabel(MKRecordLabel)
    case song(MKSong)
    case station(MKStation)
    
    init?(topResult: MusicCatalogSearchResponse.TopResult) {
        switch topResult {
        case .album(let album):
            guard let object = MKAlbum(album: album) else {
                return nil
            }
            self = .album(object)
        case .artist(let artist):
            let object = MKArtist(artist: artist)
            self = .artist(object)
        case .curator(let curator):
            let object = MKCurator(curator: curator)
            self = .curator(object)
        case .playlist(let playlist):
            let object = MKPlaylist(playlist: playlist)
            self = .playlist(object)
        case .radioShow(let radioShow):
            guard let object = MKRadioShow(radioShow: radioShow) else {
                return nil
            }
            self = .radioShow(object)
        case .recordLabel(let recordLabel):
            let object = MKRecordLabel(recordLabel: recordLabel)
            self = .recordLabel(object)
        case .song(let song):
            let object = MKSong(song: song)
            self = .song(object)
        case .station(let station):
            guard let object = MKStation(station: station) else {
                return nil
            }
            self = .station(object)
        default:
            return nil
        }
    }
}
