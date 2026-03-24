//
//  LocationTemperatureWidgetView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 24.03.2026.
//

import SwiftUI
import WidgetKit

struct LocationTemperatureWidgetView: View {
    enum Metrics {
        case small, large
    }

    private enum Constants {
        static let smallDesignSize = CGSize(width: 165, height: 165)
        static let largeDesignSize = CGSize(width: 330, height: 330)

        static let cornerRadius: CGFloat = 10

        static let smallHorizontalInset: CGFloat = 12
        static let largeHorizontalInset: CGFloat = 24

        static let smallPlaceTopInset: CGFloat = 15
        static let largePlaceTopInset: CGFloat = 30

        static let smallPlaceFontSize: CGFloat = 22
        static let largePlaceFontSize: CGFloat = 44

        static let smallTemperatureTopSpacing: CGFloat = 24
        static let largeTemperatureTopSpacing: CGFloat = 48

        static let smallTemperatureFontSize: CGFloat = 50
        static let largeTemperatureFontSize: CGFloat = 100
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
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .padding(.horizontal, horizontalInset(for: metrics) * scale)
                    .padding(.top, placeTopInset(for: metrics) * scale)

                Text(temperatureText)
                    .font(configuration.font.swiftUIFont(size: temperatureFontSize(for: metrics) * scale))
                    .foregroundStyle(Color(uiColor: configuration.textColor))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
                    .padding(.top, temperatureTopSpacing(for: metrics) * scale)

                Spacer()
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
            .containerBackground(for: .widget) {
                Image(uiImage: backgroundImage(for: weatherData.current.condition))
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            }
        }
    }
}

// MARK: - Private
private extension LocationTemperatureWidgetView {
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

    func horizontalInset(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallHorizontalInset
        case .large:
            return Constants.largeHorizontalInset
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

    func temperatureTopSpacing(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallTemperatureTopSpacing
        case .large:
            return Constants.largeTemperatureTopSpacing
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
