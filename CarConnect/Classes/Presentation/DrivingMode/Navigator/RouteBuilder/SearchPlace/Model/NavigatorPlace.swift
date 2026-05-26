//
//  NavigatorPlace.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 26.05.2026.
//

struct NavigatorPlace {
    let id: String
    let name: String
    let address: String
    let coordinate: Coordinate
    
    init?(nearbyJSON: [String: Any]) {
        guard
            let id = nearbyJSON["id"] as? String,
            let displayName = nearbyJSON["displayName"] as? [String: Any],
            let name = displayName["text"] as? String,
            let location = nearbyJSON["location"] as? [String: Any],
            let latitude = location["latitude"] as? Double,
            let longitude = location["longitude"] as? Double
        else { return nil }

        self.id = id
        self.name = name
        self.address = nearbyJSON["formattedAddress"] as? String ?? ""
        self.coordinate = Coordinate(latitude: latitude, longitude: longitude)
    }

    init?(autocompleteJSON: [String: Any]) {
        guard
            let placePrediction = autocompleteJSON["placePrediction"] as? [String: Any],
            let placeId = placePrediction["placeId"] as? String,
            let structuredFormat = placePrediction["structuredFormat"] as? [String: Any],
            let mainText = structuredFormat["mainText"] as? [String: Any],
            let name = mainText["text"] as? String
        else { return nil }

        let secondaryText = (structuredFormat["secondaryText"] as? [String: Any])?["text"] as? String

        self.id = placeId
        self.name = name
        self.address = secondaryText ?? ""
        self.coordinate = Coordinate(latitude: 0, longitude: 0)
    }

    init?(detailsJSON: [String: Any]) {
        guard
            let placeId = detailsJSON["place_id"] as? String,
            let name = detailsJSON["name"] as? String,
            let geometry = detailsJSON["geometry"] as? [String: Any],
            let location = geometry["location"] as? [String: Any],
            let latitude = location["lat"] as? Double,
            let longitude = location["lng"] as? Double
        else { return nil }

        self.id = placeId
        self.name = name
        self.address = detailsJSON["formatted_address"] as? String ?? ""
        self.coordinate = Coordinate(latitude: latitude, longitude: longitude)
    }
}

// MARK: Public
extension NavigatorPlace {
    static func mapNearby(response: Any) -> [NavigatorPlace] {
        guard
            let json = response as? [String: Any],
            let places = json["places"] as? [[String: Any]]
        else { return [] }

        return places.compactMap { NavigatorPlace(nearbyJSON: $0) }
    }

    static func mapAutocomplete(response: Any) -> [NavigatorPlace] {
        guard
            let json = response as? [String: Any],
            let suggestions = json["suggestions"] as? [[String: Any]]
        else { return [] }

        return suggestions.compactMap { NavigatorPlace(autocompleteJSON: $0) }
    }

    static func mapDetails(response: Any) -> NavigatorPlace? {
        guard
            let json = response as? [String: Any],
            let result = json["result"] as? [String: Any]
        else { return nil }

        return NavigatorPlace(detailsJSON: result)
    }
}
