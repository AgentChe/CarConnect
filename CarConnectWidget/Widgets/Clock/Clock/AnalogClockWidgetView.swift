//
//  AnalogClockWidgetView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 26.03.2026.
//

import SwiftUI
import WidgetKit

struct AnalogClockWidgetView: View {
    enum Metrics {
        case small, large
    }

    private enum Constants {
        static let smallDesignSize = CGSize(width: 165, height: 165)
        static let largeDesignSize = CGSize(width: 343, height: 343)

        static let smallInset: CGFloat = 10
        static let largeInset: CGFloat = 20

        static let smallNumeralFontSize: CGFloat = 12
        static let largeNumeralFontSize: CGFloat = 24
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
            let numeralFontSize = numeralFontSize(for: metrics) * scale

            AnalogClockFaceWidgetView(
                date: date,
                timeFormat: configuration.timeFormat,
                numeralFont: configuration.font.swiftUIFont(size: numeralFontSize),
                numeralTextColor: Color(uiColor: configuration.textColor.wrappedValue),
                faceColor: Color(uiColor: UIColor(white: 0.92, alpha: 1)),
                hourHandColor: .black,
                minuteHandColor: .orange,
                centerDotColor: .orange
            )
            .padding(inset)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .containerBackground(for: .widget) {
                backgroundView(size: geo.size)
            }
        }
    }
}

// MARK: - Private
private extension AnalogClockWidgetView {
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

    func numeralFontSize(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallNumeralFontSize
        case .large:
            return Constants.largeNumeralFontSize
        }
    }
}

struct AnalogClockFaceWidgetView: View {
    let date: Date
    let timeFormat: TimeFormat
    let numeralFont: Font
    let numeralTextColor: Color
    let faceColor: Color
    let hourHandColor: Color
    let minuteHandColor: Color
    let centerDotColor: Color

    init(
        date: Date,
        timeFormat: TimeFormat = .twelveHour,
        numeralFont: Font = .system(size: 16, weight: .semibold),
        numeralTextColor: Color = .black,
        faceColor: Color = Color(uiColor: UIColor(white: 0.92, alpha: 1)),
        hourHandColor: Color = .black,
        minuteHandColor: Color = .orange,
        centerDotColor: Color = .orange
    ) {
        self.date = date
        self.timeFormat = timeFormat
        self.numeralFont = numeralFont
        self.numeralTextColor = numeralTextColor
        self.faceColor = faceColor
        self.hourHandColor = hourHandColor
        self.minuteHandColor = minuteHandColor
        self.centerDotColor = centerDotColor
    }

    var body: some View {
        GeometryReader { geo in
            let side = min(geo.size.width, geo.size.height)
            let hourAngle = hourRotationAngle(for: date)
            let minuteAngle = minuteRotationAngle(for: date)

            ZStack {
                Circle()
                    .fill(faceColor)

                numeralsLayer(side: side)

                AnalogClockHandWidgetView(
                    width: max(1, side * 0.015),
                    length: side * 0.24,
                    color: hourHandColor
                )
                .rotationEffect(.radians(hourAngle))

                AnalogClockHandWidgetView(
                    width: max(1, side * 0.01),
                    length: side * 0.32,
                    color: minuteHandColor
                )
                .rotationEffect(.radians(minuteAngle))

                Circle()
                    .fill(centerDotColor)
                    .frame(width: side * 0.09, height: side * 0.09)
            }
            .frame(width: side, height: side)
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
    }
}

// MARK: - Private
private extension AnalogClockFaceWidgetView {
    var numeralValues: [Int] {
        [12] + Array(1...11)
    }

    @ViewBuilder
    func numeralsLayer(side: CGFloat) -> some View {
        let radius = side * 0.40
        let labelSize = side * 0.12
        let center = CGPoint(x: side / 2, y: side / 2)
        let count = numeralValues.count

        ForEach(Array(numeralValues.enumerated()), id: \.offset) { index, value in
            let angle = (-CGFloat.pi / 2) + (CGFloat(index) * 2 * .pi / CGFloat(count))
            let x = center.x + cos(angle) * radius
            let y = center.y + sin(angle) * radius

            Text("\(value)")
                .font(numeralFont)
                .foregroundStyle(numeralTextColor)
                .minimumScaleFactor(0.6)
                .lineLimit(1)
                .frame(width: labelSize, height: labelSize)
                .position(x: x, y: y)
        }
    }

    func minuteRotationAngle(for date: Date) -> Double {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute, .second], from: date)

        let minute = Double(components.minute ?? 0)
        let second = Double(components.second ?? 0)

        let minuteProgress = (minute + second / 60) / 60
        return 2 * .pi * minuteProgress
    }

    func hourRotationAngle(for date: Date) -> Double {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)

        let hour = Double(components.hour ?? 0)
        let minute = Double(components.minute ?? 0)
        let second = Double(components.second ?? 0)

        let normalizedHour: Double
        switch timeFormat {
        case .twelveHour:
            normalizedHour = hour.truncatingRemainder(dividingBy: 12)
        case .twentyFourHour:
            normalizedHour = hour.truncatingRemainder(dividingBy: 12)
        }

        let hourProgress = (normalizedHour + minute / 60 + second / 3600) / 12
        return 2 * .pi * hourProgress
    }
}

struct AnalogClockHandWidgetView: View {
    let width: CGFloat
    let length: CGFloat
    let color: Color

    var body: some View {
        RoundedRectangle(cornerRadius: width / 2, style: .continuous)
            .fill(color)
            .frame(width: width, height: length)
            .offset(y: -length / 2)
    }
}
