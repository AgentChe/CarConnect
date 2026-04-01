//
//  CalendarClockWidgetView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 26.03.2026.
//

import SwiftUI
import WidgetKit

struct CalendarClockWidgetView: View {
    enum Metrics {
        case small, large
    }

    private enum Constants {
        static let smallDesignSize = CGSize(width: 165, height: 165)
        static let largeDesignSize = CGSize(width: 343, height: 343)

        static let smallInset: CGFloat = 10
        static let largeInset: CGFloat = 20

        static let smallTimeFontSize: CGFloat = 36
        static let largeTimeFontSize: CGFloat = 72

        static let smallTimeVerticalInset: CGFloat = 15
        static let largeTimeVerticalInset: CGFloat = 30

        static let smallDateHeight: CGFloat = 56
        static let largeDateHeight: CGFloat = 112

        static let smallDayFontSize: CGFloat = 30
        static let largeDayFontSize: CGFloat = 60

        static let smallWeekdayFontSize: CGFloat = 30
        static let largeWeekdayFontSize: CGFloat = 60

        static let smallWeekdayLeading: CGFloat = 14
        static let largeWeekdayLeading: CGFloat = 28
    }

    let configuration: WidgetClockConfiguration
    let metrics: Metrics
    let date: Date

    var body: some View {
        GeometryReader { geo in
            let designSize = designSize(for: metrics)
            let scale = min(
                geo.size.width / designSize.width,
                geo.size.height / designSize.height
            )

            let inset = contentInset(for: metrics) * scale
            let timeFontSize = timeFontSize(for: metrics) * scale
            let timeVerticalInset = timeVerticalInset(for: metrics) * scale
            let dateHeight = dateHeight(for: metrics) * scale
            let daySize = dateHeight
            let dayFontSize = dayFontSize(for: metrics) * scale
            let weekdayFontSize = weekdayFontSize(for: metrics) * scale
            let weekdayLeading = weekdayLeading(for: metrics) * scale

            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 10 * scale, style: .continuous)
                    .fill(Color(uiColor: Appearance.color_FFFFFF.withAlphaComponent(0.08)))
                    .overlay {
                        Text(timeText)
                            .font(configuration.font.swiftUIFont(size: timeFontSize))
                            .foregroundStyle(Color(uiColor: configuration.textColor.wrappedValue))
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                            .padding(.vertical, timeVerticalInset)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, inset)
                    .padding(.top, inset)

                Spacer()

                HStack(spacing: 0) {
                    Circle()
                        .fill(Color(uiColor: Appearance.color_D71921))
                        .frame(width: daySize, height: daySize)
                        .overlay {
                            Text(dayText)
                                .font(configuration.font.swiftUIFont(size: dayFontSize))
                                .foregroundStyle(Color(uiColor: configuration.textColor.wrappedValue))
                                .lineLimit(1)
                        }

                    Text(weekdayText)
                        .font(configuration.font.swiftUIFont(size: weekdayFontSize))
                        .foregroundStyle(Color(uiColor: configuration.textColor.wrappedValue))
                        .lineLimit(1)
                        .padding(.leading, weekdayLeading)
                }
                .frame(height: dateHeight)
                .padding(.bottom, inset)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .containerBackground(for: .widget) {
                backgroundView(size: geo.size)
            }
        }
    }
}

// MARK: - Private
private extension CalendarClockWidgetView {
    static let time24Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    static let time12Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        return formatter
    }()

    static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }()

    static let weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()

    var timeText: String {
        let formatter: DateFormatter = {
            switch configuration.timeFormat {
            case .twelveHour:
                return Self.time12Formatter
            case .twentyFourHour:
                return Self.time24Formatter
            }
        }()
        return formatter.string(from: date)
    }

    var dayText: String {
        Self.dayFormatter.string(from: date)
    }

    var weekdayText: String {
        Self.weekdayFormatter.string(from: date)
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

    func timeFontSize(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallTimeFontSize
        case .large:
            return Constants.largeTimeFontSize
        }
    }

    func timeVerticalInset(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallTimeVerticalInset
        case .large:
            return Constants.largeTimeVerticalInset
        }
    }

    func dateHeight(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallDateHeight
        case .large:
            return Constants.largeDateHeight
        }
    }

    func dayFontSize(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallDayFontSize
        case .large:
            return Constants.largeDayFontSize
        }
    }

    func weekdayFontSize(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallWeekdayFontSize
        case .large:
            return Constants.largeWeekdayFontSize
        }
    }

    func weekdayLeading(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallWeekdayLeading
        case .large:
            return Constants.largeWeekdayLeading
        }
    }
}
