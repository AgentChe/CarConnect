//
//  WidgetsPresetsTemplatesCollectionElement.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.02.2026.
//

enum WidgetsPresetsTemplatesCollectionElement {
    // Presets of text type
    case textManually(WidgetTextManuallyConfiguration)
    case quoteAmbitionDrive(WidgetTextQuoteAmbitionDrive, WidgetTextQuoteConfiguration)
    case quoteMindsetGrowth(WidgetTextQuoteMindsetGrowth, WidgetTextQuoteConfiguration)
    case quoteLeadershipImpact(WidgetTextQuoteLeadershipImpact, WidgetTextQuoteConfiguration)
    case quoteLifeMeaning(WidgetTextQuoteLifeMeaning, WidgetTextQuoteConfiguration)
}
