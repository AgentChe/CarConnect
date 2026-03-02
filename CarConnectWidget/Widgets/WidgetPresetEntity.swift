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
        }
    }
    
    var displayRepresentation: DisplayRepresentation {
        let title: String = {
            switch preset {
            case .textQuote(let storageModel):
                switch storageModel.quote {
                case .ambitionDrive(let quote):
                    return quote.text
                case .mindsetGrowth(let quote):
                    return quote.text
                case .leadershipImpact(let quote):
                    return quote.text
                case .lifeMeaning(let quote):
                    return quote.text
                }
            }
        }()
        
        return DisplayRepresentation(title: "\(title)")
    }
}
