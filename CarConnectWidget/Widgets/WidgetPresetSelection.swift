//
//  WidgetPresetSelection.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 02.03.2026.
//

enum WidgetPresetSelection: Hashable {
    case textQuote(WidgetTextQuoteStorageModel)
    case textManually(WidgetTextManuallyStorageModel)
    case calendar(WidgetCalendarStorageModel)
    case weather(WidgetWeatherStorageModel)
}
