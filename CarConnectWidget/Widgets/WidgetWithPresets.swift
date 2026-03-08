//
//  WidgetWithPresets.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 02.03.2026.
//

import WidgetKit
import SwiftUI
import AppIntents

struct WidgetWithPresets: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: "WidgetWithPresets",
            intent: WidgetPresetConfigurationIntent.self,
            provider: WidgetPresetTimelineProvider()
        ) { entry in
            if let preset = entry.model {
                switch preset {
                case .textQuote(let storageModel):
                    switch storageModel.quote {
                    case .ambitionDrive(let quote):
                        QuoteAmbitionDriveWidgetView(quote: quote, configuration: storageModel.configuration)
                    case .mindsetGrowth(let quote):
                        QuoteMindsetGrowthWidgetView(quote: quote, configuration: storageModel.configuration)
                    case .leadershipImpact(let quote):
                        QuoteLeadershipImpactWidgetView(quote: quote, configuration: storageModel.configuration)
                    case .lifeMeaning(let quote):
                        QuoteLifeMeaningWidgetView(quote: quote, configuration: storageModel.configuration)
                    }
                case .textManually(let storageModel):
                    WidgetTextManuallyResultSwiftUIView(configuration: storageModel.configuration)
                case .calendar(let model):
                    switch model.configuration.style {
                    case .monthGrid:
                        CalendarMonthGridWidgetView(configuration: model.configuration)
                    case .weekdayAndDayNumberLarge:
                        CalendarWeekdayAndDayNumberLargeWidgetView(configuration: model.configuration, metrics: .large)
                    case .dayNumberWithMonthGrid:
                        DayNumberWithMonthGridWidgetView(metrics: .large, configuration: model.configuration)
                    case .monthAbbrevAndDayNumberLarge:
                        CalendarMonthAbbrevAndDayNumberLargeWidgetView(configuration: model.configuration, metrics: .large)
                    case .monthDayAndWeekdayText:
                        CalendarMonthDayAndWeekdayTextWidgetView(configuration: model.configuration, metrics: .large)
                    case .stackedMonthDayWeekday:
                        StackedMonthDayWeekdayWidgetView(configuration: model.configuration, metrics: .large)
                    }
                }
            } else {
                Text("Select preset")
            }
        }
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}
