//
//  WidgetsPresetsTemplateStackedMonthDayWeekdayCell.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 05.03.2026.
//

import UIKit

final class WidgetsPresetsTemplateStackedMonthDayWeekdayCell: UICollectionViewCell {
    lazy var stackedMonthDayWeekdayView = makeStackedMonthDayWeekdayView()
    
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
extension WidgetsPresetsTemplateStackedMonthDayWeekdayCell {
    func setup(configuration: WidgetCalendarCongifuration) {
        stackedMonthDayWeekdayView.setup(configuration: configuration)
    }
}

// MARK: Private
private extension WidgetsPresetsTemplateStackedMonthDayWeekdayCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension WidgetsPresetsTemplateStackedMonthDayWeekdayCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            stackedMonthDayWeekdayView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackedMonthDayWeekdayView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackedMonthDayWeekdayView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackedMonthDayWeekdayView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPresetsTemplateStackedMonthDayWeekdayCell {
    func makeStackedMonthDayWeekdayView() -> StackedMonthDayWeekdayView {
        let view = StackedMonthDayWeekdayView(metrics: .small)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
