//
//  SearchPlaceNearbyRequest.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 26.05.2026.
//

import Alamofire

struct SearchPlaceNearbyRequest: APIRequestBody {
    let types: [String]
    let coordinate: Coordinate

    var url: String {
        "https://places.googleapis.com/v1/places:searchNearby"
    }

    var method: HTTPMethod {
        .post
    }

    var headers: HTTPHeaders? {
        [
            "X-Goog-Api-Key": GlobalDefinitions.googleMapsNewApiKey,
            "X-Goog-FieldMask": "places.id,places.displayName,places.formattedAddress,places.location"
        ]
    }

    var parameters: Parameters? {
        [
            "includedTypes": types,
            "maxResultCount": 20,
            "locationRestriction": [
                "circle": [
                    "center": [
                        "latitude": coordinate.latitude,
                        "longitude": coordinate.longitude
                    ],
                    "radius": 5000.0
                ]
            ]
        ]
    }
}
