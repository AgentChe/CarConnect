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
            if let content = entry.content {
                switch content {
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
                case .weather(let model, let weatherData):
                    switch model.configuration.style {
                    case .weatherIconTemperature:
                        WeatherIconTemperatureWidgetView(
                            configuration: model.configuration,
                            weatherData: weatherData,
                            metrics: .large
                        )
                    case .currentWeatherSummary:
                        CurrentWeatherSummaryWidgetView(
                            configuration: model.configuration,
                            weatherData: weatherData,
                            metrics: .large
                        )
                    case .locationTemperature:
                        LocationTemperatureWidgetView(
                            configuration: model.configuration,
                            weatherData: weatherData,
                            metrics: .large
                        )
                    case .compactWeatherForecast:
                        CompactWeatherForecastWidgetView(
                            configuration: model.configuration,
                            weatherData: weatherData,
                            metrics: .large
                        )
                    case .todayTomorrowWeather:
                        TodayTomorrowWeatherWidgetView(
                            configuration: model.configuration,
                            weatherData: weatherData,
                            metrics: .large
                        )
                    case .weatherClock:
                        WeatherClockWidgetView(
                            configuration: model.configuration,
                            weatherData: weatherData,
                            metrics: .large
                        )
                    case .weatherConditionForecast:
                        WeatherConditionForecastWidgetView(
                            configuration: model.configuration,
                            weatherData: weatherData,
                            metrics: .large
                        )
                    case .digitalWeatherClock:
                        DigitalWeatherClockWidgetView(
                            configuration: model.configuration,
                            weatherData: weatherData,
                            metrics: .large,
                            date: Date()
                        )
                    }
                case .clock(let model):
                    switch model.configuration.style {
                    case .digitalStacked:
                        DigitalStackedWidgetView(configuration: model.configuration, metrics: .large, date: entry.date)
                    case .digitalMirror:
                        DigitalMirrorWidgetView(configuration: model.configuration, metrics: .small, date: entry.date)
                    case .digitalClassic:
                        DigitalClassicWidgetView(configuration: model.configuration, metrics: .large, date: entry.date)
                    case .splitFlap:
                        SplitFlapWidgetView(metrics: .large, configuration: model.configuration, date: entry.date)
                    case .calendarClock:
                        CalendarClockWidgetView(configuration: model.configuration, metrics: .large, date: entry.date)
                    case .analogClock:
                        AnalogClockWidgetView(configuration: model.configuration, metrics: .large, date: entry.date)
                    }
                case .clockAIPreview(let model):
                    ClockAIWidgetView(configuration: model.configuration, metrics: .large, date: entry.date)
                case .carLogo(let model):
                    CarLogoWidgetView(configuration: model.configuration)
                case .aiPhoto(let model):
                    AIPhotoWidgetView(configuration: model.configuration)
                case .photoWithText(let model):
                    PhotoWithTextWidgetView(configuration: model.configuration)
                case .photo(let model):
                    PhotoWidgetView(configuration: model.configuration)
                case .aiPhotoMyCar(let model):
                    AIPhotoMyCarWidgetView(configuration: model.configuration)
                case .photoCarousel(let model):
                    PhotoCarouselSwiftUIView(configuration: model.configuration)
                }
            } else {
                Text("Select preset")
            }
        }
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
        .safePromptsForUserConfiguration()
    }
}

extension WidgetConfiguration {
    func safePromptsForUserConfiguration() -> some WidgetConfiguration {
        if #available(iOS 18.0, *) {
            return self.promptsForUserConfiguration()
        } else {
            return self
        }
    }
}
