////
////  AppleMusicSearchRequest.swift
////  CarConnect
////
////  Created by Андрей Чернышев on 12.03.2026.
////
//
//import MusicKit
//import Foundation
//
//final class AppleMusicSearchRequest {
//    enum SearchType {
//        case album
//        case artist
//        case curator
//        case playlist
//        case radioShow
//        case recordLabel
//        case song
//        case station
//    }
//    
//    private let request: MusicCatalogSearchRequest
//    
//    init(
//        term: String,
//        searches: [SearchType],
//        limit: Int = 20,
//        offset: Int = 0,
//        includeTopResults: Bool
//    ) {
//        let types = searches.map { search -> MusicCatalogSearchable.Type in
//            switch search {
//            case .album:
//                return Album.self
//            case .artist:
//                return Artist.self
//            case .curator:
//                return Curator.self
//            case .playlist:
//                return Playlist.self
//            case .radioShow:
//                return RadioShow.self
//            case .recordLabel:
//                return RecordLabel.self
//            case .song:
//                return Song.self
//            case .station:
//                return Station.self
//            }
//        }
//        
//        var request = MusicCatalogSearchRequest(term: term, types: types)
//        request.limit = limit
//        request.offset = offset
//        request.includeTopResults = includeTopResults
//        
//        self.request = request
//    }
//    
//    func response(completion: @escaping (AppleMusicSearchResponse?, Error?) -> Void) {
//        Task {
//            do {
//                let response = try await request.response()
//                
//                let albums = response.albums.compactMap { album -> MKAlbum? in
//                    MKAlbum(album: album)
//                }
//                let artists = response.artists.compactMap { artist -> MKArtist? in
//                    MKArtist(artist: artist)
//                }
//                let curators = response.curators.compactMap { curator -> MKCurator? in
//                    MKCurator(curator: curator)
//                }
//                let playlists = response.playlists.compactMap { playlist -> MKPlaylist? in
//                    MKPlaylist(playlist: playlist)
//                }
//                let radioShows = response.radioShows.compactMap { radioShow -> MKRadioShow? in
//                    MKRadioShow(radioShow: radioShow)
//                }
//                let recordLabels = response.recordLabels.compactMap { recordLabel -> MKRecordLabel? in
//                    MKRecordLabel(recordLabel: recordLabel)
//                }
//                let songs = response.songs.compactMap { song -> MKSong? in
//                    MKSong(song: song)
//                }
//                let stations = response.stations.compactMap { station -> MKStation? in
//                    MKStation(station: station)
//                }
//                let topResults = response.topResults.compactMap { topResult -> MKTopResult? in
//                    MKTopResult(topResult: topResult)
//                }
//                
//                let result = AppleMusicSearchResponse(
//                    albums: albums,
//                    artists: artists,
//                    curators: curators,
//                    playlists: playlists,
//                    radioShows: radioShows,
//                    recordLabels: recordLabels,
//                    songs: songs,
//                    stations: stations,
//                    topResults: topResults
//                )
//                
//                DispatchQueue.main.async {
//                    completion(result, nil)
//                }
//            } catch let error {
//                DispatchQueue.main.async {
//                    completion(nil, error)
//                }
//            }
//        }
//    }
//}
