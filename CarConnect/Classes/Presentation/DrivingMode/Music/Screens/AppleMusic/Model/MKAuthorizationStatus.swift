//
//  MKAuthorizationStatus.swift
//  MusicKitSample
//
//  Created by Андрей Чернышев on 30.03.2023.
//

import MusicKit

@available(iOS 15.0, *)
public enum MKAuthorizationStatus: Hashable {
    case authorized, notDetermined, denied, restricted
    
    init(status: MusicAuthorization.Status) {
        switch status {
        case .authorized:
            self = .authorized
        case .notDetermined:
            self = .notDetermined
        case .denied:
            self = .denied
        case .restricted:
            self = .restricted
        default:
            self = .denied
        }
    }
    
    var toString: String {
        return "\(self)"
    }
}
