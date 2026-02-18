//
//  AccessCarDeepLink.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 19.01.2026.
//

import Foundation

enum AccessCarDeepLink {
    static let scheme = "carconnectapp"
    static let host = "accesscar"
    static let path = "/action"

    enum Action: String {
        case lock
        case unlock
    }

    static func url(action: Action, vehicleId: String) -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = [
            .init(name: "action", value: action.rawValue),
            .init(name: "vehicleId", value: vehicleId)
        ]
        return components.url!
    }
}
