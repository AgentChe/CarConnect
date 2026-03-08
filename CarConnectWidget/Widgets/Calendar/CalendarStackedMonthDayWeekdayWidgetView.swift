//
//  StackedMonthDayWeekdayWidgetView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 08.03.2026.
//

import SwiftUI

struct StackedMonthDayWeekdayWidgetView: View {
    enum Metrics {
        case small
        case large
    }

    private enum Constants {
        static let smallDesignSize = CGSize(width: 158, height: 158)
        static let largeDesignSize = CGSize(width: 338, height: 354)

        static let baseCornerRadius: CGFloat = 10

        static let smallMonthTopInset: CGFloat = 10
        static let largeMonthTopInset: CGFloat = 20

        static let smallContainerTopInset: CGFloat = 39
        static let largeContainerTopInset: CGFloat = 80

        static let smallMonthFontSize: CGFloat = 24
        static let largeMonthFontSize: CGFloat = 48

        static let smallSideDayFontSize: CGFloat = 30
        static let largeSideDayFontSize: CGFloat = 60

        static let smallTodayFontSize: CGFloat = 40
        static let largeTodayFontSize: CGFloat = 80
    }

    let configuration: WidgetCalendarCongifuration
    let metrics: Metrics

    private var calendar: Calendar {
        var calendar = Calendar.current
        calendar.locale = Locale.current
        return calendar
    }

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
            let yesterdayDate = calendar.date(byAdding: .day, value: -1, to: date) ?? date
            let tomorrowDate = calendar.date(byAdding: .day, value: 1, to: date) ?? date

            let monthText = monthFormatter.string(from: date)
            let yesterdayText = dayFormatter.string(from: yesterdayDate)
            let todayText = dayFormatter.string(from: date)
            let weekdayText = weekdayFormatter.string(from: date)
            let tomorrowText = dayFormatter.string(from: tomorrowDate)

            ZStack {
                backgroundView(size: geo.size)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()

                VStack(spacing: 0) {
                    Text(monthText)
                        .font(configuration.font.swiftUIFont(size: monthFontSize() * scale))
                        .foregroundStyle(Color(uiColor: configuration.fontColor))
                        .padding(.top, monthTopInset() * scale)

                    ZStack {
                        VStack(spacing: 0) {
                            Text(yesterdayText)
                                .font(configuration.font.swiftUIFont(size: sideDayFontSize() * scale))
                                .foregroundStyle(Color(uiColor: configuration.fontColor))

                            Text("\(todayText) \(weekdayText)")
                                .font(configuration.font.swiftUIFont(size: todayFontSize() * scale))
                                .foregroundStyle(Color(uiColor: configuration.fontColor))

                            Text(tomorrowText)
                                .font(configuration.font.swiftUIFont(size: sideDayFontSize() * scale))
                                .foregroundStyle(Color(uiColor: configuration.fontColor))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

                        LinearGradient(
                            stops: [
                                .init(color: Color(uiColor: Appearance.color_353844), location: 0),
                                .init(color: Color(uiColor: Appearance.color_343743.withAlphaComponent(0.9)), location: 0.15),
                                .init(color: Color(uiColor: Appearance.color_30343F.withAlphaComponent(0)), location: 0.5),
                                .init(color: Color(uiColor: Appearance.color_2D303A.withAlphaComponent(0.9)), location: 0.85),
                                .init(color: Color(uiColor: Appearance.color_2C2F39), location: 1)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .allowsHitTesting(false)
                    }
                    .padding(.top, (containerTopInset() - monthTopInset()) * scale)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .clipShape(RoundedRectangle(cornerRadius: Constants.baseCornerRadius * scale))
        }
    }
}

// MARK: - Private
private extension StackedMonthDayWeekdayWidgetView {
    func designSizeForMetrics() -> CGSize {
        switch metrics {
        case .small:
            return Constants.smallDesignSize
        case .large:
            return Constants.largeDesignSize
        }
    }

    func monthTopInset() -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallMonthTopInset
        case .large:
            return Constants.largeMonthTopInset
        }
    }

    func containerTopInset() -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallContainerTopInset
        case .large:
            return Constants.largeContainerTopInset
        }
    }

    func monthFontSize() -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallMonthFontSize
        case .large:
            return Constants.largeMonthFontSize
        }
    }

    func sideDayFontSize() -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallSideDayFontSize
        case .large:
            return Constants.largeSideDayFontSize
        }
    }

    func todayFontSize() -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallTodayFontSize
        case .large:
            return Constants.largeTodayFontSize
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
            // Виджет игнорирует Photo Library background
            Color.clear
        }
    }
}
