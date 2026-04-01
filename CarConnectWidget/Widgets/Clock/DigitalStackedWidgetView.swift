//
//  DigitalStackedWidgetView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 26.03.2026.
//

import SwiftUI
import WidgetKit
import Photos

struct DigitalStackedWidgetView: View {
    enum Metrics {
        case small, large
    }

    private enum Constants {
        static let smallDesignSize = CGSize(width: 165, height: 165)
        static let largeDesignSize = CGSize(width: 343, height: 343)

        static let cornerRadius: CGFloat = 10

        static let smallFontSize: CGFloat = 51
        static let largeFontSize: CGFloat = 102

        static let smallSpacer: CGFloat = 6
        static let largeSpacer: CGFloat = 12
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

            let fontSize = textFontSize(for: metrics) * scale
            let spacer = verticalSpacer(for: metrics) * scale

            VStack(spacing: 0) {
                Spacer()

                Text(hoursText)
                    .font(configuration.font.swiftUIFont(size: fontSize))
                    .foregroundStyle(Color(uiColor: configuration.textColor.wrappedValue))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, spacer)

                Text(minutesText)
                    .font(configuration.font.swiftUIFont(size: fontSize))
                    .foregroundStyle(Color(uiColor: configuration.textColor.wrappedValue))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
                    .padding(.top, spacer)

                Spacer()
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
private extension DigitalStackedWidgetView {
    var hoursText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = {
            switch configuration.timeFormat {
            case .twelveHour:
                return "hh"
            case .twentyFourHour:
                return "HH"
            }
        }()
        return formatter.string(from: date)
    }

    var minutesText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        return formatter.string(from: date)
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

    func textFontSize(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallFontSize
        case .large:
            return Constants.largeFontSize
        }
    }

    func verticalSpacer(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallSpacer
        case .large:
            return Constants.largeSpacer
        }
    }
}
