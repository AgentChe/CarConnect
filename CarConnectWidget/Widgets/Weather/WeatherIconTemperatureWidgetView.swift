//
//  WeatherIconTemperatureWidgetView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 24.03.2026.
//

import SwiftUI
import WidgetKit

struct WeatherIconTemperatureWidgetView: View {
    enum Metrics {
        case small, large
    }

    private enum Constants {
        static let smallDesignSize = CGSize(width: 165, height: 165)
        static let largeDesignSize = CGSize(width: 330, height: 330)

        static let cornerRadius: CGFloat = 10

        static let horizontalInset: CGFloat = 8

        static let smallPlaceTopInset: CGFloat = 12
        static let largePlaceTopInset: CGFloat = 24

        static let smallPlaceFontSize: CGFloat = 15
        static let largePlaceFontSize: CGFloat = 30

        static let smallIconSize: CGFloat = 52
        static let largeIconSize: CGFloat = 104

        static let smallIconTopSpacing: CGFloat = 16
        static let largeIconTopSpacing: CGFloat = 32

        static let smallTemperatureBottomInset: CGFloat = 12
        static let largeTemperatureBottomInset: CGFloat = 24

        static let smallTemperatureFontSize: CGFloat = 34
        static let largeTemperatureFontSize: CGFloat = 68
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

            VStack(spacing: 0) {
                Text(weatherData.location.name)
                    .font(configuration.font.swiftUIFont(size: placeFontSize(for: metrics) * scale))
                    .foregroundStyle(Color(uiColor: configuration.textColor))
                    .lineLimit(1)
                    .padding(.horizontal, Constants.horizontalInset * scale)
                    .padding(.top, placeTopInset(for: metrics) * scale)

                Image(uiImage: iconImage(for: weatherData.current.condition))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(
                        width: iconSize(for: metrics) * scale,
                        height: iconSize(for: metrics) * scale
                    )
                    .padding(.top, iconTopSpacing(for: metrics) * scale)

                Spacer()

                Text(temperatureText)
                    .font(configuration.font.swiftUIFont(size: temperatureFontSize(for: metrics) * scale))
                    .foregroundStyle(Color(uiColor: configuration.textColor))
                    .lineLimit(1)
                    .padding(.horizontal, Constants.horizontalInset * scale)
                    .padding(.bottom, temperatureBottomInset(for: metrics) * scale)
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
private extension WeatherIconTemperatureWidgetView {
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
    
    func placeTopInset(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallPlaceTopInset
        case .large:
            return Constants.largePlaceTopInset
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
    
    func iconSize(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallIconSize
        case .large:
            return Constants.largeIconSize
        }
    }
    
    func iconTopSpacing(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallIconTopSpacing
        case .large:
            return Constants.largeIconTopSpacing
        }
    }
    
    func temperatureBottomInset(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallTemperatureBottomInset
        case .large:
            return Constants.largeTemperatureBottomInset
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
