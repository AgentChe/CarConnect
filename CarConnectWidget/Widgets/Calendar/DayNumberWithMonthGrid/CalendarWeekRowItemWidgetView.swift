//
//  CalendarWeekRowItemWidgetView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 08.03.2026.
//

import SwiftUI

struct CalendarWeekRowItemWidgetView: View {
    private enum Constants {
        static let smallHighlightSize: CGFloat = 24
        static let largeHighlightSize: CGFloat = 50

        static let smallCornerRadius: CGFloat = 12
        static let largeCornerRadius: CGFloat = 25

        static let smallFontSize: CGFloat = 16
        static let largeFontSize: CGFloat = 33
    }

    let metrics: DayNumberWithMonthGridWidgetView.Metrics
    let item: CalendarWeekRowWidgetView.Item
    let configuration: WidgetCalendarCongifuration

    var body: some View {
        GeometryReader { geo in
            let scale = currentScale(size: geo.size)

            let highlightSize: CGFloat = {
                switch metrics {
                case .small: return Constants.smallHighlightSize * scale
                case .large: return Constants.largeHighlightSize * scale
                }
            }()

            let cornerRadius: CGFloat = {
                switch metrics {
                case .small: return Constants.smallCornerRadius * scale
                case .large: return Constants.largeCornerRadius * scale
                }
            }()

            let fontSize: CGFloat = {
                switch metrics {
                case .small: return Constants.smallFontSize * scale
                case .large: return Constants.largeFontSize * scale
                }
            }()

            VStack(spacing: 0) {
                ZStack {
                    if item.isHighlight {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color(uiColor: Appearance.color_FFFFFF))
                            .frame(width: highlightSize, height: highlightSize)
                    }

                    Text(item.day)
                        .font(configuration.font.swiftUIFont(size: fontSize))
                        .foregroundStyle(
                            Color(
                                uiColor: item.isHighlight
                                ? Appearance.color_FF4539
                                : configuration.fontColor
                            )
                        )
                }

                Spacer()

                Text(item.weekday)
                    .font(configuration.font.swiftUIFont(size: fontSize))
                    .foregroundStyle(Color(uiColor: configuration.fontColor.withAlphaComponent(0.6)))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private func currentScale(size: CGSize) -> CGFloat {
        switch metrics {
        case .small:
            return min(size.width / 24, size.height / 46)
        case .large:
            return min(size.width / 50, size.height / 96)
        }
    }
}
