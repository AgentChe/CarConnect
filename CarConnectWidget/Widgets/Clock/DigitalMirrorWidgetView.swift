//
//  DigitalMirrorWidgetView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 26.03.2026.
//

import SwiftUI
import WidgetKit
import Photos

struct DigitalMirrorWidgetView: View {
    enum Metrics {
        case small, large
    }

    private enum Constants {
        static let smallDesignSize = CGSize(width: 165, height: 165)
        static let largeDesignSize = CGSize(width: 343, height: 343)

        static let cornerRadius: CGFloat = 10

        static let smallTopLabelsFontSize: CGFloat = 21
        static let largeTopLabelsFontSize: CGFloat = 42

        static let smallCurrentTimeFontSize: CGFloat = 40
        static let largeCurrentTimeFontSize: CGFloat = 80

        static let smallAdjacentTimeFontSize: CGFloat = 25
        static let largeAdjacentTimeFontSize: CGFloat = 50

        static let smallTopLabelsInset: CGFloat = 10
        static let largeTopLabelsInset: CGFloat = 20

        static let smallContainerTopInset: CGFloat = 35
        static let largeContainerTopInset: CGFloat = 70

        static let smallNotCurrentTimeInset: CGFloat = 25
        static let largeNotCurrentTimeInset: CGFloat = 50

        static let smallCurrentTimeInset: CGFloat = 15
        static let largeCurrentTimeInset: CGFloat = 30
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

            let cornerRadius = Constants.cornerRadius * scale

            let topInset = topLabelsInset(for: metrics) * scale
            let containerTopInset = containerTopInset(for: metrics) * scale
            let notCurrentInset = notCurrentTimeInset(for: metrics) * scale
            let currentInset = currentTimeInset(for: metrics) * scale

            let topFont = configuration.font.uiFont(
                baseSize: topLabelsFontSize(for: metrics) * scale
            )
            let currentFont = configuration.font.uiFont(
                baseSize: currentTimeFontSize(for: metrics) * scale
            )
            let adjacentFont = configuration.font.uiFont(
                baseSize: adjacentTimeFontSize(for: metrics) * scale
            )

            let textColor = Color(uiColor: configuration.textColor.wrappedValue)

            let containerHeight = geo.size.height - containerTopInset
            let containerMidY = containerTopInset + containerHeight / 2

            let currentLineHeight = currentFont.lineHeight
            let adjacentLineHeight = adjacentFont.lineHeight

            let upperCenterY = containerMidY - currentLineHeight / 2 - adjacentLineHeight / 2
            let lowerCenterY = containerMidY + currentLineHeight / 2 + adjacentLineHeight / 2

            let weekdaySize = textSize(weekdayText, font: topFont)
            let timeFormatSize = textSize(timeFormatText, font: topFont)

            let hoursAgoSize = textSize(hoursAgoText, font: adjacentFont)
            let currentHoursSize = textSize(currentHoursText, font: currentFont)
            let hoursLaterSize = textSize(hoursLaterText, font: adjacentFont)

            let minutesAgoSize = textSize(minutesAgoText, font: adjacentFont)
            let currentMinutesSize = textSize(currentMinutesText, font: currentFont)
            let minutesLaterSize = textSize(minutesLaterText, font: adjacentFont)

            ZStack(alignment: .topLeading) {
                backgroundView(size: geo.size, cornerRadius: cornerRadius)

                Text(weekdayText)
                    .font(Font(topFont))
                    .foregroundStyle(textColor)
                    .lineLimit(1)
                    .fixedSize()
                    .position(
                        x: topInset + weekdaySize.width / 2,
                        y: topInset + weekdaySize.height / 2
                    )

                if !timeFormatText.isEmpty {
                    Text(timeFormatText)
                        .font(Font(topFont))
                        .foregroundStyle(textColor)
                        .lineLimit(1)
                        .fixedSize()
                        .position(
                            x: geo.size.width - topInset - timeFormatSize.width / 2,
                            y: topInset + timeFormatSize.height / 2
                        )
                }

                Text(hoursAgoText)
                    .font(Font(adjacentFont))
                    .foregroundStyle(textColor)
                    .lineLimit(1)
                    .fixedSize()
                    .position(
                        x: notCurrentInset + hoursAgoSize.width / 2,
                        y: upperCenterY
                    )

                Text(currentHoursText)
                    .font(Font(currentFont))
                    .foregroundStyle(textColor)
                    .lineLimit(1)
                    .fixedSize()
                    .position(
                        x: currentInset + currentHoursSize.width / 2,
                        y: containerMidY
                    )

                Text(hoursLaterText)
                    .font(Font(adjacentFont))
                    .foregroundStyle(textColor)
                    .lineLimit(1)
                    .fixedSize()
                    .position(
                        x: notCurrentInset + hoursLaterSize.width / 2,
                        y: lowerCenterY
                    )

                Text(minutesAgoText)
                    .font(Font(adjacentFont))
                    .foregroundStyle(textColor)
                    .lineLimit(1)
                    .fixedSize()
                    .position(
                        x: geo.size.width - notCurrentInset - minutesAgoSize.width / 2,
                        y: upperCenterY
                    )

                Text(currentMinutesText)
                    .font(Font(currentFont))
                    .foregroundStyle(textColor)
                    .lineLimit(1)
                    .fixedSize()
                    .position(
                        x: geo.size.width - currentInset - currentMinutesSize.width / 2,
                        y: containerMidY
                    )

                Text(minutesLaterText)
                    .font(Font(adjacentFont))
                    .foregroundStyle(textColor)
                    .lineLimit(1)
                    .fixedSize()
                    .position(
                        x: geo.size.width - notCurrentInset - minutesLaterSize.width / 2,
                        y: lowerCenterY
                    )

                mirrorGradientOverlay
                    .mask(
                        VStack(spacing: 0) {
                            Color.clear
                                .frame(height: containerTopInset)

                            Rectangle()
                        }
                    )
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .containerBackground(for: .widget) {
                Color.clear
            }
        }
    }
}

