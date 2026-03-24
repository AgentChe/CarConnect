//
//  Location.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 17.03.2026.
//

import Foundation

struct Location: Codable, Hashable {
    let id: String
    let name: String
    let coordinate: Coordinate
    
    init(id: String, name: String, coordinate: Coordinate) {
        self.id = id
        self.name = name
        self.coordinate = coordinate
    }
    
    init?(json: [String: Any]) {
        guard
            let name = json["name"] as? String,
            let latitude = json["lat"] as? Double,
            let longitude = json["lon"] as? Double
        else { return nil }
        
        self.id = UUID().uuidString
        self.name = name
        self.coordinate = Coordinate(
            latitude: latitude,
            longitude: longitude
        )
    }
}

// MARK: Public
extension Location {
    enum Constants {
        static let newYorkIdDefault = "location_new_york_default_id"
    }
    
    var isDefault: Bool {
        id == Constants.newYorkIdDefault
    }
    
    static func newYork() -> Location {
        Location(
            id: Constants.newYorkIdDefault,
            name: "New York",
            coordinate: Coordinate(
                latitude: 40.7128,
                longitude: -74.0060
            )
        )
    }
    
    static func map(response: Any) -> Page<[Location]>? {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [String: Any],
            let items = body["items"] as? [[String: Any]],
            let pageInfoJSON = body["pagination"] as? [String: Any],
            let pageInfo = PageInfo(json: pageInfoJSON)
        else { return nil }
        
        let locations = items.compactMap { Location(json: $0) }
        
        return Page(info: pageInfo, elements: locations)
    }
}
