//
//  WidgetsPresetsTemplateDayNumberWithMonthGridCell.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 05.03.2026.
//

import UIKit

final class WidgetsPresetsTemplateDayNumberWithMonthGridCell: UICollectionViewCell {
    lazy var dayNumberWithMonthGridView = makeDayNumberWithMonthGridView()
    
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
extension WidgetsPresetsTemplateDayNumberWithMonthGridCell {
    func setup(configuration: WidgetCalendarConfiguration) {
        dayNumberWithMonthGridView.setup(configuration: configuration)
    }
}

// MARK: Private
private extension WidgetsPresetsTemplateDayNumberWithMonthGridCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension WidgetsPresetsTemplateDayNumberWithMonthGridCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            dayNumberWithMonthGridView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dayNumberWithMonthGridView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dayNumberWithMonthGridView.topAnchor.constraint(equalTo: contentView.topAnchor),
            dayNumberWithMonthGridView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPresetsTemplateDayNumberWithMonthGridCell {
    func makeDayNumberWithMonthGridView() -> DayNumberWithMonthGridView {
        let view = DayNumberWithMonthGridView(metrics: .small)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
