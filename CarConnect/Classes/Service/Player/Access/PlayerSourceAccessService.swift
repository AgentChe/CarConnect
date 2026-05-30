//
//  PlayerSourceAccessService.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 30.05.2026.
//

import Foundation
import MusicKit

final class PlayerSourceAccessService {
    private let appleMusicService: AppleMusicService
    private let spotifyConnectionService: SpotifyConnectionService
    
    init() {
        appleMusicService = .init()
        spotifyConnectionService = .shared
    }
    
    func checkAccessAppleMusic() -> Bool {
        return appleMusicService.isAuthorized
    }
    
    func checkAccessSpotify() -> Bool {
        return spotifyConnectionService.checkSpotifyAvailability()
    }
    
    func requestAuthorizationAppleMusic() async -> Bool {
        guard MusicAuthorization.currentStatus == .notDetermined else { return false }
        return await MusicAuthorization.request() == .authorized
    }
    
    func requestAuthorizationSpotify() async -> Bool {
        await spotifyConnectionService.autorize()
    }
}
