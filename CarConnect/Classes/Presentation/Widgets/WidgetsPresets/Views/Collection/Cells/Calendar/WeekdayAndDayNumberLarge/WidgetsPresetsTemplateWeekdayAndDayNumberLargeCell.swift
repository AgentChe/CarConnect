//
//  WidgetsPresetsTemplateWeekdayAndDayNumberLargeCell.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 05.03.2026.
//

import UIKit

final class WidgetsPresetsTemplateWeekdayAndDayNumberLargeCell: UICollectionViewCell {
    lazy var weekdayAndDayNumberLargeView = makeWeekdayAndDayNumberLargeView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WidgetsPresetsTemplateWeekdayAndDayNumberLargeCell {
    func setup(configuration: WidgetCalendarCongifuration) {
        weekdayAndDayNumberLargeView.setup(configuration: configuration)
    }
}

// MARK: Private
private extension WidgetsPresetsTemplateWeekdayAndDayNumberLargeCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension WidgetsPresetsTemplateWeekdayAndDayNumberLargeCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            weekdayAndDayNumberLargeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            weekdayAndDayNumberLargeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            weekdayAndDayNumberLargeView.topAnchor.constraint(equalTo: contentView.topAnchor),
            weekdayAndDayNumberLargeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPresetsTemplateWeekdayAndDayNumberLargeCell {
    func makeWeekdayAndDayNumberLargeView() -> WeekdayAndDayNumberLargeView {
        let view = WeekdayAndDayNumberLargeView(metrics: .small)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
