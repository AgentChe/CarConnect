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
    let content: WidgetPresetRenderModel?
}

struct WidgetPresetTimelineProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> WidgetPresetTimelineEntry {
        WidgetPresetTimelineEntry(date: .now, content: nil)
    }

    func snapshot(for configuration: WidgetPresetConfigurationIntent, in context: Context) async -> WidgetPresetTimelineEntry {
        let content: WidgetPresetRenderModel? = await {
            guard let preset = configuration.preset?.preset else { return nil }
            
            switch preset {
            case .textQuote(let model):
                return .textQuote(model)
            case .textManually(let model):
                return .textManually(model)
            case .calendar(let model):
                return .calendar(model)
            case .weather(let model):
                do {
                    let weatherData = try await WeatherAPI().fetchWeather(location: model.configuration.location)
                    return .weather(model, weatherData)
                } catch {
                    return nil
                }
            case .clock(let model):
                return .clock(model)
            case .clockAIPreview(let model):
                return .clockAIPreview(model)
            }
        }()

        return WidgetPresetTimelineEntry(date: .now, content: content)
    }

    func timeline(for configuration: WidgetPresetConfigurationIntent, in context: Context) async -> Timeline<WidgetPresetTimelineEntry> {
        let now = Date()
        
        guard let preset = configuration.preset?.preset else {
            let entry = WidgetPresetTimelineEntry(date: now, content: nil)
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
                        name: selected.name,
                        quote: quote,
                        configuration: selected.configuration
                    )
                }
                .shuffled()
            let allModels = [selected] + nextModels
            
            let daysToSchedule = allModels.count
            let startOfToday = calendar.startOfDay(for: now)
            
            var entries = [WidgetPresetTimelineEntry]()
            
            entries.append(WidgetPresetTimelineEntry(date: now, content: .textQuote(allModels[0])))
            
            for dayOffset in 1...daysToSchedule {
                guard let dayDate = calendar.date(byAdding: .day, value: dayOffset, to: startOfToday) else { continue }
                
                guard let model = allModels[safe: dayOffset % allModels.count] else { continue }
                
                entries.append(WidgetPresetTimelineEntry(date: dayDate, content: .textQuote(model)))
            }
            
            let reloadDate = calendar.date(byAdding: .day, value: daysToSchedule + 1, to: startOfToday)
                ?? calendar.date(byAdding: .day, value: 1, to: startOfToday)
            return Timeline(entries: entries, policy: reloadDate == nil ? .never : .after(reloadDate!))
        case .textManually(let textManuallyConfiguration):
            let entry = WidgetPresetTimelineEntry(date: now, content: .textManually(textManuallyConfiguration))
            return Timeline(entries: [entry], policy: .never)
        case .calendar(let configuration):
            let entry = WidgetPresetTimelineEntry(date: now, content: .calendar(configuration))

            let startOfToday = calendar.startOfDay(for: now)
            let nextDay = calendar.date(byAdding: .day, value: 1, to: startOfToday) ?? now.addingTimeInterval(86400)
            let reloadDate = calendar.date(byAdding: .minute, value: 1, to: nextDay) ?? nextDay

            return Timeline(entries: [entry], policy: .after(reloadDate))
        case .weather(let configuration):
            do {
                let weatherData = try await WeatherAPI().fetchWeather(location: configuration.configuration.location)
                let entry = WidgetPresetTimelineEntry(
                    date: now,
                    content: .weather(configuration, weatherData)
                )

                let reloadDate = calendar.date(byAdding: .minute, value: 30, to: now) ?? now.addingTimeInterval(1800)
                return Timeline(entries: [entry], policy: .after(reloadDate))
            } catch {
                let entry = WidgetPresetTimelineEntry(date: now, content: nil)
                let reloadDate = calendar.date(byAdding: .minute, value: 30, to: now) ?? now.addingTimeInterval(1800)
                return Timeline(entries: [entry], policy: .after(reloadDate))
            }
        case .clock(let configuration):
            let now = Date()

            let startOfCurrentMinute = calendar.date(
                from: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: now)
            ) ?? now

            let firstFutureMinute = calendar.date(byAdding: .minute, value: 1, to: startOfCurrentMinute)
                ?? now.addingTimeInterval(60)

            var entries: [WidgetPresetTimelineEntry] = [
                WidgetPresetTimelineEntry(
                    date: now,
                    content: .clock(configuration)
                )
            ]

            for minuteOffset in 0..<60 {
                guard let entryDate = calendar.date(byAdding: .minute, value: minuteOffset, to: firstFutureMinute) else {
                    continue
                }

                entries.append(
                    WidgetPresetTimelineEntry(
                        date: entryDate,
                        content: .clock(configuration)
                    )
                )
            }

            let reloadDate = calendar.date(byAdding: .minute, value: 60, to: firstFutureMinute)
                ?? firstFutureMinute.addingTimeInterval(3600)

            return Timeline(entries: entries, policy: .after(reloadDate))
        case .clockAIPreview(let configuration):
            let now = Date()

            let startOfCurrentMinute = calendar.date(
                from: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: now)
            ) ?? now

            let firstFutureMinute = calendar.date(byAdding: .minute, value: 1, to: startOfCurrentMinute)
                ?? now.addingTimeInterval(60)

            var entries: [WidgetPresetTimelineEntry] = [
                WidgetPresetTimelineEntry(
                    date: now,
                    content: .clockAIPreview(configuration)
                )
            ]

            for minuteOffset in 0..<60 {
                guard let entryDate = calendar.date(byAdding: .minute, value: minuteOffset, to: firstFutureMinute) else {
                    continue
                }

                entries.append(
                    WidgetPresetTimelineEntry(
                        date: entryDate,
                        content: .clockAIPreview(configuration)
                    )
                )
            }

            let reloadDate = calendar.date(byAdding: .minute, value: 60, to: firstFutureMinute)
                ?? firstFutureMinute.addingTimeInterval(3600)

            return Timeline(entries: entries, policy: .after(reloadDate))
        }
    }
}
