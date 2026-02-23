//
//  WidgetsPresetsTemplateTextManuallyCell.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.02.2026.
//

import UIKit

final class WidgetsPresetsTemplateTextManuallyCell: UICollectionViewCell {
    lazy var container = makeContainer()
    lazy var label = makeLabel()
    
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
extension WidgetsPresetsTemplateTextManuallyCell {
    func setup(configuration: WidgetTextManuallyConfiguration) {
        let attrs = TextAttributes()
            .textColor(configuration.textColor)
            .font(configuration.font.uiFont(baseSize: 28.scale))
            .textAlignment(.center)
        label.attributedText = configuration.text.attributed(with: attrs)
        
        switch configuration.background {
        case .fileUrl:
            break // TODO: реализовать
        case .color(let color):
            container.gradientLayer.colors = [color, color].map { $0.cgColor }
        case .gradient(let colors):
            container.gradientLayer.colors = colors.map { $0.cgColor }
        }
    }
}

// MARK: Private
private extension WidgetsPresetsTemplateTextManuallyCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension WidgetsPresetsTemplateTextManuallyCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8.scale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8.scale),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPresetsTemplateTextManuallyCell {
    func makeContainer() -> GradientView {
        let view = GradientView()
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        view.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.gradientLayer.locations = [NSNumber(value: 0), NSNumber(value: 1)]
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.color_2C2F39.cgColor
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
