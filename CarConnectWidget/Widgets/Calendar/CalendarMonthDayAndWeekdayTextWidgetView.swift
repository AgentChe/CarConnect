//
//  CalendarMonthDayAndWeekdayTextWidgetView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 08.03.2026.
//

import SwiftUI

struct CalendarMonthDayAndWeekdayTextWidgetView: View {
    enum Metrics {
        case small
        case large
    }

    private enum Constants {
        static let smallDesignSize = CGSize(width: 158, height: 158)
        static let largeDesignSize = CGSize(width: 338, height: 354)

        static let baseCornerRadius: CGFloat = 10

        static let smallGlowInset: CGFloat = 20
        static let largeGlowInset: CGFloat = 40

        static let smallGlowSize: CGFloat = 160
        static let largeGlowSize: CGFloat = 320

        static let smallContentInset: CGFloat = 16
        static let largeContentInset: CGFloat = 32

        static let smallMonthDayFontSize: CGFloat = 42
        static let largeMonthDayFontSize: CGFloat = 84

        static let smallWeekdayFontSize: CGFloat = 22
        static let largeWeekdayFontSize: CGFloat = 44
    }

    let configuration: WidgetCalendarCongifuration
    let metrics: Metrics

    private var weekdayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "EEEE"
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
            let monthText = monthFormatter.string(from: date)
            let dayText = dayFormatter.string(from: date)
            let weekdayText = weekdayFormatter.string(from: date)

            let contentInset = contentInsetForMetrics() * scale
            let glowInset = glowInsetForMetrics() * scale
            let glowSize = glowSizeForMetrics() * scale

            ZStack {
                backgroundView(size: geo.size)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()

                radialGlow(
                    color: Color(uiColor: Appearance.color_4178F6),
                    center: .center,
                    startRadius: 0,
                    endRadius: glowSize / 2
                )
                .frame(width: glowSize, height: glowSize)
                .position(
                    x: geo.size.width - glowInset,
                    y: glowInset
                )
                .opacity(1)

                radialGlow(
                    color: Color(uiColor: Appearance.color_DB7690),
                    center: .center,
                    startRadius: 0,
                    endRadius: glowSize / 2
                )
                .frame(width: glowSize, height: glowSize)
                .position(
                    x: glowInset,
                    y: geo.size.height - glowInset
                )
                .opacity(1)

                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text(monthText)
                        Text(" ")
                        Text(dayText)
                    }
                    .font(configuration.font.swiftUIFont(size: monthDayFontSizeForMetrics() * scale))
                    .foregroundStyle(Color(uiColor: configuration.fontColor))
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer(minLength: 0)

                    Text(weekdayText)
                        .font(configuration.font.swiftUIFont(size: weekdayFontSizeForMetrics() * scale))
                        .foregroundStyle(Color(uiColor: configuration.fontColor.withAlphaComponent(0.8)))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(contentInset)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .clipShape(RoundedRectangle(cornerRadius: Constants.baseCornerRadius * scale))
        }
    }
}

// MARK: - Private
private extension CalendarMonthDayAndWeekdayTextWidgetView {
    func designSizeForMetrics() -> CGSize {
        switch metrics {
        case .small:
            return Constants.smallDesignSize
        case .large:
            return Constants.largeDesignSize
        }
    }

    func glowInsetForMetrics() -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallGlowInset
        case .large:
            return Constants.largeGlowInset
        }
    }

    func glowSizeForMetrics() -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallGlowSize
        case .large:
            return Constants.largeGlowSize
        }
    }

    func contentInsetForMetrics() -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallContentInset
        case .large:
            return Constants.largeContentInset
        }
    }

    func monthDayFontSizeForMetrics() -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallMonthDayFontSize
        case .large:
            return Constants.largeMonthDayFontSize
        }
    }

    func weekdayFontSizeForMetrics() -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallWeekdayFontSize
        case .large:
            return Constants.largeWeekdayFontSize
        }
    }

    func radialGlow(
        color: Color,
        center: UnitPoint,
        startRadius: CGFloat,
        endRadius: CGFloat
    ) -> some View {
        RadialGradient(
            stops: [
                .init(color: color.opacity(0.42), location: 0.0),
                .init(color: color.opacity(0.16), location: 0.45),
                .init(color: color.opacity(0.0), location: 1.0)
            ],
            center: center,
            startRadius: startRadius,
            endRadius: endRadius
        )
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
            Color.clear
        }
    }
}
