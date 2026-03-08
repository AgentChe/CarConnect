//
//  WidgetsPresetsTemplateMonthGridCell.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 05.03.2026.
//

import UIKit

final class WidgetsPresetsTemplateMonthGridCell: UICollectionViewCell {
    lazy var monthGridView = makeMonthGridView()
    
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
extension WidgetsPresetsTemplateMonthGridCell {
    func setup(configuration: WidgetCalendarCongifuration) {
        monthGridView.setup(configuration: configuration)
    }
}

// MARK: Private
private extension WidgetsPresetsTemplateMonthGridCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension WidgetsPresetsTemplateMonthGridCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            monthGridView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            monthGridView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            monthGridView.topAnchor.constraint(equalTo: contentView.topAnchor),
            monthGridView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPresetsTemplateMonthGridCell {
    func makeMonthGridView() -> MonthGridView {
        let view = MonthGridView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
