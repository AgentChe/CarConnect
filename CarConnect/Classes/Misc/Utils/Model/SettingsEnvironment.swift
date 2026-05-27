//
//  SettingsEnvironment.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.05.2026.
//

import Foundation

final class SettingsEnvironment {
    enum Constants {
        static let temperatureUnitKey = "settings_environment_temperature_unit"
        static let distanceUnitKey = "settings_environment_distance_unit"
    }
    
    static let shared = SettingsEnvironment()
    
    var temperatureUnit: TemperatureUnit {
        didSet {
            userDefaults?.set(temperatureUnit.rawValue, forKey: Constants.temperatureUnitKey)
        }
    }

    var distanceUnit: DistanceUnit {
        didSet {
            userDefaults?.set(distanceUnit.rawValue, forKey: Constants.distanceUnitKey)
        }
    }
    
    private let userDefaults = UserDefaults(suiteName: GlobalDefinitions.appGroupId)
    
    private init() {
        let savedTemperature = userDefaults?.string(forKey: Constants.temperatureUnitKey)
        temperatureUnit = savedTemperature.flatMap { TemperatureUnit(rawValue: $0) } ?? .celsius

        let savedDistance = userDefaults?.string(forKey: Constants.distanceUnitKey)
        distanceUnit = savedDistance.flatMap { DistanceUnit(rawValue: $0) } ?? .metric
    }
}
