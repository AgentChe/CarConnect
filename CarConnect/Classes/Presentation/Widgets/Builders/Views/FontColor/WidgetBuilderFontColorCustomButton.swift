//
//  WidgetBuilderFontColorCustomButton.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 24.02.2026.
//

import UIKit

final class WidgetBuilderFontColorCustomButton: GradientButton {
    lazy var colorView = makeColorView()
    
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
extension WidgetBuilderFontColorCustomButton {
    func setup(selected: Bool) {
        gradientLayer.colors = selected ? [UIColor.clear.cgColor] : [
            UIColor.red.cgColor,
            UIColor.yellow.cgColor,
            UIColor.green.cgColor,
            UIColor.cyan.cgColor,
            UIColor.blue.cgColor,
            UIColor.magenta.cgColor,
            UIColor.red.cgColor
        ]
        layer.borderWidth = selected ? 2.scale : 0
        layer.borderColor = selected ? Appearance.color_4178F6.cgColor : UIColor.clear.cgColor
        colorView.isHidden = !selected
    }
}

// MARK: Private
private extension WidgetBuilderFontColorCustomButton {
    func initialize() {
        layer.cornerRadius = 10.scale
        layer.masksToBounds = true
        gradientLayer.type = .conic
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.colors = [
            UIColor.red.cgColor,
            UIColor.yellow.cgColor,
            UIColor.green.cgColor,
            UIColor.cyan.cgColor,
            UIColor.blue.cgColor,
            UIColor.magenta.cgColor,
            UIColor.red.cgColor
        ]
        
        colorView.isHidden = true 
    }
}

// MARK: Make constraints
private extension WidgetBuilderFontColorCustomButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4.scale),
            colorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4.scale),
            colorView.topAnchor.constraint(equalTo: topAnchor, constant: 4.scale),
            colorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetBuilderFontColorCustomButton {
    func makeColorView() -> GradientView {
        let view = GradientView()
        view.isUserInteractionEnabled = false
        view.layer.cornerRadius = 6.scale
        view.layer.masksToBounds = true
        view.gradientLayer.type = .conic
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        view.gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        view.gradientLayer.colors = [
            UIColor.red.cgColor,
            UIColor.yellow.cgColor,
            UIColor.green.cgColor,
            UIColor.cyan.cgColor,
            UIColor.blue.cgColor,
            UIColor.magenta.cgColor,
            UIColor.red.cgColor
        ]
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
