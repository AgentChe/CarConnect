//
//  DayNumberWithMonthGridWidgetView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 08.03.2026.
//

import SwiftUI

struct DayNumberWithMonthGridWidgetView: View {
    enum Metrics {
        case small, large
    }

    private enum Constants {
        static let smallDesignSize = CGSize(width: 165, height: 165)
        static let largeDesignSize = CGSize(width: 343, height: 343)

        static let cornerRadius: CGFloat = 10

        static let smallInsets: CGFloat = 10
        static let largeInsets: CGFloat = 20

        static let smallContainerHeight: CGFloat = 87
        static let largeContainerHeight: CGFloat = 180

        static let smallDayFontSize: CGFloat = 50
        static let largeDayFontSize: CGFloat = 100

        static let smallWeekdayFontSize: CGFloat = 12
        static let largeWeekdayFontSize: CGFloat = 24

        static let smallDayCenterX: CGFloat = 40
        static let largeDayCenterX: CGFloat = 83

        static let smallTextLeadingOffset: CGFloat = 5
        static let largeTextLeadingOffset: CGFloat = 10

        static let smallWeekdayBottomOffset: CGFloat = -1
        static let largeWeekdayBottomOffset: CGFloat = -2

        static let smallMonthTopOffset: CGFloat = 1
        static let largeMonthTopOffset: CGFloat = 2

        static let smallWeekRowHeight: CGFloat = 46
        static let largeWeekRowHeight: CGFloat = 96

        static let smallContainerCornerRadius: CGFloat = 8
        static let largeContainerCornerRadius: CGFloat = 8
    }

    let metrics: Metrics
    let configuration: WidgetCalendarConfiguration

    private var designSize: CGSize {
        switch metrics {
        case .small: return Constants.smallDesignSize
        case .large: return Constants.largeDesignSize
        }
    }

    private var weekdayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "EEE"
        return formatter
    }

    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "d"
        return formatter
    }

    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "MMMM"
        return formatter
    }

    var body: some View {
        GeometryReader { geo in
            let scale = min(
                geo.size.width / designSize.width,
                geo.size.height / designSize.height
            )

            let date = Date()

            let insets: CGFloat = {
                switch metrics {
                case .small: return Constants.smallInsets * scale
                case .large: return Constants.largeInsets * scale
                }
            }()

            let containerHeight: CGFloat = {
                switch metrics {
                case .small: return Constants.smallContainerHeight * scale
                case .large: return Constants.largeContainerHeight * scale
                }
            }()

            let weekRowHeight: CGFloat = {
                switch metrics {
                case .small: return Constants.smallWeekRowHeight * scale
                case .large: return Constants.largeWeekRowHeight * scale
                }
            }()

            let dayFontSize: CGFloat = {
                switch metrics {
                case .small: return Constants.smallDayFontSize * scale
                case .large: return Constants.largeDayFontSize * scale
                }
            }()

            let weekdayFontSize: CGFloat = {
                switch metrics {
                case .small: return Constants.smallWeekdayFontSize * scale
                case .large: return Constants.largeWeekdayFontSize * scale
                }
            }()

            let dayCenterX: CGFloat = {
                switch metrics {
                case .small: return Constants.smallDayCenterX * scale
                case .large: return Constants.largeDayCenterX * scale
                }
            }()

            let textLeadingOffset: CGFloat = {
                switch metrics {
                case .small: return Constants.smallTextLeadingOffset * scale
                case .large: return Constants.largeTextLeadingOffset * scale
                }
            }()

            let weekdayBottomOffset: CGFloat = {
                switch metrics {
                case .small: return Constants.smallWeekdayBottomOffset * scale
                case .large: return Constants.largeWeekdayBottomOffset * scale
                }
            }()

            let monthTopOffset: CGFloat = {
                switch metrics {
                case .small: return Constants.smallMonthTopOffset * scale
                case .large: return Constants.largeMonthTopOffset * scale
                }
            }()

            let containerCornerRadius: CGFloat = {
                switch metrics {
                case .small: return Constants.smallContainerCornerRadius * scale
                case .large: return Constants.largeContainerCornerRadius * scale
                }
            }()

            ZStack {
                backgroundView(size: geo.size)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()

                VStack(spacing: 0) {
                    ZStack {
                        RoundedRectangle(cornerRadius: containerCornerRadius)
                            .fill(Color(uiColor: Appearance.color_FFFFFF.withAlphaComponent(0.04)))

                        HStack(spacing: 0) {
                            ZStack {
                                Text(dayFormatter.string(from: date))
                                    .font(configuration.font.swiftUIFont(size: dayFontSize))
                                    .foregroundStyle(Color(uiColor: configuration.fontColor))
                            }
                            .frame(width: dayCenterX * 2)

                            VStack(alignment: .leading, spacing: 0) {
                                Spacer()

                                Text(weekdayFormatter.string(from: date))
                                    .font(configuration.font.swiftUIFont(size: weekdayFontSize))
                                    .foregroundStyle(Color(uiColor: configuration.fontColor))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .offset(y: weekdayBottomOffset)

                                Text(monthFormatter.string(from: date))
                                    .font(configuration.font.swiftUIFont(size: weekdayFontSize))
                                    .foregroundStyle(Color(uiColor: configuration.fontColor.withAlphaComponent(0.6)))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .offset(y: monthTopOffset)

                                Spacer()
                            }
                            .padding(.leading, textLeadingOffset)
                        }
                        .padding(.horizontal, textLeadingOffset)
                    }
                    .frame(height: containerHeight)

                    Spacer()

                    CalendarWeekRowWidgetView(
                        metrics: metrics,
                        date: date,
                        configuration: configuration
                    )
                    .frame(height: weekRowHeight)
                }
                .padding(insets)
            }
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius * scale))
        }
    }
}

// MARK: - Background
private extension DayNumberWithMonthGridWidgetView {
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
            // Widget игнорирует Photo Library background
            Color.clear
        }
    }
}
