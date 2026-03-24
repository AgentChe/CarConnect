//
//  FetchLocationsRequest.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 24.03.2026.
//

import Alamofire

struct FetchLocationsRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    let page: Int
    let search: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/reference/cities"
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
            "internal_id": internalId,
            "page": page,
            "search": search
        ]
    }
}
