//
//  PlaybackModel.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 08.06.2026.
//

import Foundation

struct PlaybackModel {
    let currentTime: TimeInterval
    let duration: TimeInterval
    let isPlaying: Bool
    let repeatMode: RepeatMode
    let shuffleMode: ShuffleMode
}

enum RepeatMode {
    case none, one, all
}

enum ShuffleMode {
    case off, on
}
