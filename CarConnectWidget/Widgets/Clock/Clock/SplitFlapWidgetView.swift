//
//  SplitFlapWidgetView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 26.03.2026.
//

import SwiftUI
import WidgetKit
import Photos

struct SplitFlapWidgetView: View {
    enum Metrics {
        case small
        case large

        var designSize: CGSize {
            switch self {
            case .small:
                return CGSize(width: 165, height: 165)
            case .large:
                return CGSize(width: 343, height: 343)
            }
        }

        var baseInset: CGFloat {
            switch self {
            case .small: return 10
            case .large: return 20
            }
        }

        var baseTopLabelsFontSize: CGFloat {
            switch self {
            case .small: return 21
            case .large: return 42
            }
        }

        var baseItemWidth: CGFloat {
            switch self {
            case .small: return 69
            case .large: return 138
            }
        }

        var baseItemHeight: CGFloat {
            switch self {
            case .small: return 112
            case .large: return 224
            }
        }

        var baseTimeFontSize: CGFloat {
            switch self {
            case .small: return 40
            case .large: return 80
            }
        }

        var baseDividerWidth: CGFloat {
            switch self {
            case .small: return 4
            case .large: return 8
            }
        }

        var baseDividerHeight: CGFloat {
            switch self {
            case .small: return 28
            case .large: return 56
            }
        }

        var baseCornerRadius: CGFloat { 10 }
    }

    let metrics: Metrics
    let configuration: WidgetClockConfiguration
    let date: Date

    private let weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()

    private let amPmFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter
    }()

    private let hours24Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter
    }()

    private let hours12Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh"
        return formatter
    }()

    private let minutesFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        return formatter
    }()

    var body: some View {
        GeometryReader { geo in
            let scale = min(
                geo.size.width / metrics.designSize.width,
                geo.size.height / metrics.designSize.height
            )

            let inset = metrics.baseInset * scale
            let topLabelsFontSize = metrics.baseTopLabelsFontSize * scale
            let itemWidth = metrics.baseItemWidth * scale
            let itemHeight = metrics.baseItemHeight * scale
            let dividerWidth = metrics.baseDividerWidth * scale
            let dividerHeight = metrics.baseDividerHeight * scale

            VStack(spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    Text(weekdayFormatter.string(from: date))
                        .font(configuration.font.swiftUIFont(size: topLabelsFontSize))
                        .foregroundColor(Color(configuration.textColor.wrappedValue))
                        .lineLimit(1)

                    Spacer(minLength: 0)

                    Text(timeFormatText)
                        .font(configuration.font.swiftUIFont(size: topLabelsFontSize))
                        .foregroundColor(Color(configuration.textColor.wrappedValue))
                        .lineLimit(1)
                }
                .padding(.top, inset)
                .padding(.horizontal, inset)

                Spacer(minLength: 0)

                HStack(alignment: .center, spacing: 0) {
                    SplitFlapItemWidgetView(
                        text: currentHours,
                        font: configuration.font.swiftUIFont(size: metrics.baseTimeFontSize * scale),
                        textColor: Color(configuration.textColor.wrappedValue),
                        scale: scale
                    )
                    .frame(width: itemWidth, height: itemHeight)

                    Spacer(minLength: 0)

                    SplitFlapDividerWidgetView(scale: scale)
                        .frame(width: dividerWidth, height: dividerHeight)

                    Spacer(minLength: 0)

                    SplitFlapItemWidgetView(
                        text: currentMinutes,
                        font: configuration.font.swiftUIFont(size: metrics.baseTimeFontSize * scale),
                        textColor: Color(configuration.textColor.wrappedValue),
                        scale: scale
                    )
                    .frame(width: itemWidth, height: itemHeight)
                }
                .padding(.horizontal, inset)
                .padding(.bottom, inset)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .containerBackground(for: .widget) {
                backgroundView(size: geo.size)
            }
        }
    }
    
    @ViewBuilder
    private func backgroundView(size: CGSize) -> some View {
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

    private var timeFormatText: String {
        switch configuration.timeFormat {
        case .twentyFourHour:
            return ""
        case .twelveHour:
            return amPmFormatter.string(from: date)
        }
    }

    private var currentHours: String {
        switch configuration.timeFormat {
        case .twelveHour:
            return hours12Formatter.string(from: date)
        case .twentyFourHour:
            return hours24Formatter.string(from: date)
        }
    }

    private var currentMinutes: String {
        minutesFormatter.string(from: date)
    }
}

private struct SplitFlapItemWidgetView: View {
    let text: String
    let font: Font
    let textColor: Color
    let scale: CGFloat

    var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    .init(color: Color(UIColor(red: 0x37 / 255, green: 0x3B / 255, blue: 0x47 / 255, alpha: 1)), location: 0.0),
                    .init(color: Color(UIColor(red: 0x2C / 255, green: 0x2F / 255, blue: 0x39 / 255, alpha: 1)), location: 0.5),
                    .init(color: Color(UIColor(red: 0x2C / 255, green: 0x2F / 255, blue: 0x39 / 255, alpha: 1)), location: 0.5),
                    .init(color: Color(UIColor(red: 0x37 / 255, green: 0x3B / 255, blue: 0x47 / 255, alpha: 1)), location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: 14 * scale, style: .continuous))

            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 14 * scale, style: .continuous)
                    .stroke(Color(UIColor(red: 0x40 / 255, green: 0x43 / 255, blue: 0x4D / 255, alpha: 1)), lineWidth: 1 * scale)
                    .mask(
                        Rectangle()
                            .frame(maxHeight: .infinity, alignment: .top)
                    )
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)

                Spacer(minLength: 4 * scale)

                RoundedRectangle(cornerRadius: 14 * scale, style: .continuous)
                    .stroke(Color(UIColor(red: 0x40 / 255, green: 0x43 / 255, blue: 0x4D / 255, alpha: 1)), lineWidth: 1 * scale)
                    .mask(
                        Rectangle()
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    )
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
            }

            Rectangle()
                .fill(Color(UIColor(red: 0x2C / 255, green: 0x2F / 255, blue: 0x39 / 255, alpha: 1)))
                .frame(height: 4 * scale)

            Text(text)
                .font(font)
                .foregroundColor(textColor)
                .lineLimit(1)
        }
    }
}

private struct SplitFlapDividerWidgetView: View {
    let scale: CGFloat

    var body: some View {
        LinearGradient(
            stops: [
                .init(color: Color(UIColor(red: 0.19, green: 0.20, blue: 0.24, alpha: 1.0)), location: 0.0),
                .init(color: Color(UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1.0)), location: 0.5),
                .init(color: Color(UIColor(red: 0.18, green: 0.20, blue: 0.24, alpha: 1.0)), location: 1.0)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.white.opacity(0.1), lineWidth: 1 * scale)
        )
    }
}
