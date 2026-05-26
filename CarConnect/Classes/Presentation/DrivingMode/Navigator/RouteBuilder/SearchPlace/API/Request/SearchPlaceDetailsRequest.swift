//
//  SearchPlaceDetailsRequest.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 26.05.2026.
//

import Alamofire

struct SearchPlaceDetailsRequest: APIRequestBody {
    let placeId: String

    var url: String {
        "https://maps.googleapis.com/maps/api/place/details/json"
    }

    var method: HTTPMethod {
        .get
    }

    var encoding: ParameterEncoding {
        URLEncoding.default
    }

    var parameters: Parameters? {
        [
            "place_id": placeId,
            "fields": "place_id,name,formatted_address,geometry",
            "key": GlobalDefinitions.googleMapsApiKey
        ]
    }
}
