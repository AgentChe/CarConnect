//
//  WidgetPresetQuery.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 02.03.2026.
//

import AppIntents

struct WidgetPresetQuery: EntityQuery {
    func suggestedEntities() async throws -> [WidgetPresetEntity] {
        let textQuotes = WidgetTextStorage.shared.loadAllQuotes()
            .map { textQuote -> WidgetPresetEntity in
                WidgetPresetEntity(preset: .textQuote(textQuote))
            }
        let textManuallyConfigurations = WidgetTextStorage.shared.loadAllManuallyConfigurations()
            .map { textManuallyConfiguration -> WidgetPresetEntity in
                WidgetPresetEntity(preset: .textManually(textManuallyConfiguration))
            }
        let calendarConfigurations = WidgetCalendarStorage.shared.loadAllConfigurations()
            .map { configuration -> WidgetPresetEntity in
                WidgetPresetEntity(preset: .calendar(configuration))
            }
        let weatherConfigurations = WidgetWeatherStorage.shared.loadAllConfigurations()
            .map { configuration -> WidgetPresetEntity in
                WidgetPresetEntity(preset: .weather(configuration))
            }
        let clockConfigurations = WidgetClockStorage.shared.loadAllConfigurations()
            .map { configuration -> WidgetPresetEntity in
                WidgetPresetEntity(preset: .clock(configuration))
            }
        let clockAIPreviews = WidgetClockStorage.shared.loadAllAIPreviewConfigurations()
            .map { configuration -> WidgetPresetEntity in
                WidgetPresetEntity(preset: .clockAIPreview(configuration))
            }
        let carLogos = WidgetCarLogoStorage.shared.loadAllConfigurations()
            .map { configuration -> WidgetPresetEntity in
                WidgetPresetEntity(preset: .carLogo(configuration))
            }
        
        return textQuotes + textManuallyConfigurations + calendarConfigurations + weatherConfigurations + clockConfigurations + clockAIPreviews + carLogos
    }
    
    func entities(for identifiers: [String]) async throws -> [WidgetPresetEntity] {
        let all = try await suggestedEntities()
        let map = Dictionary(uniqueKeysWithValues: all.map { ($0.id, $0) })
        return identifiers.compactMap { map[$0] }
    }
    
    func defaultResult() async -> WidgetPresetEntity? {
        nil
    }
}
