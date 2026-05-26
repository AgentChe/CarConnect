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
    var avoidTolls: Bool
    var avoidHighways: Bool
    var departureTime: Date?

    var formattedDuration: String {
        let totalMinutes = durationSeconds / 60
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        if hours > 0 {
            return "\(hours) hr \(minutes) min"
        }
        return "\(minutes) min"
    }

    var formattedDistance: String {
        let km = Double(distanceMeters) / 1000.0
        return String(format: "%.1f km", km)
    }
}

// MARK: Public
extension NavigatorRoute {
    init?(destination: NavigatorPlace,
          waypoints: [NavigatorPlace] = [],
          avoidTolls: Bool = false,
          avoidHighways: Bool = false,
          departureTime: Date? = nil,
          response: Any) {
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

        self.destination = destination
        self.waypoints = waypoints
        self.encodedPolyline = polylinePath
        self.distanceMeters = totalDistance
        self.durationSeconds = totalDuration
        self.avoidTolls = avoidTolls
        self.avoidHighways = avoidHighways
        self.departureTime = departureTime
    }
}
