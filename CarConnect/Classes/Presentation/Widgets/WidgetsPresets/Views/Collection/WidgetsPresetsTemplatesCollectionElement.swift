//
//  WidgetsPresetsTemplatesCollectionElement.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.02.2026.
//

enum WidgetsPresetsTemplatesCollectionElement {
    // Helper
    case openHelper
    
    // Presets of text type
    case textManually(String?, WidgetTextManuallyConfiguration)
    case quoteAmbitionDrive(String?, WidgetTextQuoteAmbitionDrive, WidgetTextQuoteConfiguration)
    case quoteMindsetGrowth(String?, WidgetTextQuoteMindsetGrowth, WidgetTextQuoteConfiguration)
    case quoteLeadershipImpact(String?, WidgetTextQuoteLeadershipImpact, WidgetTextQuoteConfiguration)
    case quoteLifeMeaning(String?, WidgetTextQuoteLifeMeaning, WidgetTextQuoteConfiguration)
    
    // Presets of calendar
    case calendar(String?, WidgetCalendarConfiguration)
    
    // Presets of weather
    case weather(String?, WidgetWeatherConfiguration, WeatherData)
    
    // Presets of clock
    case clock(String?, WidgetClockConfiguration)
    case clockAIPreview(String?, WidgetClockAIPreviewConfiguration)
    
    // Presets of carLogo
    case carLogo(String?, WidgetCarLogoConfiguration, Bool, Int?)
    
    // Presets of photo
    case aiPhoto(String?, WidgetAIPhotoConfiguration?)
    case photoWithText(String?, WidgetPhotoWithTextConfiguration)
}
