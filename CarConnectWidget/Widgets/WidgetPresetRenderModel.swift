//
//  WidgetPresetRenderModel.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 24.03.2026.
//

enum WidgetPresetRenderModel: Hashable {
    case textQuote(WidgetTextQuoteStorageModel)
    case textManually(WidgetTextManuallyStorageModel)
    case calendar(WidgetCalendarStorageModel)
    case weather(WidgetWeatherStorageModel, WeatherData)
    case clock(WidgetClockStorageModel)
    case clockAIPreview(WidgetClockAIPreviewStorageModel)
    case carLogo(WidgetCarLogoStorageModel)
    case aiPhoto(WidgetAIPhotoStorageModel)
    case photoWithText(WidgetPhotoWithTextStorageModel)
}
