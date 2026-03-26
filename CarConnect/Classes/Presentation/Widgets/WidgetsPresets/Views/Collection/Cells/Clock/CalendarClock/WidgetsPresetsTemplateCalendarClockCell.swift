//
//  WidgetsPresetsTemplateCalendarClockCell.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 25.03.2026.
//

import UIKit

final class WidgetsPresetsTemplateCalendarClockCell: UICollectionViewCell {
    lazy var styleView = makeStyleView()
    
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
extension WidgetsPresetsTemplateCalendarClockCell {
    func setup(configuration: WidgetClockConfiguration) {
        styleView.setup(configuration: configuration)
    }
}

// MARK: Private
private extension WidgetsPresetsTemplateCalendarClockCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension WidgetsPresetsTemplateCalendarClockCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            styleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            styleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            styleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            styleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPresetsTemplateCalendarClockCell {
    func makeStyleView() -> CalendarClockView {
        let view = CalendarClockView(metrics: .small)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
