//
//  WidgetPresetEntity.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 02.03.2026.
//

import AppIntents

struct WidgetPresetEntity: AppEntity, Identifiable, Hashable {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Preset"
    
    static var defaultQuery = WidgetPresetQuery()
    
    let preset: WidgetPreset
    
    var id: String {
        switch preset {
        case .textQuote(let textQuote):
            return textQuote.id
        case .textManually(let manuallyConfiguration):
            return manuallyConfiguration.id
        }
    }
    
    var displayRepresentation: DisplayRepresentation {
        let title: String = {
            switch preset {
            case .textQuote(let storageModel):
                return storageModel.name
            case .textManually(let storateModel):
                return storateModel.name
            }
        }()
        
        return DisplayRepresentation(title: "\(title)")
    }
}
