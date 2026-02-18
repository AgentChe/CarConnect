//
//  AccessCarDeepLinkParser.swift
//  Runner
//
//  Created by Андрей Чернышев on 20.01.2026.
//

import Foundation

enum AccessCarDeepLinkParser {
    enum Action: String {
        case lock
        case unlock
    }

    struct Payload {
        let action: Action
        let vehicleId: String
        let urlString: String

        func toMap() -> [String: Any] {
            [
                "action": action.rawValue,
                "vehicleId": vehicleId,
                "url": urlString
            ]
        }
    }

    static func parse(_ url: URL) -> Payload? {
        guard url.scheme == "carconnectapp" else { return nil }
        guard url.host == "accesscar" else { return nil }
        guard url.path == "/action" else { return nil }

        let comps = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let actionRaw = comps?.queryItems?.first(where: { $0.name == "action" })?.value
        let vehicleId = comps?.queryItems?.first(where: { $0.name == "vehicleId" })?.value

        guard
            let actionRaw, let action = Action(rawValue: actionRaw),
            let vehicleId, !vehicleId.isEmpty
        else { return nil }

        return Payload(action: action, vehicleId: vehicleId, urlString: url.absoluteString)
    }
}
