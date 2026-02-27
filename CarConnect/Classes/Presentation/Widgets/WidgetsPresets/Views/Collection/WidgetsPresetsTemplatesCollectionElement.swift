//
//  WidgetsPresetsTemplatesCollectionElement.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.02.2026.
//

enum WidgetsPresetsTemplatesCollectionElement {
    // Presets of text type
    case textManually(WidgetTextManuallyConfiguration)
    case quoteAmbitionDrive(String?, WidgetTextQuoteAmbitionDrive, WidgetTextQuoteConfiguration)
    case quoteMindsetGrowth(String?, WidgetTextQuoteMindsetGrowth, WidgetTextQuoteConfiguration)
    case quoteLeadershipImpact(String?, WidgetTextQuoteLeadershipImpact, WidgetTextQuoteConfiguration)
    case quoteLifeMeaning(String?, WidgetTextQuoteLifeMeaning, WidgetTextQuoteConfiguration)
}
