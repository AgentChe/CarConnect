//
//  WeatherFourDaysWidgetView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 24.03.2026.
//

//
//  WeatherFourDaysWidgetView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 24.03.2026.
//

import SwiftUI

struct WeatherFourDaysWidgetView: View {
    enum Metrics {
        case small, large
    }

    private enum Constants {
        static let spacing: CGFloat = 10
    }

    let configuration: WidgetWeatherConfiguration
    let daily: [WeatherSummary]
    let metrics: Metrics

    var body: some View {
        GeometryReader { geo in
            let totalSpacing = Constants.spacing * 3
            let itemWidth = max(0, (geo.size.width - totalSpacing) / 4)

            HStack(spacing: Constants.spacing) {
                ForEach(0..<4, id: \.self) { index in
                    if let weather = weather(at: index) {
                        WeatherFourDaysItemWidgetView(
                            configuration: configuration,
                            weather: weather,
                            metrics: {
                                switch metrics {
                                case .small:
                                    return .small
                                case .large:
                                    return .large
                                }
                            }()
                        )
                        .frame(width: itemWidth, height: geo.size.height)
                    } else {
                        Color.clear
                            .frame(width: itemWidth, height: geo.size.height)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Private
private extension WeatherFourDaysWidgetView {
    func weather(at index: Int) -> WeatherSummary? {
        guard daily.indices.contains(index) else { return nil }
        return daily[index]
    }
}
