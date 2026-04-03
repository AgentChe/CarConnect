//
//  FetchVehicleSupportLogosRequest.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 02.04.2026.
//

import Alamofire

struct FetchVehicleSupportLogosRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/vehicle/support/logos"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var headers: HTTPHeaders? {
        [
            "Access-Token": GlobalDefinitions.apiKey
        ]
    }
    
    var parameters: Parameters? {
        [
            "anonymous_id": anonymousId,
            "internal_id": internalId
        ]
    }
}
