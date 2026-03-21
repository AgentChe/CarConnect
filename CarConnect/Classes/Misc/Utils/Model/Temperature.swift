//
//  Temperature.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 17.03.2026.
//

enum TemperatureType: Codable, Hashable {
    case celsius, fahrenheit
}

struct Temperature: Codable, Hashable {
    let celsius: Double
    let fahrenheit: Double
}
