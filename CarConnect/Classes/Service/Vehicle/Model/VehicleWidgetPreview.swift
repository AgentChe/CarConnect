//
//  VehicleWidgetPreview.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 25.03.2026.
//

import Foundation

struct VehicleWidgetPreview {
    let vehicleId: String
    let gallery: [URL]
}

// MARK: Public
extension VehicleWidgetPreview {
    init?(json: [String: Any]) {
        guard
            let vehicleId = json["vehicle_id"] as? String,
            let galleryItems = json["gallery"] as? [String]
        else { return nil }
        
        self.vehicleId = vehicleId
        self.gallery = galleryItems.compactMap { URL(string: $0) }
    }
    
    static func map(response: Any) -> [VehicleWidgetPreview] {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [[String: Any]]
        else { return [] }
        
        return body.compactMap { VehicleWidgetPreview(json: $0) }
    }
}
