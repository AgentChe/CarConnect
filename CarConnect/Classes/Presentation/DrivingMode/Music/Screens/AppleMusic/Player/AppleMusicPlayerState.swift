//
//  AppleMusicPlayerState.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 12.03.2026.
//

import MusicKit

enum AppleMusicPlayerState {
    case stopped
    case playing
    case paused
    case interrupted
    case seekingForward
    case seekingBackward
    
    init(state: MusicPlayer.State) {
        switch state.playbackStatus {
        case .stopped:
            self = .stopped
        case .playing:
            self = .playing
        case .paused:
            self = .paused
        case .interrupted:
            self = .interrupted
        case .seekingForward:
            self = .seekingForward
        case .seekingBackward:
            self = .seekingBackward
        @unknown default:
            self = .stopped
        }
    }
}
