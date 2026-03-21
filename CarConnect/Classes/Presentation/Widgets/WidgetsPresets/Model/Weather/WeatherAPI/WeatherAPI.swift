//
//  WeatherAPI.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 17.03.2026.
//

import CoreLocation
import WeatherKit

struct WeatherData: Sendable {
    let location: Location
    let current: WeatherSummary
    let daily: [WeatherSummary]   // 4 next days
}

struct WeatherSummary: Sendable {
    let date: Date
    let temperature: Temperature
    let feelsLike: Temperature
    let condition: WeatherKind
    let symbolName: String
}

enum WeatherKind: String, Sendable {
    case sunny
    case rainy
    case snowy
    case cloudy
    case windy
}

enum WeatherManagerError: LocalizedError {
    case noDailyForecast
    case noHourlyForecastForRequestedDays
}

final class WeatherAPI {
    private lazy var service = WeatherService.shared
    private lazy var calendar = Calendar.current
    
    func fetchWeather(location: Location) async throws -> WeatherData {
        let coordinate = CLLocation(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        
        async let currentTask = service.weather(for: coordinate, including: .current)
        async let dailyTask = service.weather(for: coordinate, including: .daily)
        async let hourlyTask = service.weather(for: coordinate, including: .hourly)
        
        let currentWeather = try await currentTask
        let dailyForecast = try await dailyTask
        let hourlyForecast = try await hourlyTask
        
        let targetDays = Array(dailyForecast.forecast.dropFirst().prefix(4))
        guard !targetDays.isEmpty else {
            throw WeatherManagerError.noDailyForecast
        }
        
        let temperature: Temperature = {
            Temperature(
                celsius: currentWeather.temperature.converted(to: .celsius).value,
                fahrenheit: currentWeather.temperature.converted(to: .fahrenheit).value
            )
        }()
        
        let feelsLike: Temperature = {
            Temperature(
                celsius: currentWeather.apparentTemperature.converted(to: .celsius).value,
                fahrenheit: currentWeather.apparentTemperature.converted(to: .fahrenheit).value
            )
        }()
        
        let current = WeatherSummary(
            date: currentWeather.date,
            temperature: temperature,
            feelsLike: feelsLike,
            condition: mapCondition(currentWeather.condition),
            symbolName: currentWeather.symbolName
        )
        
        let daily = try buildDailySummaries(
            days: targetDays,
            hourlyForecast: Array(hourlyForecast.forecast)
        )
        
        return WeatherData(
            location: location,
            current: current,
            daily: daily
        )
    }
}

// MARK: Private
private extension WeatherAPI {
    func buildDailySummaries(
        days: [DayWeather],
        hourlyForecast: [HourWeather]
    ) throws -> [WeatherSummary] {
        guard !hourlyForecast.isEmpty else {
            throw WeatherManagerError.noHourlyForecastForRequestedDays
        }
        
        return days.map { day in
            let noonDate = noon(for: day.date)
            let nearestHour = nearestHourWeather(to: noonDate, in: hourlyForecast)
            
            let temperature: Temperature = {
                Temperature(
                    celsius: day.highTemperature.converted(to: .celsius).value,
                    fahrenheit: day.highTemperature.converted(to: .fahrenheit).value
                )
            }()
            
            let feelsLike: Temperature = {
                Temperature(
                    celsius: nearestHour?.apparentTemperature.converted(to: .celsius).value ?? 0,
                    fahrenheit: nearestHour?.apparentTemperature.converted(to: .fahrenheit).value ?? 0
                )
            }()
            
            return WeatherSummary(
                date: day.date,
                temperature: temperature,
                feelsLike: feelsLike,
                condition: mapCondition(day.condition),
                symbolName: day.symbolName
            )
        }
    }
    
    func noon(for date: Date) -> Date {
        let startOfDay = calendar.startOfDay(for: date)
        return calendar.date(byAdding: .hour, value: 12, to: startOfDay) ?? date
    }
    
    func nearestHourWeather(to targetDate: Date, in items: [HourWeather]) -> HourWeather? {
        items.min {
            abs($0.date.timeIntervalSince(targetDate)) < abs($1.date.timeIntervalSince(targetDate))
        }
    }
    
    func mapCondition(_ condition: WeatherCondition) -> WeatherKind {
        switch condition {
        case .clear, .mostlyClear, .hot:
            return .sunny
        case .cloudy, .mostlyCloudy, .partlyCloudy, .foggy, .haze, .smoky:
            return .cloudy
        case .drizzle,
             .rain,
             .heavyRain,
             .isolatedThunderstorms,
             .scatteredThunderstorms,
             .strongStorms,
             .thunderstorms,
             .hail:
            return .rainy
        case .snow,
             .heavySnow,
             .flurries,
             .sleet,
             .freezingDrizzle,
             .freezingRain,
             .wintryMix,
             .blizzard,
             .blowingSnow:
            return .snowy
        case .windy:
            return .windy
        default:
            return .cloudy
        }
    }
}
