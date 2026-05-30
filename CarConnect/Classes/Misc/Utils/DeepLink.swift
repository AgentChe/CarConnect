//
//  DeepLink.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 30.05.2026.
//

import Foundation

enum DeepLink {
    enum Constants {
        static let scheme = "carconnectapp"
        static let drivingModeNavigator = "drivingmodenavigator"
    }

    static func drivingModeNavigatorURL() -> URL {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.drivingModeNavigator
        return components.url!
    }

    static func isDrivingModeNavigator(_ url: URL) -> Bool {
        url.scheme == Constants.scheme && url.host == Constants.drivingModeNavigator
    }
}

enum DeepLinkIntent {
    case openDrivingModeNavigator
}
