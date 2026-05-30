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
}
