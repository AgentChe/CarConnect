//
//  WidgetsPresetsTemplateMonthAbbrevAndDayNumberLargeCell.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 05.03.2026.
//

import UIKit

final class WidgetsPresetsTemplateMonthAbbrevAndDayNumberLargeCell: UICollectionViewCell {
    lazy var monthAbbrevAndDayNumberLarge = makeMonthAbbrevAndDayNumberLarge()
    
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
        monthAbbrevAndDayNumberLarge.setup(configuration: configuration)
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
            monthAbbrevAndDayNumberLarge.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            monthAbbrevAndDayNumberLarge.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            monthAbbrevAndDayNumberLarge.topAnchor.constraint(equalTo: contentView.topAnchor),
            monthAbbrevAndDayNumberLarge.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPresetsTemplateMonthAbbrevAndDayNumberLargeCell {
    func makeMonthAbbrevAndDayNumberLarge() -> MonthAbbrevAndDayNumberLarge {
        let view = MonthAbbrevAndDayNumberLarge(metrics: .small)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
