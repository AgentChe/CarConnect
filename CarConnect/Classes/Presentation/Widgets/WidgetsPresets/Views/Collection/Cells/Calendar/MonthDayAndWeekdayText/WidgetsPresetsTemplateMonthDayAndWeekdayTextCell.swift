//
//  WidgetsPresetsTemplateMonthDayAndWeekdayTextCell.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 05.03.2026.
//

import UIKit

final class WidgetsPresetsTemplateMonthDayAndWeekdayTextCell: UICollectionViewCell {
    lazy var monthDayAndWeekdayTextView = makeMonthDayAndWeekdayTextView()
    
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
extension WidgetsPresetsTemplateMonthDayAndWeekdayTextCell {
    func setup(configuration: WidgetCalendarCongifuration) {
        monthDayAndWeekdayTextView.setup(configuration: configuration)
    }
}

// MARK: Private
private extension WidgetsPresetsTemplateMonthDayAndWeekdayTextCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension WidgetsPresetsTemplateMonthDayAndWeekdayTextCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            monthDayAndWeekdayTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            monthDayAndWeekdayTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            monthDayAndWeekdayTextView.topAnchor.constraint(equalTo: contentView.topAnchor),
            monthDayAndWeekdayTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPresetsTemplateMonthDayAndWeekdayTextCell {
    func makeMonthDayAndWeekdayTextView() -> MonthDayAndWeekdayTextView {
        let view = MonthDayAndWeekdayTextView(metrics: .small)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
