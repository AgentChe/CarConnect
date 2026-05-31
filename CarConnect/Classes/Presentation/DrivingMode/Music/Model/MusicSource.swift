//
//  MusicSource.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 12.03.2026.
//

enum MusicSource: Codable, Hashable {
    case appleMusic, spotify, radio 
}

extension MusicSource {
    var iconName: String {
        switch self {
        case .appleMusic:
            return "DrivingMode.Music.AppleMusic"
        case .spotify:
            return "DrivingMode.Music.Spotify"
        case .radio:
            return "DrivingMode.Music.Radio"
        }
    }
    
    var title: String {
        switch self {
        case .appleMusic:
            "AppleMusic".localized
        case .spotify:
            "Spotify".localized
        case .radio:
            "Radio".localized
        }
    }
}
