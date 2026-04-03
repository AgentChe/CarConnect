//
//  WidgetCarLogoStorage.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 02.04.2026.
//

import Foundation
import WidgetKit

final class WidgetCarLogoStorage {
    enum Constants {
        static let carLogoConfigurationsKey = "widget_car_logo_storage_configuration_key"
    }
    
    static let shared = WidgetCarLogoStorage()
    
    private init() {}
    
    private lazy var userDefaults = UserDefaults(suiteName: GlobalDefinitions.appGroupId)
    
    private lazy var encoder = JSONEncoder()
    private lazy var decoder = JSONDecoder()
}

// MARK: Public
extension WidgetCarLogoStorage {
    func loadAllConfigurations() -> [WidgetCarLogoStorageModel] {
        guard let data = userDefaults?.data(forKey: Constants.carLogoConfigurationsKey) else { return [] }
        
        let decoded = try? decoder.decode([WidgetCarLogoStorageModel].self, from: data)
        
        return decoded ?? []
    }
    
    func persist(configurations: [WidgetCarLogoStorageModel]) {
        guard let data = try? encoder.encode(configurations) else { return }
        
        userDefaults?.set(data, forKey: Constants.carLogoConfigurationsKey)
        
        WidgetCenter.shared.reloadAllTimelines()
    }
}
