//
//  TrackItem.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 11.04.2026.
//

import Foundation
import MusicKit

struct TrackItem: nonisolated Hashable {
    let track: Track
    let isPlaying: Bool
}
