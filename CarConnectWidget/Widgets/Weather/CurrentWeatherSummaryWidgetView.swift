//
//  CurrentWeatherSummaryWidgetView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 24.03.2026.
//

import SwiftUI
import WidgetKit

struct CurrentWeatherSummaryWidgetView: View {
    enum Metrics {
        case small, large
    }

    private enum Constants {
        static let smallDesignSize = CGSize(width: 165, height: 165)
        static let largeDesignSize = CGSize(width: 330, height: 330)

        static let cornerRadius: CGFloat = 10

        static let smallInset: CGFloat = 12
        static let largeInset: CGFloat = 24

        static let smallTextSize: CGFloat = 20
        static let largeTextSize: CGFloat = 40

        static let smallVerticalSpacing: CGFloat = 4
        static let largeVerticalSpacing: CGFloat = 8

        static let smallIconSize: CGFloat = 24
        static let largeIconSize: CGFloat = 48

        static let smallKindLeading: CGFloat = 46
        static let largeKindLeading: CGFloat = 92
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
            let textSize = textFontSize(for: metrics) * scale
            let verticalSpacing = verticalSpacing(for: metrics) * scale
            let iconSize = kindIconSize(for: metrics) * scale
            let kindLeading = kindLabelLeading(for: metrics) * scale

            VStack(spacing: 0) {
                nowInText(fontSize: textSize)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, inset)
                    .padding(.horizontal, inset)

                placeText(fontSize: textSize)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, verticalSpacing)
                    .padding(.horizontal, inset)

                feelsText(fontSize: textSize)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, verticalSpacing)
                    .padding(.horizontal, inset)

                Spacer()

                ZStack(alignment: .leading) {
                    kindNameText(fontSize: textSize)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, kindLeading)
                        .padding(.trailing, inset)

                    Image(uiImage: iconImage(for: weatherData.current.condition))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: iconSize, height: iconSize)
                        .padding(.leading, inset)
                }
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
private extension CurrentWeatherSummaryWidgetView {
    var currentTemperatureText: String {
        let temperature = weatherData.current.temperature

        switch configuration.temperatureType {
        case .celsius:
            return "\(Int(temperature.celsius.rounded()))°C"
        case .fahrenheit:
            return "\(Int(temperature.fahrenheit.rounded()))°F"
        }
    }

    var feelsLikeTemperatureText: String {
        let temperature = weatherData.current.feelsLike

        switch configuration.temperatureType {
        case .celsius:
            return "\(Int(temperature.celsius.rounded()))°C"
        case .fahrenheit:
            return "\(Int(temperature.fahrenheit.rounded()))°F"
        }
    }

    var localizedConditionText: String {
        switch weatherData.current.condition {
        case .clearSky:
            return "WeatherCondition.Sunny".localized
        case .rain, .showerRain, .thunderstorm:
            return "WeatherCondition.Rainy".localized
        case .snow:
            return "WeatherCondition.Snowy".localized
        case .fewClouds, .brokenClouds, .scatteredClouds:
            return "WeatherCondition.Cloudy".localized
        case .mist:
            return "WeatherCondition.Windy".localized
        }
    }

    func nowInText(fontSize: CGFloat) -> Text {
        Text(currentTemperatureText)
            .font(configuration.font.swiftUIFont(size: fontSize))
            .foregroundColor(Color(uiColor: configuration.textColor))
        +
        Text("WidgetsPresets.Weather.NowIn".localized)
            .font(configuration.font.swiftUIFont(size: fontSize))
            .foregroundColor(Color(uiColor: configuration.textColor.withAlphaComponent(0.6)))
    }

    func placeText(fontSize: CGFloat) -> some View {
        Text(weatherData.location.name)
            .font(configuration.font.swiftUIFont(size: fontSize))
            .foregroundColor(Color(uiColor: configuration.textColor))
            .lineLimit(1)
            .truncationMode(.tail)
    }

    func feelsText(fontSize: CGFloat) -> Text {
        Text("WidgetsPresets.Weather.Feels".localized)
            .font(configuration.font.swiftUIFont(size: fontSize))
            .foregroundColor(Color(uiColor: configuration.textColor.withAlphaComponent(0.6)))
        +
        Text(feelsLikeTemperatureText)
            .font(configuration.font.swiftUIFont(size: fontSize))
            .foregroundColor(Color(uiColor: configuration.textColor))
    }

    func kindNameText(fontSize: CGFloat) -> some View {
        Text(localizedConditionText)
            .font(configuration.font.swiftUIFont(size: fontSize))
            .foregroundColor(Color(uiColor: configuration.textColor))
            .lineLimit(1)
            .truncationMode(.tail)
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

    func textFontSize(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallTextSize
        case .large:
            return Constants.largeTextSize
        }
    }

    func verticalSpacing(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallVerticalSpacing
        case .large:
            return Constants.largeVerticalSpacing
        }
    }

    func kindIconSize(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallIconSize
        case .large:
            return Constants.largeIconSize
        }
    }

    func kindLabelLeading(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallKindLeading
        case .large:
            return Constants.largeKindLeading
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
