//
//  Coordinate.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 17.03.2026.
//

struct Coordinate: Codable, Hashable {
    let latitude: Double
    let longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
