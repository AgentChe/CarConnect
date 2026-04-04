//
//  WidgetPhotoStorage.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.04.2026.
//

import Foundation
import WidgetKit

final class WidgetPhotoStorage {
    enum Constants {
        static let aiPhotosConfigurationsKey = "widget_ai_photos_storage_configuration_key"
        static let photoWithTextConfigurationsKey = "widget_photo_with_text_configurations_key"
    }
    
    static let shared = WidgetPhotoStorage()
    
    private init() {}
    
    private lazy var userDefaults = UserDefaults(suiteName: GlobalDefinitions.appGroupId)
    
    private lazy var encoder = JSONEncoder()
    private lazy var decoder = JSONDecoder()
}

// MARK: Public
extension WidgetPhotoStorage {
    func loadAllAIPhotosConfigurations() -> [WidgetAIPhotoStorageModel] {
        guard let data = userDefaults?.data(forKey: Constants.aiPhotosConfigurationsKey) else { return [] }
        
        let decoded = try? decoder.decode([WidgetAIPhotoStorageModel].self, from: data)
        
        return decoded ?? []
    }
    
    func loadAllPhotoWithTextConfigurations() -> [WidgetPhotoWithTextStorageModel] {
        guard let data = userDefaults?.data(forKey: Constants.photoWithTextConfigurationsKey) else { return [] }
        
        let decoded = try? decoder.decode([WidgetPhotoWithTextStorageModel].self, from: data)
        
        return decoded ?? []
    }
    
    func persist(aiPhotosConfigurations: [WidgetAIPhotoStorageModel]) {
        guard let data = try? encoder.encode(aiPhotosConfigurations) else { return }
        
        userDefaults?.set(data, forKey: Constants.aiPhotosConfigurationsKey)
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func persist(photoWithTextConfigurations: [WidgetPhotoWithTextStorageModel]) {
        guard let data = try? encoder.encode(photoWithTextConfigurations) else { return }
        
        userDefaults?.set(data, forKey: Constants.photoWithTextConfigurationsKey)
        
        WidgetCenter.shared.reloadAllTimelines()
    }
}
