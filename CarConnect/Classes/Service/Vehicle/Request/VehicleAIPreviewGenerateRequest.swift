//
//  VehicleAIPreviewGenerateRequest.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.04.2026.
//

import Alamofire

struct VehicleAIPreviewGenerateRequest: APIFormDataRequestBody {
    let anonymousId: String
    let internalId: String
    let image: UIImage
    let prompt: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/ai/preview_generate"
    }
    
    var parameters: [String : Data]? {
        var parameters = [String: Data]()
        
        if let anonymousId = anonymousId.data(using: .utf8) {
            parameters["anonymous_id"] = anonymousId
        }
        
        if let internalId = internalId.data(using: .utf8) {
            parameters["internal_id"] = internalId
        }
        
        if let prompt = prompt.data(using: .utf8) {
            parameters["prompt"] = prompt
        }
        
        return parameters
    }
    
    var headers: Alamofire.HTTPHeaders? {
        [
            "Access-Token": GlobalDefinitions.apiKey
        ]
    }
}
