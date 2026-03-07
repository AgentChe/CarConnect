//
//  CalendarWeekRowView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 06.03.2026.
//

import UIKit

final class CalendarWeekRowView: UIView {
    enum Metrics {
        case small, large
    }
    
    lazy var day1View = makeItemView()
    lazy var day2View = makeItemView()
    lazy var day3View = makeItemView()
    lazy var day4View = makeItemView()
    lazy var day5View = makeItemView()
    lazy var day6View = makeItemView()
    
    private let metrics: Metrics
    
    private lazy var weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "EEE"
        return formatter
    }()
    private lazy var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "d"
        return formatter
    }()
    
    init(metrics: Metrics) {
        self.metrics = metrics
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CalendarWeekRowView {
    func setup(date: Date, configuration: WidgetCalendarCongifuration) {
        let calendar = Calendar.current
        
        let offsets = [-3, -2, -1, 0, 1, 2]
                
        let items: [CalendarWeekRowItemView.Item] = offsets.compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: date) else {
                return nil
            }
            
            let weekdayFull = weekdayFormatter.string(from: date)
            let weekdaySingle = String(weekdayFull.prefix(1)).uppercased()
            
            return CalendarWeekRowItemView.Item(
                day: dayFormatter.string(from: date),
                weekday: weekdaySingle,
                isHighlight: offset == 0
            )
        }
        
        guard items.count == 6 else { return }
        
        day1View.setup(item: items[0], configuration: configuration)
        day2View.setup(item: items[1], configuration: configuration)
        day3View.setup(item: items[2], configuration: configuration)
        day4View.setup(item: items[3], configuration: configuration)
        day5View.setup(item: items[4], configuration: configuration)
        day6View.setup(item: items[5], configuration: configuration)
    }
}

// MARK: Private
private extension CalendarWeekRowView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension CalendarWeekRowView {
    func makeConstraints() {
        let horizontalInset: CGFloat = {
            switch metrics {
            case .small:
                return 8.scale
            case .large:
                return 18.scale
            }
        }()
        
        NSLayoutConstraint.activate([
            day1View.leadingAnchor.constraint(equalTo: leadingAnchor),
            day1View.topAnchor.constraint(equalTo: topAnchor),
            day1View.bottomAnchor.constraint(equalTo: bottomAnchor),
            day1View.widthAnchor.constraint(equalTo: day2View.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            day2View.leadingAnchor.constraint(equalTo: day1View.trailingAnchor, constant: horizontalInset),
            day2View.topAnchor.constraint(equalTo: topAnchor),
            day2View.bottomAnchor.constraint(equalTo: bottomAnchor),
            day2View.widthAnchor.constraint(equalTo: day3View.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            day3View.leadingAnchor.constraint(equalTo: day2View.trailingAnchor, constant: horizontalInset),
            day3View.topAnchor.constraint(equalTo: topAnchor),
            day3View.bottomAnchor.constraint(equalTo: bottomAnchor),
            day3View.widthAnchor.constraint(equalTo: day4View.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            day4View.leadingAnchor.constraint(equalTo: day3View.trailingAnchor, constant: horizontalInset),
            day4View.topAnchor.constraint(equalTo: topAnchor),
            day4View.bottomAnchor.constraint(equalTo: bottomAnchor),
            day4View.widthAnchor.constraint(equalTo: day5View.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            day5View.leadingAnchor.constraint(equalTo: day4View.trailingAnchor, constant: horizontalInset),
            day5View.topAnchor.constraint(equalTo: topAnchor),
            day5View.bottomAnchor.constraint(equalTo: bottomAnchor),
            day5View.widthAnchor.constraint(equalTo: day6View.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            day6View.leadingAnchor.constraint(equalTo: day5View.trailingAnchor, constant: horizontalInset),
            day6View.trailingAnchor.constraint(equalTo: trailingAnchor),
            day6View.topAnchor.constraint(equalTo: topAnchor),
            day6View.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CalendarWeekRowView {
    func makeItemView() -> CalendarWeekRowItemView {
        let view = CalendarWeekRowItemView(metrics: {
            switch metrics {
            case .small:
                return .small
            case .large:
                return .large
            }
        }())
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
