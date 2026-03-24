//
//  DigitalWeatherClockWidgetView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 24.03.2026.
//

//
//  DigitalWeatherClockWidgetView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 24.03.2026.
//

import SwiftUI
import UIKit
import WidgetKit

struct DigitalWeatherClockWidgetView: View {
    enum Metrics {
        case small, large
    }

    private enum Constants {
        static let smallDesignSize = CGSize(width: 165, height: 165)
        static let largeDesignSize = CGSize(width: 330, height: 330)

        static let cornerRadius: CGFloat = 10
        static let timeContainerCornerRadius: CGFloat = 8

        static let smallContentInset: CGFloat = 12
        static let largeContentInset: CGFloat = 12

        static let smallTodayFontSize: CGFloat = 28
        static let largeTodayFontSize: CGFloat = 56

        static let smallTemperatureFontSize: CGFloat = 40
        static let largeTemperatureFontSize: CGFloat = 80

        static let smallTemperatureTopSpacing: CGFloat = 2
        static let largeTemperatureTopSpacing: CGFloat = 2

        static let smallTimeContainerTopSpacing: CGFloat = 5
        static let largeTimeContainerTopSpacing: CGFloat = 5

        static let smallTimeFontSize: CGFloat = 28
        static let largeTimeFontSize: CGFloat = 56

        static let smallTimeInset: CGFloat = 10
        static let largeTimeInset: CGFloat = 10

        static let timeContainerBorderWidth: CGFloat = 1
        static let timeContainerOpacity: CGFloat = 0.12
    }

    let configuration: WidgetWeatherConfiguration
    let weatherData: WeatherData
    let metrics: Metrics
    let date: Date

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

    var body: some View {
        GeometryReader { geo in
            let designSize = designSize(for: metrics)
            let scale = min(
                geo.size.width / designSize.width,
                geo.size.height / designSize.height
            )

            let contentInset = self.contentInset(for: metrics) * scale
            let timeInset = self.timeInset(for: metrics) * scale

            VStack(alignment: .leading, spacing: 0) {
                Text("WidgetsPresets.Weather.Today".localized)
                    .font(configuration.font.swiftUIFont(size: todayFontSize(for: metrics) * scale))
                    .foregroundStyle(Color(uiColor: configuration.textColor))
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, contentInset)
                    .padding(.horizontal, contentInset)

                Text(temperatureText)
                    .font(configuration.font.swiftUIFont(size: temperatureFontSize(for: metrics) * scale))
                    .foregroundStyle(Color(uiColor: configuration.textColor))
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, temperatureTopSpacing(for: metrics) * scale)
                    .padding(.horizontal, contentInset)

                Text(timeText)
                    .font(configuration.font.swiftUIFont(size: timeFontSize(for: metrics) * scale))
                    .foregroundStyle(Color(uiColor: configuration.textColor))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, timeInset)
                    .padding(.vertical, timeInset)
                    .background(
                        RoundedRectangle(
                            cornerRadius: Constants.timeContainerCornerRadius * scale,
                            style: .continuous
                        )
                        .fill(Color.white.opacity(Constants.timeContainerOpacity))
                    )
                    .overlay(
                        RoundedRectangle(
                            cornerRadius: Constants.timeContainerCornerRadius * scale,
                            style: .continuous
                        )
                        .stroke(
                            Color.white,
                            lineWidth: Constants.timeContainerBorderWidth * scale
                        )
                    )
                    .padding(.top, timeContainerTopSpacing(for: metrics) * scale)
                    .padding(.horizontal, contentInset)

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .containerBackground(for: .widget) {
                Color(uiColor: backgroundColor(celsius: weatherData.current.temperature.celsius))
            }
        }
    }
}

// MARK: - Private
private extension DigitalWeatherClockWidgetView {
    var temperatureText: String {
        let temperature = weatherData.current.temperature

        switch configuration.temperatureType {
        case .celsius:
            return "\(Int(temperature.celsius.rounded()))°C"
        case .fahrenheit:
            return "\(Int(temperature.fahrenheit.rounded()))°F"
        }
    }

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
            return Constants.smallContentInset
        case .large:
            return Constants.largeContentInset
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

    func timeContainerTopSpacing(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallTimeContainerTopSpacing
        case .large:
            return Constants.largeTimeContainerTopSpacing
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

    func timeInset(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallTimeInset
        case .large:
            return Constants.largeTimeInset
        }
    }

    func backgroundColor(celsius: Double) -> UIColor {
        let points: [(temp: Double, color: UIColor)] = [
            (-30, UIColor(hex: "#1E3A8A")),
            (-10, UIColor(hex: "#3B82F6")),
            (0, UIColor(hex: "#7DD3FC")),
            (10, UIColor(hex: "#CFEF9D")),
            (20, UIColor(hex: "#FFD166")),
            (27, UIColor(hex: "#FF7B1A")),
            (35, UIColor(hex: "#FF5A36"))
        ]

        if celsius <= points[0].temp { return points[0].color }
        if celsius >= points[points.count - 1].temp { return points[points.count - 1].color }

        for i in 0..<(points.count - 1) {
            let left = points[i]
            let right = points[i + 1]

            if celsius >= left.temp && celsius <= right.temp {
                let progress = (celsius - left.temp) / (right.temp - left.temp)
                return UIColor.interpolate(from: left.color, to: right.color, progress: progress)
            }
        }

        return UIColor(hex: "#FF7B1A")
    }
}

// MARK: - Additional
private extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = (
                (int >> 16) & 0xFF,
                (int >> 8) & 0xFF,
                int & 0xFF
            )
        default:
            (r, g, b) = (0, 0, 0)
        }

        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: 1
        )
    }

    static func interpolate(from: UIColor, to: UIColor, progress: Double) -> UIColor {
        let p = max(0, min(1, progress))

        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var a1: CGFloat = 0

        var r2: CGFloat = 0
        var g2: CGFloat = 0
        var b2: CGFloat = 0
        var a2: CGFloat = 0

        from.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        to.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        return UIColor(
            red: r1 + (r2 - r1) * CGFloat(p),
            green: g1 + (g2 - g1) * CGFloat(p),
            blue: b1 + (b2 - b1) * CGFloat(p),
            alpha: a1 + (a2 - a1) * CGFloat(p)
        )
    }
}
