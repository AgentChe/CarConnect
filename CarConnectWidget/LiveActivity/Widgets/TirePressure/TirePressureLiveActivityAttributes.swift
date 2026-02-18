//
//  TirePressureLiveActivityAttributes.swift
//  Runner
//
//  Created by Андрей Чернышев on 17.01.2026.
//

import ActivityKit

struct TirePressureLiveActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var fLeft: Double?
        var bLeft: Double?
        var fRight: Double?
        var bRight: Double?

        enum CodingKeys: String, CodingKey {
            case fLeft = "front_left"
            case bLeft = "back_left"
            case fRight = "front_right"
            case bRight = "back_right"
        }
    }

    let vehicleId: String
}
