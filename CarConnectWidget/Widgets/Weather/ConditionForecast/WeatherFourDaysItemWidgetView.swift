//
//  WeatherFourDaysItemWidgetView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 24.03.2026.
//

//
//  WeatherFourDaysItemWidgetView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 24.03.2026.
//

import SwiftUI

struct WeatherFourDaysItemWidgetView: View {
    enum Metrics {
        case small, large
    }

    private enum Constants {
        static let smallTemperatureFontSize: CGFloat = 15
        static let largeTemperatureFontSize: CGFloat = 30

        static let smallDayFontSize: CGFloat = 12
        static let largeDayFontSize: CGFloat = 24
    }

    let configuration: WidgetWeatherConfiguration
    let weather: WeatherSummary
    let metrics: Metrics

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "EEE"
        return formatter
    }()

    var body: some View {
        GeometryReader { geo in
            let designHeight: CGFloat = {
                switch metrics {
                case .small:
                    return 38
                case .large:
                    return 76
                }
            }()

            let scale = geo.size.height / designHeight

            VStack(spacing: 0) {
                Text(temperatureText)
                    .font(configuration.font.swiftUIFont(size: temperatureFontSize(for: metrics) * scale))
                    .foregroundStyle(Color(uiColor: configuration.textColor))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .center)

                Spacer(minLength: 0)

                Text(dayText)
                    .font(configuration.font.swiftUIFont(size: dayFontSize(for: metrics) * scale))
                    .foregroundStyle(Color(uiColor: configuration.textColor))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: - Private
private extension WeatherFourDaysItemWidgetView {
    var temperatureText: String {
        let temperature = weather.temperature

        switch configuration.temperatureType {
        case .celsius:
            return "\(Int(temperature.celsius.rounded()))"
        case .fahrenheit:
            return "\(Int(temperature.fahrenheit.rounded()))"
        }
    }

    var dayText: String {
        dateFormatter.string(from: weather.date)
    }

    func temperatureFontSize(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallTemperatureFontSize
        case .large:
            return Constants.largeTemperatureFontSize
        }
    }

    func dayFontSize(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallDayFontSize
        case .large:
            return Constants.largeDayFontSize
        }
    }
}
