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
                }
            } else {
                Text("Select preset")
            }
        }
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}
