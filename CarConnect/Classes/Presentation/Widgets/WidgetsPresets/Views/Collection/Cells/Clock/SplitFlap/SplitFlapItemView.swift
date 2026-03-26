//
//  SplitFlapItemView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 25.03.2026.
//

import UIKit

final class SplitFlapItemView: GradientView {
    enum Metrics {
        case small, large
    }
    
    lazy var label = makeLabel()
    lazy var topView = makeTopView()
    lazy var bottomView = makeBottomView()
    lazy var separator = makeSeparator()

    private let metrics: Metrics

    init(metrics: Metrics) {
        self.metrics = metrics
        
        super.init(frame: .zero)

        makeConstraints()
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SplitFlapItemView {
    func setup(title: NSAttributedString) {
        label.attributedText = title
    }
}

// MARK: Private
private extension SplitFlapItemView {
    func initialize() {
        backgroundColor = .clear
        gradientLayer.cornerRadius = 14.scale
        gradientLayer.masksToBounds = true
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.colors = [
            Appearance.color_373B47.cgColor,
            Appearance.color_2C2F39.cgColor,
            Appearance.color_2C2F39.cgColor,
            Appearance.color_373B47.cgColor
        ]
        gradientLayer.locations = [
            NSNumber(value: 0),
            NSNumber(value: 0.5),
            NSNumber(value: 0.5),
            NSNumber(value: 1),
        ]
    }
}

// MARK: Make constraints
private extension SplitFlapItemView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            topView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topView.topAnchor.constraint(equalTo: topAnchor),
            topView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -2.scale)
        ])
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.topAnchor.constraint(equalTo: centerYAnchor, constant: 2.scale),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 4.scale),
            separator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SplitFlapItemView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTopView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.color_40434D.cgColor
        view.layer.cornerRadius = 14.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBottomView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.color_40434D.cgColor
        view.layer.cornerRadius = 14.scale
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.color_2C2F39
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
