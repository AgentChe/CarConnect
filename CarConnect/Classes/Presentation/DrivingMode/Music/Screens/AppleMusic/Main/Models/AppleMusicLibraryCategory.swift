//
//  AppleMusicLibraryCategory.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 25.03.2026.
//

import Foundation

enum AppleMusicLibraryCategory: String, Hashable, CaseIterable {
    case playlists
    case artists
    case albums
    case songs
    
    var title: String {
        switch self {
        case .playlists:
            "AppleMusic.Category.Playlist".localized
        case .artists:
            "AppleMusic.Category.Artists".localized
        case .albums:
            "AppleMusic.Category.Albums".localized
        case .songs:
            "AppleMusic.Category.Songs".localized
        }
    }
    
    var iconName: String {
        switch self {
        case .playlists:
            "Library.Playlists"
        case .artists:
            "Library.Artists"
        case .albums:
            "Library.Albums"
        case .songs:
            "Library.Songs"
        }
    }
    
    var emptyTitle: String {
        switch self {
        case .playlists:
            "AppleMusic.EmptyLibrary.Playlist".localized
        case .artists:
            "AppleMusic.EmptyLibrary.Artists".localized
        case .albums:
            "AppleMusic.EmptyLibrary.Album".localized
        case .songs:
            "AppleMusic.EmptyLibrary.Songs".localized
        }
    }
}
