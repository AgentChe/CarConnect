//
//  TrackItem.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 11.04.2026.
//

import Foundation
import MusicKit

struct TrackItem: nonisolated Hashable, Identifiable {
    let track: Track
    let isPlaying: Bool
    
    var id: MusicItemID { track.id }
}
