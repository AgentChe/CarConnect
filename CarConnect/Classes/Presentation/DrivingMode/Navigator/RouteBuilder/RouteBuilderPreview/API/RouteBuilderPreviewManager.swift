//
//  RouteBuilderPreviewManager.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.05.2026.
//

import RxSwift

protocol RouteBuilderPreviewManagerProtocol {
    func fetchDirections(
        destination: NavigatorPlace,
        originCoordinate: Coordinate,
        waypoints: [NavigatorPlace],
        avoidTolls: Bool,
        avoidHighways: Bool,
        departureTime: Date?
    ) -> Single<NavigatorRoute?>
}

final class RouteBuilderPreviewManager {
    private lazy var restAPITransport = RestAPITransport()
}

// MARK: RouteBuilderPreviewManagerProtocol
extension RouteBuilderPreviewManager: RouteBuilderPreviewManagerProtocol {
    func fetchDirections(
        destination: NavigatorPlace,
        originCoordinate: Coordinate,
        waypoints: [NavigatorPlace] = [],
        avoidTolls: Bool = false,
        avoidHighways: Bool = false,
        departureTime: Date? = nil
    ) -> Single<NavigatorRoute?> {
        let waypointCoords = waypoints.map {
            (latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
        }

        let request = SearchPlaceDirectionsRequest(
            originCoordinate: originCoordinate,
            destinationCoordinate: Coordinate(
                latitude: destination.coordinate.latitude,
                longitude: destination.coordinate.longitude
            ),
            waypointCoordinates: waypointCoords,
            avoidTolls: avoidTolls,
            avoidHighways: avoidHighways,
            departureTime: departureTime
        )

        return restAPITransport
            .callServerApi(requestBody: request)
            .map {
                NavigatorRoute(
                    response: $0,
                    destination: destination,
                    waypoints: waypoints,
                    avoidTolls: avoidTolls,
                    avoidHighways: avoidHighways,
                    departureTime: departureTime
                )
            }
    }
}
