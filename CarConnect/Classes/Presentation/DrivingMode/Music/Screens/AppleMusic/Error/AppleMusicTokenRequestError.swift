//
//  AppleMusicTokenRequestError.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 12.03.2026.
//

import MusicKit

enum AppleMusicTokenRequestError: Hashable {
    case developerTokenRequestFailed
    case permissionDenied
    case privacyAcknowledgementRequired
    case unknown
    case userNotSignedIn
    case userTokenRequestFailed
    case userTokenRevoked
    
    init(error: MusicTokenRequestError) {
        switch error {
        case .developerTokenRequestFailed:
            self = .developerTokenRequestFailed
        case .permissionDenied:
            self = .permissionDenied
        case .privacyAcknowledgementRequired:
            self = .privacyAcknowledgementRequired
        case .unknown:
            self = .unknown
        case .userNotSignedIn:
            self = .userNotSignedIn
        case .userTokenRequestFailed:
            self = .userTokenRequestFailed
        case .userTokenRevoked:
            self = .userTokenRevoked
        @unknown default:
            self = .unknown
        }
    }
}
