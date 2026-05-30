//
//  RouteOptions.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.05.2026.
//

import Foundation

struct RouteOptions {
    let avoidTolls: Bool
    let avoidHighways: Bool
    let police: Bool
    let speedCameras: Bool
    let traffic: Bool
}

final class RouteOptionsStorage {
    enum Constants {
        static let avoidTollsKey = "route_options_avoid_tolls"
        static let avoidHighwaysKey = "route_options_avoid_highways"
        static let policeKey = "route_options_police"
        static let speedCamerasKey = "route_options_speed_cameras"
        static let trafficKey = "route_options_traffic"
    }
    
    static let shared = RouteOptionsStorage()
    
    var options: RouteOptions {
        RouteOptions(
            avoidTolls: avoidTolls,
            avoidHighways: avoidHighways,
            police: police,
            speedCameras: speedCameras,
            traffic: traffic
        )
    }
    
    var avoidTolls: Bool {
        didSet {
            userDefaults?.set(avoidTolls, forKey: Constants.avoidTollsKey)
        }
    }

    var avoidHighways: Bool {
        didSet {
            userDefaults?.set(avoidHighways, forKey: Constants.avoidHighwaysKey)
        }
    }
    
    var police: Bool {
        didSet {
            userDefaults?.set(police, forKey: Constants.policeKey)
        }
    }
    
    var speedCameras: Bool {
        didSet {
            userDefaults?.set(speedCameras, forKey: Constants.speedCamerasKey)
        }
    }
    
    var traffic: Bool {
        didSet {
            userDefaults?.set(traffic, forKey: Constants.trafficKey)
        }
    }
    
    private let userDefaults = UserDefaults(suiteName: GlobalDefinitions.appGroupId)
    
    private init() {
        avoidTolls = userDefaults?.bool(forKey: Constants.avoidTollsKey) ?? false
        avoidHighways = userDefaults?.bool(forKey: Constants.avoidHighwaysKey) ?? false
        police = userDefaults?.bool(forKey: Constants.policeKey) ?? false
        speedCameras = userDefaults?.bool(forKey: Constants.speedCamerasKey) ?? false
        traffic = userDefaults?.bool(forKey: Constants.trafficKey) ?? false
    }
}
