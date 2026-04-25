//
//  VehicleSupportLogosResponse.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 02.04.2026.
//

import Foundation

struct VehicleSupportLogosResponse {
    struct Brand {
        let model: String
        let logo: URL
        
        init?(json: [String: Any]) {
            guard
                let model = json["model"] as? String,
                let logoString = json["logo"] as? String,
                let logo = URL(string: logoString)
            else { return nil }
            
            self.model = model
            self.logo = logo
        }
    }
    
    let userBrands: [Brand]
    let catalogBrands: [Brand]
}

// MARK: Public
extension VehicleSupportLogosResponse {
    init?(response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any]
        else { return nil }
        
        userBrands = {
            guard let array = body["user_brands"] as? [[String: Any]] else { return [] }
            return array.compactMap { Brand(json: $0) }
        }()
        catalogBrands = {
            guard let array = body["catalog_brands"] as? [[String: Any]] else { return [] }
            return array.compactMap { Brand(json: $0) }
        }()
    }
}
