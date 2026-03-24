//
//  WeatherConditionForecastWidgetView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 24.03.2026.
//

import SwiftUI
import WidgetKit

struct WeatherConditionForecastWidgetView: View {
    enum Metrics {
        case small, large
    }

    private enum Constants {
        static let smallDesignSize = CGSize(width: 165, height: 165)
        static let largeDesignSize = CGSize(width: 330, height: 330)

        static let cornerRadius: CGFloat = 10

        static let smallInset: CGFloat = 12
        static let largeInset: CGFloat = 24

        static let smallTemperatureFontSize: CGFloat = 50
        static let largeTemperatureFontSize: CGFloat = 100

        static let smallKindIconSize: CGFloat = 24
        static let largeKindIconSize: CGFloat = 48

        static let smallKindFontSize: CGFloat = 16
        static let largeKindFontSize: CGFloat = 32

        static let smallKindSpacing: CGFloat = 6
        static let largeKindSpacing: CGFloat = 12

        static let smallDailyHeight: CGFloat = 38
        static let largeDailyHeight: CGFloat = 76
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

            VStack(alignment: .leading, spacing: 0) {
                Text(temperatureText)
                    .font(configuration.font.swiftUIFont(size: temperatureFontSize(for: metrics) * scale))
                    .foregroundStyle(Color(uiColor: configuration.textColor))
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, inset)
                    .padding(.horizontal, inset)

                HStack(spacing: kindSpacing(for: metrics) * scale) {
                    Image(uiImage: iconImage(for: weatherData.current.condition))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            width: kindIconSize(for: metrics) * scale,
                            height: kindIconSize(for: metrics) * scale
                        )

                    Text(kindText)
                        .font(configuration.font.swiftUIFont(size: kindFontSize(for: metrics) * scale))
                        .foregroundStyle(Color(uiColor: configuration.textColor))
                        .lineLimit(1)

                    Spacer(minLength: 0)
                }
                .padding(.horizontal, inset)

                Spacer()

                WeatherFourDaysWidgetView(
                    configuration: configuration,
                    daily: Array(weatherData.daily.prefix(4)),
                    metrics: {
                        switch metrics {
                        case .small:
                            return .small
                        case .large:
                            return .large
                        }
                    }()
                )
                .frame(height: dailyHeight(for: metrics) * scale)
                .padding(.horizontal, inset)
                .padding(.bottom, inset)
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
private extension WeatherConditionForecastWidgetView {
    var temperatureText: String {
        let temperature = weatherData.current.temperature

        switch configuration.temperatureType {
        case .celsius:
            return "\(Int(temperature.celsius.rounded()))°C"
        case .fahrenheit:
            return "\(Int(temperature.fahrenheit.rounded()))°F"
        }
    }

    var kindText: String {
        switch weatherData.current.condition {
        case .sunny:
            return "WeatherCondition.Sunny".localized
        case .rainy:
            return "WeatherCondition.Rainy".localized
        case .snowy:
            return "WeatherCondition.Snowy".localized
        case .cloudy:
            return "WeatherCondition.Cloudy".localized
        case .windy:
            return "WeatherCondition.Windy".localized
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

    func temperatureFontSize(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallTemperatureFontSize
        case .large:
            return Constants.largeTemperatureFontSize
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

    func kindFontSize(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallKindFontSize
        case .large:
            return Constants.largeKindFontSize
        }
    }

    func kindSpacing(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallKindSpacing
        case .large:
            return Constants.largeKindSpacing
        }
    }

    func dailyHeight(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallDailyHeight
        case .large:
            return Constants.largeDailyHeight
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

    func backgroundImage(for kind: WeatherKind) -> UIImage {
        let imageName: String = {
            switch kind {
            case .sunny:
                return "Weather.Background.Sunny"
            case .rainy:
                return "Weather.Background.Rainy"
            case .snowy:
                return "Weather.Background.Snowy"
            case .cloudy:
                return "Weather.Background.Cloudy"
            case .windy:
                return "Weather.Background.Windy"
            }
        }()

        return UIImage(named: imageName) ?? UIImage()
    }
}
