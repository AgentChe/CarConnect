//
//  MonthAbbrevAndDayNumberWidgetView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 08.03.2026.
//

import SwiftUI

struct CalendarMonthAbbrevAndDayNumberLargeWidgetView: View {
    enum Metrics {
        case small
        case large
    }

    private enum Constants {
        static let smallDesignSize = CGSize(width: 158, height: 158)
        static let largeDesignSize = CGSize(width: 338, height: 354)

        static let baseCornerRadius: CGFloat = 10

        static let smallWeekdayMonthFontSize: CGFloat = 28
        static let largeWeekdayMonthFontSize: CGFloat = 56

        static let smallDayFontSize: CGFloat = 70
        static let largeDayFontSize: CGFloat = 140
    }

    let configuration: WidgetCalendarCongifuration
    let metrics: Metrics

    private var weekdayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "EEE"
        return formatter
    }

    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "MMM"
        return formatter
    }

    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "d"
        return formatter
    }

    var body: some View {
        GeometryReader { geo in
            let designSize = designSizeForMetrics()
            let scale = min(
                geo.size.width / designSize.width,
                geo.size.height / designSize.height
            )

            let date = Date()
            let weekdayText = weekdayFormatter.string(from: date)
            let monthText = monthFormatter.string(from: date)
            let dayText = dayFormatter.string(from: date)

            ZStack {
                backgroundView(size: geo.size)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()

                VStack(spacing: 0) {
                    (
                        Text(weekdayText)
                            .foregroundStyle(Color(uiColor: configuration.fontColor))
                        +
                        Text(" ")
                            .foregroundStyle(Color(uiColor: configuration.fontColor))
                        +
                        Text(monthText)
                            .foregroundStyle(Color(uiColor: configuration.fontColor.withAlphaComponent(0.6)))
                    )
                    .font(configuration.font.swiftUIFont(size: weekdayMonthFontSizeForMetrics() * scale))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                    Text(dayText)
                        .font(configuration.font.swiftUIFont(size: dayFontSizeForMetrics() * scale))
                        .foregroundStyle(Color(uiColor: configuration.fontColor))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                .frame(maxWidth: .infinity)
                .position(
                    x: geo.size.width / 2,
                    y: geo.size.height / 2
                )
            }
            .clipShape(RoundedRectangle(cornerRadius: Constants.baseCornerRadius * scale))
        }
    }
}

// MARK: - Private
private extension CalendarMonthAbbrevAndDayNumberLargeWidgetView {
    func designSizeForMetrics() -> CGSize {
        switch metrics {
        case .small:
            return Constants.smallDesignSize
        case .large:
            return Constants.largeDesignSize
        }
    }

    func weekdayMonthFontSizeForMetrics() -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallWeekdayMonthFontSize
        case .large:
            return Constants.largeWeekdayMonthFontSize
        }
    }

    func dayFontSizeForMetrics() -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallDayFontSize
        case .large:
            return Constants.largeDayFontSize
        }
    }

    @ViewBuilder
    func backgroundView(size: CGSize) -> some View {
        switch configuration.background {
        case .color(let codableColor):
            Color(uiColor: codableColor.wrappedValue)

        case .gradient(let codableColors):
            LinearGradient(
                colors: codableColors.map { Color(uiColor: $0.wrappedValue) },
                startPoint: .top,
                endPoint: .bottom
            )

        case .fileName(let fileName):
            if let image = SharedImageFileStore.shared.loadDownsampledImage(
                fileName: fileName,
                size: size,
                scale: UIScreen.main.scale
            ) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipped()
            } else {
                Color.clear
            }

        case .photoAssetId:
            // Widget ignores Photo Library background
            Color.clear
        }
    }
}
