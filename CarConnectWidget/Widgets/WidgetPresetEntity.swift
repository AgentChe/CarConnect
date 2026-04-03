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
    
    let preset: WidgetPresetSelection
    
    var id: String {
        switch preset {
        case .textQuote(let textQuote):
            return textQuote.id
        case .textManually(let manuallyConfiguration):
            return manuallyConfiguration.id
        case .calendar(let model):
            return model.id
        case .weather(let model):
            return model.id
        case .clock(let model):
            return model.id
        case .clockAIPreview(let model):
            return model.id
        case .carLogo(let model):
            return model.id
        }
    }
    
    var displayRepresentation: DisplayRepresentation {
        let title: String = {
            switch preset {
            case .textQuote(let storageModel):
                return storageModel.name
            case .textManually(let storateModel):
                return storateModel.name
            case .calendar(let model):
                return model.name
            case .weather(let model):
                return model.name
            case .clock(let model):
                return model.name
            case .clockAIPreview(let model):
                return model.name
            case .carLogo(let model):
                return model.name
            }
        }()
        
        return DisplayRepresentation(title: "\(title)")
    }
}
