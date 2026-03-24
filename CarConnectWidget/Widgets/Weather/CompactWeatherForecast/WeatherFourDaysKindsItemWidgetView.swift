//
//  WeatherFourDaysKindsItemWidgetView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 24.03.2026.
//

import SwiftUI

struct WeatherFourDaysKindsItemWidgetView: View {
    enum Metrics {
        case small, large
    }

    private enum Constants {
        static let smallDesignSize = CGSize(width: 20, height: 52)
        static let largeDesignSize = CGSize(width: 40, height: 104)

        static let smallIconSize: CGFloat = 18
        static let largeIconSize: CGFloat = 36

        static let smallTemperatureFontSize: CGFloat = 12
        static let largeTemperatureFontSize: CGFloat = 24

        static let smallDayFontSize: CGFloat = 10
        static let largeDayFontSize: CGFloat = 20
    }

    let configuration: WidgetWeatherConfiguration
    let weather: WeatherSummary
    let metrics: Metrics

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "EEE"
        return formatter
    }

    var body: some View {
        GeometryReader { geo in
            let designSize = designSize(for: metrics)
            let scale = min(
                geo.size.width / designSize.width,
                geo.size.height / designSize.height
            )

            VStack(spacing: 0) {
                Image(uiImage: iconImage(for: weather.condition))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(
                        width: iconSize(for: metrics) * scale,
                        height: iconSize(for: metrics) * scale
                    )

                Spacer()

                Text(temperatureText)
                    .font(configuration.font.swiftUIFont(size: temperatureFontSize(for: metrics) * scale))
                    .foregroundStyle(Color(uiColor: configuration.textColor))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)

                Text(dayText)
                    .font(configuration.font.swiftUIFont(size: dayFontSize(for: metrics) * scale))
                    .foregroundStyle(Color(uiColor: configuration.textColor))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
        }
    }
}

// MARK: - Private
private extension WeatherFourDaysKindsItemWidgetView {
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

    func designSize(for metrics: Metrics) -> CGSize {
        switch metrics {
        case .small:
            return Constants.smallDesignSize
        case .large:
            return Constants.largeDesignSize
        }
    }

    func iconSize(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallIconSize
        case .large:
            return Constants.largeIconSize
        }
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

    func iconImage(for kind: WeatherKind) -> UIImage {
        let imageName: String = {
            switch kind {
            case .sunny:
                return "Weather.Icon.Sunny"
            case .rainy:
                return "Weather.Icon.Rainy"
            case .snowy:
                return "Weather.Icon.Snowy"
            case .cloudy:
                return "Weather.Icon.Cloudy"
            case .windy:
                return "Weather.Icon.Windy"
            }
        }()

        return UIImage(named: imageName) ?? UIImage()
    }
}
