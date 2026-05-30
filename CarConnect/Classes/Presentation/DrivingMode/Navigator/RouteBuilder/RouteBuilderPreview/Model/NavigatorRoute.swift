//
//  NavigatorRoute.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 26.05.2026.
//

import Foundation

struct NavigatorRoute {
    let destination: NavigatorPlace
    var waypoints: [NavigatorPlace]
    let encodedPolyline: String
    let distanceMeters: Int
    let durationSeconds: Int
    let trafficDurationSeconds: Int? // Duration accounting for current traffic. Only present when `traffic` option is enabled.
    var avoidTolls: Bool
    var avoidHighways: Bool
    var departureTime: Date?
    var police: Bool
    var speedCameras: Bool
    var traffic: Bool
}

// MARK: Public
extension NavigatorRoute {
    init?(
        response: Any,
        destination: NavigatorPlace,
        waypoints: [NavigatorPlace] = [],
        avoidTolls: Bool = false,
        avoidHighways: Bool = false,
        departureTime: Date? = nil,
        police: Bool = false,
        speedCameras: Bool = false,
        traffic: Bool = false
    ) {
        guard
            let json = response as? [String: Any],
            let routes = json["routes"] as? [[String: Any]],
            let firstRoute = routes.first,
            let overviewPolyline = firstRoute["overview_polyline"] as? [String: Any],
            let polylinePath = overviewPolyline["points"] as? String,
            let legs = firstRoute["legs"] as? [[String: Any]]
        else { return nil }

        let totalDistance = legs.compactMap { ($0["distance"] as? [String: Any])?["value"] as? Int }.reduce(0, +)
        let totalDuration = legs.compactMap { ($0["duration"] as? [String: Any])?["value"] as? Int }.reduce(0, +)
        let totalTrafficDuration = legs.compactMap { ($0["duration_in_traffic"] as? [String: Any])?["value"] as? Int }.reduce(0, +)

        self.destination = destination
        self.waypoints = waypoints
        self.encodedPolyline = polylinePath
        self.distanceMeters = totalDistance
        self.durationSeconds = totalDuration
        self.trafficDurationSeconds = traffic && totalTrafficDuration > 0 ? totalTrafficDuration : nil
        self.avoidTolls = avoidTolls
        self.avoidHighways = avoidHighways
        self.departureTime = departureTime
        self.police = police
        self.speedCameras = speedCameras
        self.traffic = traffic
    }
}
