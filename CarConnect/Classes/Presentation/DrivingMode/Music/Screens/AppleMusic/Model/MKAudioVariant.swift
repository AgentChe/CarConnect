//
//  MKAudioVariant.swift
//  MusicKitSample
//
//  Created by Андрей Чернышев on 31.03.2023.
//

import MusicKit

@available(iOS 16.0, *)
public enum MKAudioVariant: Hashable {
    case dolbyAtmos, dolbyAudio, highResolutionLossless, lossless, lossyStereo
    
    init?(audioVariant: AudioVariant?) {
        guard let audioVariant = audioVariant else {
            return nil
        }
        
        switch audioVariant {
        case .dolbyAtmos:
            self = .dolbyAtmos
        case .dolbyAudio:
            self = .dolbyAudio
        case .lossless:
            self = .lossless
        case .highResolutionLossless:
            self = .highResolutionLossless
        case .lossyStereo:
            self = .lossyStereo
        default:
            return nil
        }
    }
}
