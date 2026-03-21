//
//  WidgetWeatherStorage.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 18.03.2026.
//

import Foundation
import WidgetKit

final class WidgetWeatherStorage {
    enum Constants {
        static let weatherConfigurationsKey = "widget_weather_storage_configuration_key"
    }
    
    static let shared = WidgetWeatherStorage()
    
    private init() {}
    
    private lazy var userDefaults = UserDefaults(suiteName: GlobalDefinitions.appGroupId)
    
    private lazy var encoder = JSONEncoder()
    private lazy var decoder = JSONDecoder()
}

// MARK: Public
extension WidgetWeatherStorage {
    func loadAllConfigurations() -> [WidgetWeatherStorageModel] {
        guard let data = userDefaults?.data(forKey: Constants.weatherConfigurationsKey) else { return [] }
        
        let decoded = try? decoder.decode([WidgetWeatherStorageModel].self, from: data)
        
        return decoded ?? []
    }
    
    func persist(configurations: [WidgetWeatherStorageModel]) {
        guard let data = try? encoder.encode(configurations) else { return }
        
        userDefaults?.set(data, forKey: Constants.weatherConfigurationsKey)
        
        WidgetCenter.shared.reloadAllTimelines()
    }
}
