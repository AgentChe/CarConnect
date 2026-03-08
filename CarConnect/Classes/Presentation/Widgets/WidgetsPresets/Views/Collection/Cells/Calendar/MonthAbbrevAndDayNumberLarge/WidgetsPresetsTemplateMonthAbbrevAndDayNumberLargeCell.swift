//
//  WidgetsPresetsTemplateMonthAbbrevAndDayNumberLargeCell.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 05.03.2026.
//

import UIKit

final class WidgetsPresetsTemplateMonthAbbrevAndDayNumberLargeCell: UICollectionViewCell {
    lazy var monthAbbrevAndDayNumberLargeView = makeMonthAbbrevAndDayNumberLargeView()
    
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
extension WidgetsPresetsTemplateMonthAbbrevAndDayNumberLargeCell {
    func setup(configuration: WidgetCalendarCongifuration) {
        monthAbbrevAndDayNumberLargeView.setup(configuration: configuration)
    }
}

// MARK: Private
private extension WidgetsPresetsTemplateMonthAbbrevAndDayNumberLargeCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension WidgetsPresetsTemplateMonthAbbrevAndDayNumberLargeCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            monthAbbrevAndDayNumberLargeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            monthAbbrevAndDayNumberLargeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            monthAbbrevAndDayNumberLargeView.topAnchor.constraint(equalTo: contentView.topAnchor),
            monthAbbrevAndDayNumberLargeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPresetsTemplateMonthAbbrevAndDayNumberLargeCell {
    func makeMonthAbbrevAndDayNumberLargeView() -> MonthAbbrevAndDayNumberLargeView {
        let view = MonthAbbrevAndDayNumberLargeView(metrics: .small)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
