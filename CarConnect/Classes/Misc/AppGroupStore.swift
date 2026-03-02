//
//  AppGroupStore.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 18.02.2026.
//

import Foundation

final class AppGroupStore {
    static let shared = AppGroupStore()
    
    private lazy var userDefaults = UserDefaults(suiteName: GlobalDefinitions.appGroupId)
    
    private init() {}
}

// MARK: Public
extension AppGroupStore {
    func appGroupContainerURL() throws -> URL {
        guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: GlobalDefinitions.appGroupId) else {
            throw NSError(domain: "No app group container", code: 404)
        }
        return url
    }
}
