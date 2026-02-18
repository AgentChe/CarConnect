//
//  AccessCarLiveActivityAttributes.swift
//  Runner
//
//  Created by Андрей Чернышев on 17.01.2026.
//

import ActivityKit

struct AccessCarLiveActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var vehicleMark: String
        var vehicleModel: String
        var vehicleUrl: String?
    }
    
    let vehicleId: String
}