// MARK: - Private
private extension DigitalMirrorWidgetView {
    var calendar: Calendar {
        Calendar.current
    }

    var minuteAgoDate: Date {
        calendar.date(byAdding: .minute, value: -1, to: date) ?? date
    }

    var minuteLaterDate: Date {
        calendar.date(byAdding: .minute, value: 1, to: date) ?? date
    }

    var weekdayText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }

    var timeFormatText: String {
        switch configuration.timeFormat {
        case .twentyFourHour:
            return ""
        case .twelveHour:
            let formatter = DateFormatter()
            formatter.dateFormat = "a"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            return formatter.string(from: date)
        }
    }

    var hoursFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = {
            switch configuration.timeFormat {
            case .twelveHour:
                return "hh"
            case .twentyFourHour:
                return "HH"
            }
        }()
        return formatter
    }

    var minutesFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        return formatter
    }

    var hoursAgoText: String { hoursFormatter.string(from: minuteAgoDate) }
    var minutesAgoText: String { minutesFormatter.string(from: minuteAgoDate) }

    var currentHoursText: String { hoursFormatter.string(from: date) }
    var currentMinutesText: String { minutesFormatter.string(from: date) }

    var hoursLaterText: String { hoursFormatter.string(from: minuteLaterDate) }
    var minutesLaterText: String { minutesFormatter.string(from: minuteLaterDate) }

    @ViewBuilder
    func alignedText(
        _ text: String,
        font: UIFont,
        color: Color,
        width: CGFloat,
        alignment: Alignment
    ) -> some View {
        Text(text)
            .font(Font(font))
            .foregroundStyle(color)
            .lineLimit(1)
            .fixedSize()
            .frame(width: width, alignment: alignment)
    }

    func textSize(_ text: String, font: UIFont) -> CGSize {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        return (text as NSString).size(withAttributes: attributes)
    }

    var mirrorGradientOverlay: some View {
        LinearGradient(
            stops: [
                .init(color: Color(uiColor: Appearance.color_353844), location: 0.0),
                .init(color: Color(uiColor: Appearance.color_343743.withAlphaComponent(0.9)), location: 0.15),
                .init(color: Color(uiColor: Appearance.color_30343F.withAlphaComponent(0.0)), location: 0.5),
                .init(color: Color(uiColor: Appearance.color_2D303A.withAlphaComponent(0.9)), location: 0.85),
                .init(color: Color(uiColor: Appearance.color_2C2F39), location: 1.0)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .allowsHitTesting(false)
    }

    @ViewBuilder
    func backgroundView(size: CGSize, cornerRadius: CGFloat) -> some View {
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

    func designSize(for metrics: Metrics) -> CGSize {
        switch metrics {
        case .small:
            return Constants.smallDesignSize
        case .large:
            return Constants.largeDesignSize
        }
    }

    func topLabelsFontSize(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallTopLabelsFontSize
        case .large:
            return Constants.largeTopLabelsFontSize
        }
    }

    func currentTimeFontSize(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallCurrentTimeFontSize
        case .large:
            return Constants.largeCurrentTimeFontSize
        }
    }

    func adjacentTimeFontSize(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallAdjacentTimeFontSize
        case .large:
            return Constants.largeAdjacentTimeFontSize
        }
    }

    func topLabelsInset(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallTopLabelsInset
        case .large:
            return Constants.largeTopLabelsInset
        }
    }

    func containerTopInset(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallContainerTopInset
        case .large:
            return Constants.largeContainerTopInset
        }
    }

    func notCurrentTimeInset(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallNotCurrentTimeInset
        case .large:
            return Constants.largeNotCurrentTimeInset
        }
    }

    func currentTimeInset(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallCurrentTimeInset
        case .large:
            return Constants.largeCurrentTimeInset
        }
    }
}
