//
//  PowerLiveActivityAttributes.swift
//  Runner
//
//  Created by Андрей Чернышев on 17.01.2026.
//

import ActivityKit

struct PowerLiveActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var vehicleMark: String
        var vehicleModel: String
        var vehicleUrl: String?
        var isElectric: Bool
        var powerPercent: Int?

        enum CodingKeys: String, CodingKey {
            case isElectric   = "is_electric"
            case powerPercent = "percent"
            case vehicleMark  = "make"
            case vehicleModel = "model"
            case vehicleUrl   = "preview"
        }

        var isWarningLevel: Bool {
            (powerPercent ?? 0) <= GlobalDefinitions.Metrics.limitDriveSourceWarning
        }

        var isDangerLevel: Bool {
            (powerPercent ?? 0) <= GlobalDefinitions.Metrics.limitDriveSourceDanger
        }
    }

    let vehicleId: String
}
