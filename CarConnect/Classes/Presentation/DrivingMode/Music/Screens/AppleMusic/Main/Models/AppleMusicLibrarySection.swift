//
//  AppleMusicLibrarySection.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 25.03.2026.
//

import Foundation

enum AppleMusicLibrarySection: Int, CaseIterable, Sendable {
    case recently
    case library
}

extension AppleMusicLibrarySection {
    var title: String {
        switch self {
        case .recently:
            "AppleMusic.Section.Recents".localized
        case .library:
            "AppleMusic.Section.Library".localized
        }
    }
}
