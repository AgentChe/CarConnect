//
//  WeatherClockWidgetView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 24.03.2026.
//

import SwiftUI
import WidgetKit

struct WeatherClockWidgetView: View {
    enum Metrics {
        case small, large
    }

    private enum Constants {
        static let smallDesignSize = CGSize(width: 165, height: 165)
        static let largeDesignSize = CGSize(width: 330, height: 330)

        static let cornerRadius: CGFloat = 10
        static let dateContainerCornerRadius: CGFloat = 8

        static let smallTimeTopInset: CGFloat = 10
        static let largeTimeTopInset: CGFloat = 20

        static let smallTimeFontSize: CGFloat = 32
        static let largeTimeFontSize: CGFloat = 64

        static let smallDateContainerHorizontalInset: CGFloat = 10
        static let largeDateContainerHorizontalInset: CGFloat = 20

        static let smallDateContainerTopSpacing: CGFloat = 16
        static let largeDateContainerTopSpacing: CGFloat = 32

        static let smallDateContainerInsideInset: CGFloat = 11
        static let largeDateContainerInsideInset: CGFloat = 22

        static let smallDateFontSize: CGFloat = 12
        static let largeDateFontSize: CGFloat = 24

        static let smallDateSeparatorHorizontalSpacing: CGFloat = 10
        static let largeDateSeparatorHorizontalSpacing: CGFloat = 20

        static let dateSeparatorWidth: CGFloat = 1

        static let smallDateSeparatorHeight: CGFloat = 7
        static let largeDateSeparatorHeight: CGFloat = 14

        static let smallTemperatureBottomInset: CGFloat = 10
        static let largeTemperatureBottomInset: CGFloat = 20

        static let smallKindIconSize: CGFloat = 36
        static let largeKindIconSize: CGFloat = 72

        static let smallTemperatureFontSize: CGFloat = 32
        static let largeTemperatureFontSize: CGFloat = 64

        static let smallTemperatureSpacing: CGFloat = 10
        static let largeTemperatureSpacing: CGFloat = 20
    }

    let configuration: WidgetWeatherConfiguration
    let weatherData: WeatherData
    let metrics: Metrics

    private let date = Date()

    private let twelveHourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()

    private let twentyFourHourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()

    private let weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()

    var body: some View {
        GeometryReader { geo in
            let designSize = designSize(for: metrics)
            let scale = min(
                geo.size.width / designSize.width,
                geo.size.height / designSize.height
            )

            VStack(spacing: 0) {
                Text(timeText)
                    .font(configuration.font.swiftUIFont(size: timeFontSize(for: metrics) * scale))
                    .foregroundStyle(Color(uiColor: configuration.textColor))
                    .lineLimit(1)
                    .padding(.top, timeTopInset(for: metrics) * scale)

                dateInfoView(scale: scale)
                    .padding(.top, dateContainerTopSpacing(for: metrics) * scale)
                    .padding(.horizontal, dateContainerHorizontalInset(for: metrics) * scale)

                Spacer()

                temperatureView(scale: scale)
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
private extension WeatherClockWidgetView {
    var timeText: String {
        let formatter: DateFormatter = {
            switch configuration.timeFormat {
            case .twelveHour:
                return twelveHourFormatter
            case .twentyFourHour:
                return twentyFourHourFormatter
            }
        }()

        return formatter.string(from: date)
    }

    var dateText: String {
        dateFormatter.string(from: date)
    }

    var weekdayText: String {
        weekdayFormatter.string(from: date)
    }

    var temperatureText: String {
        let temperature = weatherData.current.temperature

        switch configuration.temperatureType {
        case .celsius:
            return "\(Int(temperature.celsius.rounded()))°C"
        case .fahrenheit:
            return "\(Int(temperature.fahrenheit.rounded()))°F"
        }
    }

    @ViewBuilder
    func dateInfoView(scale: CGFloat) -> some View {
        HStack(spacing: 0) {
            Text(dateText)
                .font(configuration.font.swiftUIFont(size: dateFontSize(for: metrics) * scale))
                .foregroundStyle(Color(uiColor: configuration.textColor))
                .lineLimit(1)

            Rectangle()
                .fill(Color(uiColor: configuration.textColor).opacity(0.6))
                .frame(
                    width: Constants.dateSeparatorWidth * scale,
                    height: dateSeparatorHeight(for: metrics) * scale
                )
                .padding(.horizontal, dateSeparatorHorizontalSpacing(for: metrics) * scale)

            Text(weekdayText)
                .font(configuration.font.swiftUIFont(size: dateFontSize(for: metrics) * scale))
                .foregroundStyle(Color(uiColor: configuration.textColor))
                .lineLimit(1)
        }
        .padding(dateContainerInsideInset(for: metrics) * scale)
        .frame(maxWidth: .infinity)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(
                cornerRadius: Constants.dateContainerCornerRadius * scale,
                style: .continuous
            )
        )
    }

    @ViewBuilder
    func temperatureView(scale: CGFloat) -> some View {
        HStack(spacing: temperatureSpacing(for: metrics) * scale) {
            Image(uiImage: iconImage(for: weatherData.current.condition))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(
                    width: kindIconSize(for: metrics) * scale,
                    height: kindIconSize(for: metrics) * scale
                )

            Text(temperatureText)
                .font(configuration.font.swiftUIFont(size: temperatureFontSize(for: metrics) * scale))
                .foregroundStyle(Color(uiColor: configuration.textColor))
                .lineLimit(1)
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

    func timeTopInset(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallTimeTopInset
        case .large:
            return Constants.largeTimeTopInset
        }
    }

    func timeFontSize(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallTimeFontSize
        case .large:
            return Constants.largeTimeFontSize
        }
    }

    func dateContainerHorizontalInset(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallDateContainerHorizontalInset
        case .large:
            return Constants.largeDateContainerHorizontalInset
        }
    }

    func dateContainerTopSpacing(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallDateContainerTopSpacing
        case .large:
            return Constants.largeDateContainerTopSpacing
        }
    }

    func dateContainerInsideInset(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallDateContainerInsideInset
        case .large:
            return Constants.largeDateContainerInsideInset
        }
    }

    func dateFontSize(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallDateFontSize
        case .large:
            return Constants.largeDateFontSize
        }
    }

    func dateSeparatorHorizontalSpacing(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallDateSeparatorHorizontalSpacing
        case .large:
            return Constants.largeDateSeparatorHorizontalSpacing
        }
    }

    func dateSeparatorHeight(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallDateSeparatorHeight
        case .large:
            return Constants.largeDateSeparatorHeight
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

    func kindIconSize(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallKindIconSize
        case .large:
            return Constants.largeKindIconSize
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

    func temperatureSpacing(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallTemperatureSpacing
        case .large:
            return Constants.largeTemperatureSpacing
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
