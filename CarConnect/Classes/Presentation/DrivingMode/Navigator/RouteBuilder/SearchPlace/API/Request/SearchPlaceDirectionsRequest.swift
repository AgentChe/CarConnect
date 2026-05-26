//
//  SearchPlaceDirectionsRequest.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 26.05.2026.
//

import Alamofire

struct SearchPlaceDirectionsRequest: APIRequestBody {
    let originCoordinate: Coordinate
    let destinationCoordinate: Coordinate
    let waypointCoordinates: [(latitude: Double, longitude: Double)]
    let avoidTolls: Bool
    let avoidHighways: Bool
    let departureTime: Date?

    var url: String {
        "https://maps.googleapis.com/maps/api/directions/json"
    }

    var method: HTTPMethod {
        .get
    }

    var encoding: ParameterEncoding {
        URLEncoding.default
    }

    var parameters: Parameters? {
        var params: Parameters = [
            "origin": "\(originCoordinate.latitude),\(originCoordinate.longitude)",
            "destination": "\(destinationCoordinate.latitude),\(destinationCoordinate.longitude)",
            "key": GlobalDefinitions.googleMapsApiKey
        ]

        var avoids: [String] = []
        if avoidTolls    { avoids.append("tolls") }
        if avoidHighways { avoids.append("highways") }
        if !avoids.isEmpty {
            params["avoid"] = avoids.joined(separator: "|")
        }

        if !waypointCoordinates.isEmpty {
            params["waypoints"] = waypointCoordinates
                .map { "\($0.latitude),\($0.longitude)" }
                .joined(separator: "|")
        }

        if let dt = departureTime {
            params["departure_time"] = Int(dt.timeIntervalSince1970)
        }

        return params
    }
}
