//
//  WidgetsPresetsTemplateClockAIPreviewCell.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 01.04.2026.
//

import UIKit

final class WidgetsPresetsTemplateClockAIPreviewCell: UICollectionViewCell {
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
extension WidgetsPresetsTemplateClockAIPreviewCell {
    func setup(configuration: WidgetClockAIPreviewConfiguration, date: Date) {
        styleView.setup(configuration: configuration, date: date)
    }
}

// MARK: Private
private extension WidgetsPresetsTemplateClockAIPreviewCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension WidgetsPresetsTemplateClockAIPreviewCell {
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
private extension WidgetsPresetsTemplateClockAIPreviewCell {
    func makeStyleView() -> ClockAIPreviewView {
        let view = ClockAIPreviewView(metrics: .small)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
