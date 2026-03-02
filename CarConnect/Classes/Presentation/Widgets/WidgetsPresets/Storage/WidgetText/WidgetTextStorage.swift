//
//  WidgetTextStorage.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 02.03.2026.
//

import Foundation
import WidgetKit

final class WidgetTextStorage {
    enum Constants {
        static let quotesKey = "widget_text_storage_quotes_key"
    }
    
    static let shared = WidgetTextStorage()
    
    private init() {}
    
    private lazy var userDefaults = UserDefaults(suiteName: GlobalDefinitions.appGroupId)
    
    private lazy var encoder = JSONEncoder()
    private lazy var decoder = JSONDecoder()
}

// MARK: Public
extension WidgetTextStorage {
    func loadAllQuotes() -> [WidgetTextQuoteStorageModel] {
        guard let data = userDefaults?.data(forKey: Constants.quotesKey) else { return [] }
        
        let decoded = try? decoder.decode([WidgetTextQuoteStorageModel].self, from: data)
        
        return decoded ?? []
    }
    
    func persist(quotesModels: [WidgetTextQuoteStorageModel]) {
        guard let data = try? encoder.encode(quotesModels) else { return }
        
        userDefaults?.set(data, forKey: Constants.quotesKey)
        
        WidgetCenter.shared.reloadAllTimelines()
    }
}
