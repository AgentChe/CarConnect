//
//  WeatherFourDaysKindsWidgetView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 24.03.2026.
//

import SwiftUI

struct WeatherFourDaysKindsWidgetView: View {
    enum Metrics {
        case small, large
    }

    private enum Constants {
        static let spacing: CGFloat = 10

        static let smallDesignHeight: CGFloat = 52
        static let largeDesignHeight: CGFloat = 104
    }

    let configuration: WidgetWeatherConfiguration
    let daily: [WeatherSummary]
    let metrics: Metrics

    var body: some View {
        GeometryReader { geo in
            let designHeight = designHeight(for: metrics)
            let scale = geo.size.height / designHeight
            let items = Array(daily.prefix(4))

            HStack(spacing: Constants.spacing * scale) {
                ForEach(Array(items.enumerated()), id: \.offset) { _, weather in
                    WeatherFourDaysKindsItemWidgetView(
                        configuration: configuration,
                        weather: weather,
                        metrics: itemMetrics(for: metrics)
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                if items.count < 4 {
                    ForEach(0..<(4 - items.count), id: \.self) { _ in
                        Color.clear
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

// MARK: - Private
private extension WeatherFourDaysKindsWidgetView {
    func designHeight(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallDesignHeight
        case .large:
            return Constants.largeDesignHeight
        }
    }
    
    func itemMetrics(for metrics: Metrics) -> WeatherFourDaysKindsItemWidgetView.Metrics {
        switch metrics {
        case .small:
            return .small
        case .large:
            return .large
        }
    }
}
