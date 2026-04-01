//
//  ClockAIPreviewWidgetView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 01.04.2026.
//

//
//  ClockAIWidgetView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 01.04.2026.
//

import SwiftUI
import WidgetKit

struct ClockAIWidgetView: View {
    enum Metrics {
        case small, large
    }

    private enum Constants {
        static let smallDesignSize = CGSize(width: 165, height: 165)
        static let largeDesignSize = CGSize(width: 343, height: 343)

        static let cornerRadius: CGFloat = 10

        static let smallTimeFontSize: CGFloat = 30
        static let largeTimeFontSize: CGFloat = 60

        static let smallDateFontSize: CGFloat = 20
        static let largeDateFontSize: CGFloat = 40

        static let smallTimeTopInset: CGFloat = 12
        static let largeTimeTopInset: CGFloat = 24

        static let smallDateBottomInset: CGFloat = 12
        static let largeDateBottomInset: CGFloat = 24

        static let smallBadgeWidth: CGFloat = 48
        static let largeBadgeWidth: CGFloat = 96

        static let smallBadgeHeight: CGFloat = 26
        static let largeBadgeHeight: CGFloat = 52

        static let smallBadgeTopInset: CGFloat = 8
        static let largeBadgeTopInset: CGFloat = 16

        static let smallBadgeTrailingInset: CGFloat = 8
        static let largeBadgeTrailingInset: CGFloat = 16
    }

    let configuration: WidgetClockAIPreviewConfiguration
    let metrics: Metrics
    let date: Date

    var body: some View {
        GeometryReader { geo in
            let designSize = designSize(for: metrics)
            let scale = min(
                geo.size.width / designSize.width,
                geo.size.height / designSize.height
            )

            ZStack {
                backgroundImageView(size: geo.size)

                overlayGradient

                VStack(spacing: 0) {
                    Text(timeText)
                        .font(configuration.font.swiftUIFont(size: timeFontSize(for: metrics) * scale))
                        .foregroundStyle(
                            Color(uiColor: configuration.textColor.wrappedValue)
                                .opacity(0.6)
                        )
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .padding(.top, timeTopInset(for: metrics) * scale)

                    Spacer()

                    Text(dateText)
                        .font(configuration.font.swiftUIFont(size: dateFontSize(for: metrics) * scale))
                        .foregroundStyle(Color(uiColor: configuration.textColor.wrappedValue))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, dateBottomInset(for: metrics) * scale)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                VStack {
                    HStack {
                        Spacer()

                        Image("WidgetsPresents.AIGenerated")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(
                                width: aiBadgeWidth(for: metrics) * scale,
                                height: aiBadgeHeight(for: metrics) * scale
                            )
                            .padding(.top, aiBadgeTopInset(for: metrics) * scale)
                            .padding(.trailing, aiBadgeTrailingInset(for: metrics) * scale)
                    }

                    Spacer()
                }
            }
            .clipShape(
                RoundedRectangle(cornerRadius: Constants.cornerRadius * scale, style: .continuous)
            )
            .containerBackground(for: .widget) {
                Color.clear
            }
        }
    }
}

// MARK: - Private
private extension ClockAIWidgetView {
    var timeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = {
            switch configuration.timeFormat {
            case .twelveHour:
                return "hh:mm a"
            case .twentyFourHour:
                return "HH:mm"
            }
        }()
        return formatter.string(from: date)
    }

    var dateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE\ndd, MMM"
        return formatter.string(from: date)
    }

    @ViewBuilder
    func backgroundImageView(size: CGSize) -> some View {
        if let image = SharedImageFileStore.shared.loadImage(url: configuration.url) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipped()
        } else {
            Color.clear
        }
    }

    var overlayGradient: some View {
        LinearGradient(
            stops: [
                .init(color: Color.black.opacity(0), location: 0),
                .init(color: Color.black.opacity(0.24), location: 1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    func designSize(for metrics: Metrics) -> CGSize {
        switch metrics {
        case .small:
            return Constants.smallDesignSize
        case .large:
            return Constants.largeDesignSize
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

    func dateFontSize(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallDateFontSize
        case .large:
            return Constants.largeDateFontSize
        }
    }

    func timeTopInset(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallTimeTopInset
        case .large:
            return Constants.largeTimeTopInset
        }
    }

    func dateBottomInset(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallDateBottomInset
        case .large:
            return Constants.largeDateBottomInset
        }
    }

    func aiBadgeWidth(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallBadgeWidth
        case .large:
            return Constants.largeBadgeWidth
        }
    }

    func aiBadgeHeight(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallBadgeHeight
        case .large:
            return Constants.largeBadgeHeight
        }
    }

    func aiBadgeTopInset(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallBadgeTopInset
        case .large:
            return Constants.largeBadgeTopInset
        }
    }

    func aiBadgeTrailingInset(for metrics: Metrics) -> CGFloat {
        switch metrics {
        case .small:
            return Constants.smallBadgeTrailingInset
        case .large:
            return Constants.largeBadgeTrailingInset
        }
    }
}
