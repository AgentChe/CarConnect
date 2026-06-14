//
//  MusicPlayerProtocol.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 09.06.2026.
//

import Foundation
import Combine

protocol MusicPlayerProtocol {
    var trackPublisher: CurrentValueSubject<TrackModel?, Never> { get }
    var playbackPublisher: CurrentValueSubject<PlaybackModel?, Never> { get }
    
    func pause()
}
