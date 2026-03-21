//
//  CalendarMonthGridWidgetView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 08.03.2026.
//

import SwiftUI

struct CalendarMonthGridWidgetView: View {
    private enum Constants {
        static let columns = 7
        static let weekRows = 6
        static let totalDayCells = columns * weekRows

        static let designSize = CGSize(width: 165, height: 165)

        static let baseMonthFontSize: CGFloat = 10
        static let baseWeekdayFontSize: CGFloat = 9
        static let baseDayFontSize: CGFloat = 9

        static let baseMonthTopInset: CGFloat = 14
        static let baseMonthLeadingInset: CGFloat = 10
        static let baseMonthToWeekdaysSpacing: CGFloat = 8

        static let baseWeekdayRowHeight: CGFloat = 17
        static let baseWeekdayToGridSpacing: CGFloat = 3
        static let baseGridRowSpacing: CGFloat = 3

        static let baseHighlightSize: CGFloat = 17
        static let baseHighlightCornerRadius: CGFloat = 8.5
    }

    let configuration: WidgetCalendarConfiguration

    private let weekdaySymbols = ["S", "M", "T", "W", "T", "F", "S"]

    private var calendar: Calendar {
        var calendar = Calendar.current
        calendar.locale = Locale.current
        calendar.firstWeekday = 1 // Sunday
        return calendar
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
                geo.size.width / Constants.designSize.width,
                geo.size.height / Constants.designSize.height
            )

            let date = Date()
            let model = makeMonthModel(for: date)

            ZStack {
                backgroundView(size: geo.size)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()

                VStack(alignment: .leading, spacing: 0) {
                    Text(monthFormatter.string(from: date).uppercased())
                        .font(configuration.font.swiftUIFont(size: Constants.baseMonthFontSize * scale))
                        .foregroundStyle(Color(uiColor: Appearance.color_FF4539))
                        .padding(.top, Constants.baseMonthTopInset * scale)
                        .padding(.leading, Constants.baseMonthLeadingInset * scale)

                    HStack(spacing: 0) {
                        ForEach(weekdaySymbols.indices, id: \.self) { index in
                            Text(weekdaySymbols[index])
                                .font(configuration.font.swiftUIFont(size: Constants.baseWeekdayFontSize * scale))
                                .foregroundStyle(Color(uiColor: configuration.fontColor.withAlphaComponent(0.5)))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .frame(height: Constants.baseWeekdayRowHeight * scale)
                    .padding(.top, Constants.baseMonthToWeekdaysSpacing * scale)

                    VStack(spacing: Constants.baseGridRowSpacing * scale) {
                        ForEach(0..<Constants.weekRows, id: \.self) { row in
                            HStack(spacing: 0) {
                                ForEach(0..<Constants.columns, id: \.self) { column in
                                    let index = row * Constants.columns + column
                                    let cell = model[index]

                                    ZStack {
                                        if cell.isToday {
                                            RoundedRectangle(cornerRadius: Constants.baseHighlightCornerRadius * scale)
                                                .fill(Color(uiColor: Appearance.color_FF4539))
                                                .frame(
                                                    width: Constants.baseHighlightSize * scale,
                                                    height: Constants.baseHighlightSize * scale
                                                )
                                        }

                                        if let day = cell.day {
                                            Text("\(day)")
                                                .font(configuration.font.swiftUIFont(size: Constants.baseDayFontSize * scale))
                                                .foregroundStyle(Color(uiColor: configuration.fontColor))
                                        }
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                            }
                            .frame(maxHeight: .infinity)
                        }
                    }
                    .padding(.top, Constants.baseWeekdayToGridSpacing * scale)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10 * scale))
        }
    }
}

// MARK: Private
private extension CalendarMonthGridWidgetView {
    struct DayCell: Identifiable {
        let id = UUID()
        let day: Int?
        let isToday: Bool
    }

    func makeMonthModel(for date: Date) -> [DayCell] {
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: startOfMonth)!.count
        let weekdayOfFirstDay = calendar.component(.weekday, from: startOfMonth)
        let leadingEmptyCells = weekdayOfFirstDay - 1

        let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        let shownComponents = calendar.dateComponents([.year, .month], from: date)

        let isShowingCurrentMonth =
            todayComponents.year == shownComponents.year &&
            todayComponents.month == shownComponents.month

        let todayDay = isShowingCurrentMonth ? todayComponents.day : nil

        var result = Array(
            repeating: DayCell(day: nil, isToday: false),
            count: Constants.totalDayCells
        )

        for day in 1...numberOfDaysInMonth {
            let index = leadingEmptyCells + (day - 1)
            guard index < result.count else { continue }

            result[index] = DayCell(
                day: day,
                isToday: todayDay == day
            )
        }

        return result
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
