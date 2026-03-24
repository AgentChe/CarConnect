//
//  CompactWeatherForecastWidgetView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 24.03.2026.
//

import SwiftUI
import WidgetKit

struct CompactWeatherForecastWidgetView: View {
    enum Metrics {
        case small, large
    }

    private enum Constants {
        static let smallDesignSize = CGSize(width: 165, height: 165)
        static let largeDesignSize = CGSize(width: 330, height: 330)

        static let cornerRadius: CGFloat = 10

        static let smallInset: CGFloat = 12
        static let largeInset: CGFloat = 24

        static let smallPlaceFontSize: CGFloat = 15
        static let largePlaceFontSize: CGFloat = 30

        static let smallTemperatureFontSize: CGFloat = 32
        static let largeTemperatureFontSize: CGFloat = 64

        static let smallTemperatureTopSpacing: CGFloat = 3
        static let largeTemperatureTopSpacing: CGFloat = 6

        static let smallKindIconSize: CGFloat = 44
        static let largeKindIconSize: CGFloat = 88

        static let smallDailyHeight: CGFloat = 52
        static let largeDailyHeight: CGFloat = 104
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
            let kindIconSize = kindIconSize(for: metrics) * scale
            let dailyHeight = dailyHeight(for: metrics) * scale

            VStack(spacing: 0) {
                Text(weatherData.location.name)
                    .font(configuration.font.swiftUIFont(size: placeFontSize(for: metrics) * scale))
                    .foregroundStyle(Color(uiColor: configuration.textColor))
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, inset)
                    .padding(.horizontal, inset)

                ZStack(alignment: .trailing) {
                    Text(temperatureText)
                        .font(configuration.font.swiftUIFont(size: temperatureFontSize(for: metrics) * scale))
                        .foregroundStyle(Color(uiColor: configuration.textColor))
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Image(uiImage: iconImage(for: weatherData.current.condition))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: kindIconSize, height: kindIconSize)
                }
                .padding(.top, temperatureTopSpacing(for: metrics) * scale)
                .padding(.horizontal, inset)

                Spacer()

                WeatherFourDaysKindsWidgetView(
                    configuration: configuration,
                    daily: Array(weatherData.daily.prefix(4)),
                    metrics: dailyMetrics(for: metrics)
                )
                .frame(height: dailyHeight)
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
private extension CompactWeatherForecastWidgetView {
    var temperatureText: String {
        let temperature = weatherData.current.temperature
        
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
    
    func placeFontSize(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallPlaceFontSize
        case .large:
            return Constants.largePlaceFontSize
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
    
    func temperatureTopSpacing(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallTemperatureTopSpacing
        case .large:
            return Constants.largeTemperatureTopSpacing
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
    
    func dailyHeight(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallDailyHeight
        case .large:
            return Constants.largeDailyHeight
        }
    }
    
    func dailyMetrics(for metrics: Metrics) -> WeatherFourDaysKindsWidgetView.Metrics {
        switch metrics {
        case .small:
            return .small
        case .large:
            return .large
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
