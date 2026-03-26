//
//  FetchVehicleWidgetPreviewsRequest.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 25.03.2026.
//

import Alamofire

struct FetchVehicleWidgetPreviewsRequest: APIRequestBody {
    let anonymousId: String
    let internalId: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/vehicle/widget/preview"
    }
    
    var method: HTTPMethod {
        .get
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
    
    var encoding: ParameterEncoding {
        URLEncoding.queryString
    }
}
