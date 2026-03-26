//
//  WidgetClockStorage.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 25.03.2026.
//

import Foundation
import WidgetKit

final class WidgetClockStorage {
    enum Constants {
        static let clockConfigurationsKey = "widget_clock_storage_configuration_key"
    }
    
    static let shared = WidgetClockStorage()
    
    private init() {}
    
    private lazy var userDefaults = UserDefaults(suiteName: GlobalDefinitions.appGroupId)
    
    private lazy var encoder = JSONEncoder()
    private lazy var decoder = JSONDecoder()
}

// MARK: Public
extension WidgetClockStorage {
    func loadAllConfigurations() -> [WidgetClockStorageModel] {
        guard let data = userDefaults?.data(forKey: Constants.clockConfigurationsKey) else { return [] }
        
        let decoded = try? decoder.decode([WidgetClockStorageModel].self, from: data)
        
        return decoded ?? []
    }
    
    func persist(configurations: [WidgetClockStorageModel]) {
        guard let data = try? encoder.encode(configurations) else { return }
        
        userDefaults?.set(data, forKey: Constants.clockConfigurationsKey)
        
        WidgetCenter.shared.reloadAllTimelines()
    }
}
