//
//  Location.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 17.03.2026.
//

struct Location: Codable, Hashable {
    let name: String
    let coordinate: Coordinate
}

// MARK: Public
extension Location {
    static func newYork() -> Location {
        Location(
            name: "New York",
            coordinate: Coordinate(
                latitude: 40.7128,
                longitude: -74.0060
            )
        )
    }
}
