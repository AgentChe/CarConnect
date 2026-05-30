//
//  NavigatorPreset.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 26.05.2026.
//

enum NavigatorPreset: CaseIterable {
    case parking
    case gasStation
    case carRepair
    case atm
    case hospital
    case pharmacy
    case restaurant

    var googleType: String {
        switch self {
        case .parking:
            return "parking"
        case .gasStation:
            return "gas_station"
        case .carRepair:
            return "car_repair"
        case .atm:
            return "atm"
        case .hospital:
            return "hospital"
        case .pharmacy:
            return "pharmacy"
        case .restaurant:
            return "restaurant"
        }
    }
}
