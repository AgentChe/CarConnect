//
//  WidgetCalendarStorage.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 05.03.2026.
//

import Foundation
import WidgetKit

final class WidgetCalendarStorage {
    enum Constants {
        static let calendarConfigurationsKey = "widget_calendar_storage_configuration_key"
    }
    
    static let shared = WidgetCalendarStorage()
    
    private init() {}
    
    private lazy var userDefaults = UserDefaults(suiteName: GlobalDefinitions.appGroupId)
    
    private lazy var encoder = JSONEncoder()
    private lazy var decoder = JSONDecoder()
}

// MARK: Public
extension WidgetCalendarStorage {
    func loadAllConfigurations() -> [WidgetCalendarStorageModel] {
        guard let data = userDefaults?.data(forKey: Constants.calendarConfigurationsKey) else { return [] }
        
        let decoded = try? decoder.decode([WidgetCalendarStorageModel].self, from: data)
        
        return decoded ?? []
    }
    
    func persist(configurations: [WidgetCalendarStorageModel]) {
        guard let data = try? encoder.encode(configurations) else { return }
        
        userDefaults?.set(data, forKey: Constants.calendarConfigurationsKey)
        
        WidgetCenter.shared.reloadAllTimelines()
    }
}
