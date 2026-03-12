//
//  AppleMusicSearchResponse.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 12.03.2026.
//

struct AppleMusicSearchResponse {
    let albums: [MKAlbum]?
    let artists: [MKArtist]?
    let curators: [MKCurator]?
    let playlists: [MKPlaylist]?
    let radioShows: [MKRadioShow]?
    let recordLabels: [MKRecordLabel]?
    let songs: [MKSong]?
    let stations: [MKStation]?
    let topResults: [MKTopResult]?
}
