//
//  SearchPlaceAutocompleteRequest.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 26.05.2026.
//

import Alamofire

struct SearchPlaceAutocompleteRequest: APIRequestBody {
    let query: String
    let coordinate: Coordinate

    var url: String {
        "https://places.googleapis.com/v1/places:autocomplete"
    }

    var method: HTTPMethod {
        .post
    }

    var headers: HTTPHeaders? {
        [
            "X-Goog-Api-Key": GlobalDefinitions.googleMapsNewApiKey
        ]
    }

    var parameters: Parameters? {
        [
            "input": query,
            "locationBias": [
                "circle": [
                    "center": [
                        "latitude": coordinate.latitude,
                        "longitude": coordinate.longitude
                    ],
                    "radius": 50000.0
                ]
            ]
        ]
    }
}
