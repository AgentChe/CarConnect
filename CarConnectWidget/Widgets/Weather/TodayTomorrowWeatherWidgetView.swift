//
//  TodayTomorrowWeatherWidgetView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 24.03.2026.
//

import SwiftUI
import WidgetKit

struct TodayTomorrowWeatherWidgetView: View {
    enum Metrics {
        case small, large
    }

    private enum Constants {
        static let smallDesignSize = CGSize(width: 165, height: 165)
        static let largeDesignSize = CGSize(width: 330, height: 330)

        static let cornerRadius: CGFloat = 10

        static let smallInset: CGFloat = 12
        static let largeInset: CGFloat = 24

        static let smallTodayFontSize: CGFloat = 16
        static let largeTodayFontSize: CGFloat = 32

        static let smallTodayTemperatureFontSize: CGFloat = 32
        static let largeTodayTemperatureFontSize: CGFloat = 64

        static let smallTodayTemperatureTopSpacing: CGFloat = 2
        static let largeTodayTemperatureTopSpacing: CGFloat = 4

        static let smallKindIconSize: CGFloat = 36
        static let largeKindIconSize: CGFloat = 72

        static let kindIconSpacing: CGFloat = 6

        static let smallTomorrowFontSize: CGFloat = 16
        static let largeTomorrowFontSize: CGFloat = 32
    }

    let configuration: WidgetWeatherConfiguration
    let weatherData: WeatherData
    let metrics: Metrics

    var body: some View {
        GeometryReader { geo in
            let designSize = designSize(for: metrics)
            let scale = min(
                geo.size.width / designSize.width,
                geo.size.height / designSize.height
            )

            let inset = contentInset(for: metrics) * scale

            VStack(spacing: 0) {
                Text("WidgetsPresets.Weather.Today".localized)
                    .font(configuration.font.swiftUIFont(size: todayFontSize(for: metrics) * scale))
                    .foregroundStyle(Color(uiColor: configuration.textColor))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, inset)
                    .padding(.horizontal, inset)

                HStack(spacing: Constants.kindIconSpacing * scale) {
                    Text(todayTemperatureText)
                        .font(configuration.font.swiftUIFont(size: todayTemperatureFontSize(for: metrics) * scale))
                        .foregroundStyle(Color(uiColor: configuration.textColor))
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)

                    Image(uiImage: iconImage(for: weatherData.current.condition))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            width: kindIconSize(for: metrics) * scale,
                            height: kindIconSize(for: metrics) * scale
                        )

                    Spacer(minLength: 0)
                }
                .padding(.top, todayTemperatureTopSpacing(for: metrics) * scale)
                .padding(.horizontal, inset)

                Spacer()

                if let tomorrowTemperatureText {
                    Text(
                        String(
                            format: "WidgetsPresets.Weather.TomorrowTemperature".localized,
                            tomorrowTemperatureText
                        )
                    )
                    .font(configuration.font.swiftUIFont(size: tomorrowFontSize(for: metrics) * scale))
                    .foregroundStyle(Color(uiColor: configuration.textColor))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, inset)
                    .padding(.bottom, inset)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .containerBackground(for: .widget) {
                Image(uiImage: backgroundImage(for: weatherData.current.condition))
                    .resizable()
                    .scaledToFill()
            }
        }
    }
}

// MARK: - Private
private extension TodayTomorrowWeatherWidgetView {
    var todayTemperatureText: String {
        let temperature = weatherData.current.temperature

        switch configuration.temperatureType {
        case .celsius:
            return "\(Int(temperature.celsius.rounded()))°C"
        case .fahrenheit:
            return "\(Int(temperature.fahrenheit.rounded()))°F"
        }
    }

    var tomorrowTemperatureText: String? {
        guard let temperature = weatherData.daily.first?.temperature else { return nil }

        switch configuration.temperatureType {
        case .celsius:
            return "\(Int(temperature.celsius.rounded()))°C"
        case .fahrenheit:
            return "\(Int(temperature.fahrenheit.rounded()))°F"
        }
    }

    func designSize(for metrics: Metrics) -> CGSize {
        switch metrics {
        case .small:
            return Constants.smallDesignSize
        case .large:
            return Constants.largeDesignSize
        }
    }

    func contentInset(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallInset
        case .large:
            return Constants.largeInset
        }
    }

    func todayFontSize(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallTodayFontSize
        case .large:
            return Constants.largeTodayFontSize
        }
    }

    func todayTemperatureFontSize(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallTodayTemperatureFontSize
        case .large:
            return Constants.largeTodayTemperatureFontSize
        }
    }

    func todayTemperatureTopSpacing(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallTodayTemperatureTopSpacing
        case .large:
            return Constants.largeTodayTemperatureTopSpacing
        }
    }

    func kindIconSize(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallKindIconSize
        case .large:
            return Constants.largeKindIconSize
        }
    }

    func tomorrowFontSize(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallTomorrowFontSize
        case .large:
            return Constants.largeTomorrowFontSize
        }
    }

    func iconImage(for kind: WeatherKind) -> UIImage {
        let imageName: String = {
            switch kind {
            case .clearSky:
                return "Weather.Icon.Sunny"
            case .rain, .showerRain, .thunderstorm:
                return "Weather.Icon.Rainy"
            case .snow:
                return "Weather.Icon.Snowy"
            case .fewClouds, .brokenClouds, .scatteredClouds:
                return "Weather.Icon.Cloudy"
            case .mist:
                return "Weather.Icon.Windy"
            }
        }()

        return UIImage(named: imageName) ?? UIImage()
    }

    func backgroundImage(for kind: WeatherKind) -> UIImage {
        let imageName: String = {
            switch kind {
            case .clearSky:
                return "Weather.Background.Sunny"
            case .rain, .showerRain, .thunderstorm:
                return "Weather.Background.Rainy"
            case .snow:
                return "Weather.Background.Snowy"
            case .fewClouds, .brokenClouds, .scatteredClouds:
                return "Weather.Background.Cloudy"
            case .mist:
                return "Weather.Background.Windy"
            }
        }()

        return UIImage(named: imageName) ?? UIImage()
    }
}
