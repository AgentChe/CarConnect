//
//  WidgetPresetTimelineProvider.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 02.03.2026.
//

import WidgetKit
import AppIntents

struct WidgetPresetTimelineEntry: TimelineEntry {
    let date: Date
    let model: WidgetPreset?
}

struct WidgetPresetTimelineProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> WidgetPresetTimelineEntry {
        WidgetPresetTimelineEntry(date: .now, model: nil)
    }

    func snapshot(for configuration: WidgetPresetConfigurationIntent, in context: Context) async -> WidgetPresetTimelineEntry {
        WidgetPresetTimelineEntry(date: .now, model: configuration.preset?.preset)
    }

    func timeline(for configuration: WidgetPresetConfigurationIntent, in context: Context) async -> Timeline<WidgetPresetTimelineEntry> {
        let now = Date()
        
        guard let preset = configuration.preset?.preset else {
            let entry = WidgetPresetTimelineEntry(date: now, model: nil)
            return Timeline(entries: [entry], policy: .never)
        }
        
        let calendar = Calendar.current
        
        switch preset {
        case .textQuote(let selected):
            let quotes: [WidgetTextQuote] = {
                switch selected.quote {
                case .ambitionDrive(let quote):
                    var quotes = WidgetTextQuoteAmbitionDrive.templates()
                    quotes.removeAll(where: { $0 == quote })
                    return quotes.map { WidgetTextQuote.ambitionDrive($0) }
                case .mindsetGrowth(let quote):
                    var quotes = WidgetTextQuoteMindsetGrowth.templates()
                    quotes.removeAll(where: { $0 == quote })
                    return quotes.map { WidgetTextQuote.mindsetGrowth($0) }
                case .leadershipImpact(let quote):
                    var quotes = WidgetTextQuoteLeadershipImpact.templates()
                    quotes.removeAll(where: { $0 == quote })
                    return quotes.map { WidgetTextQuote.leadershipImpact($0) }
                case .lifeMeaning(let quote):
                    var quotes = WidgetTextQuoteLifeMeaning.templates()
                    quotes.removeAll(where: { $0 == quote })
                    return quotes.map { WidgetTextQuote.lifeMeaning($0) }
                }
            }()
            
            let nextModels = quotes
                .map { quote -> WidgetTextQuoteStorageModel in
                    WidgetTextQuoteStorageModel(
                        id: "\(selected.id)_\(quote.hashValue)",
                        quote: quote,
                        configuration: selected.configuration
                    )
                }
                .shuffled()
            let allModels = [selected] + nextModels
            
            let daysToSchedule = allModels.count
            let startOfToday = calendar.startOfDay(for: now)
            
            var entries = [WidgetPresetTimelineEntry]()
            
            entries.append(WidgetPresetTimelineEntry(date: now, model: .textQuote(allModels[0])))
            
            for dayOffset in 1...daysToSchedule {
                guard let dayDate = calendar.date(byAdding: .day, value: dayOffset, to: startOfToday) else { continue }
                
                guard let model = allModels[safe: dayOffset % allModels.count] else { continue }
                
                entries.append(WidgetPresetTimelineEntry(date: dayDate, model: .textQuote(model)))
            }
            
            let reloadDate = calendar.date(byAdding: .day, value: daysToSchedule + 1, to: startOfToday)
                ?? calendar.date(byAdding: .day, value: 1, to: startOfToday)
            return Timeline(entries: entries, policy: reloadDate == nil ? .never : .after(reloadDate!))
        }
    }
}
