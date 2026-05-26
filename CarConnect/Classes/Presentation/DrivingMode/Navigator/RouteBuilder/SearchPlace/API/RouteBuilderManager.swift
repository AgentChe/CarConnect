//
//  RouteBuilderManager.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 26.05.2026.
//

import RxSwift
import CoreLocation

protocol RouteBuilderManagerProtocol {
    func searchPlaces(
        query: String,
        coordinate: Coordinate
    ) -> Single<[NavigatorPlace]>
    func searchNearby(
        preset: NavigatorPreset,
        coordinate: Coordinate
    ) -> Single<[NavigatorPlace]>
    func fetchPlaceDetails(placeId: String) -> Single<NavigatorPlace?>
    func fetchDirections(
        destination: NavigatorPlace,
        originCoordinate: Coordinate,
        waypoints: [NavigatorPlace],
        avoidTolls: Bool,
        avoidHighways: Bool,
        departureTime: Date?
    ) -> Single<NavigatorRoute?>
}

final class RouteBuilderManager {
    private lazy var restAPITransport = RestAPITransport()
}

// MARK: RouteBuilderManagerProtocol
extension RouteBuilderManager: RouteBuilderManagerProtocol {
    func searchPlaces(query: String, coordinate: Coordinate) -> Single<[NavigatorPlace]> {
        let request = SearchPlaceAutocompleteRequest(
            query: query,
            coordinate: coordinate
        )

        return restAPITransport
            .callServerApi(requestBody: request)
            .map { NavigatorPlace.mapAutocomplete(response: $0) }
    }

    func searchNearby(preset: NavigatorPreset, coordinate: Coordinate) -> Single<[NavigatorPlace]> {
        let request = SearchPlaceNearbyRequest(
            types: [preset.googleType],
            coordinate: coordinate
        )

        return restAPITransport
            .callServerApi(requestBody: request)
            .map { NavigatorPlace.mapNearby(response: $0) }
    }

    func fetchPlaceDetails(placeId: String) -> Single<NavigatorPlace?> {
        let request = SearchPlaceDetailsRequest(placeId: placeId)

        return restAPITransport
            .callServerApi(requestBody: request)
            .map { NavigatorPlace.mapDetails(response: $0) }
    }

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
                    destination: destination,
                    waypoints: waypoints,
                    avoidTolls: avoidTolls,
                    avoidHighways: avoidHighways,
                    departureTime: departureTime,
                    response: $0
                )
            }
    }
}
