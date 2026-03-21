//
//  CalendarWeekRowWidgetView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 08.03.2026.
//

import SwiftUI

struct CalendarWeekRowWidgetView: View {
    enum Metrics {
        case small, large
    }

    private enum Constants {
        static let smallSpacing: CGFloat = 8
        static let largeSpacing: CGFloat = 18
    }

    struct Item: Identifiable {
        let id = UUID()
        let day: String
        let weekday: String
        let isHighlight: Bool
    }

    let metrics: DayNumberWithMonthGridWidgetView.Metrics
    let date: Date
    let configuration: WidgetCalendarConfiguration

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

    private var items: [Item] {
        let calendar = Calendar.current
        let offsets = [-3, -2, -1, 0, 1, 2]

        return offsets.compactMap { offset in
            guard let itemDate = calendar.date(byAdding: .day, value: offset, to: date) else {
                return nil
            }

            let weekdayFull = weekdayFormatter.string(from: itemDate)
            let weekdaySingle = String(weekdayFull.prefix(1)).uppercased()

            return Item(
                day: dayFormatter.string(from: itemDate),
                weekday: weekdaySingle,
                isHighlight: offset == 0
            )
        }
    }

    var body: some View {
        GeometryReader { geo in
            let spacing: CGFloat = {
                switch metrics {
                case .small: return Constants.smallSpacing * currentScale(size: geo.size)
                case .large: return Constants.largeSpacing * currentScale(size: geo.size)
                }
            }()

            HStack(spacing: spacing) {
                ForEach(items) { item in
                    CalendarWeekRowItemWidgetView(
                        metrics: metrics,
                        item: item,
                        configuration: configuration
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }

    private func currentScale(size: CGSize) -> CGFloat {
        switch metrics {
        case .small:
            return min(size.width / 145, size.height / 46)
        case .large:
            return min(size.width / 303, size.height / 96)
        }
    }
}
