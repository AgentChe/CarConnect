//
//  SplitFlapDividerView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 25.03.2026.
//

import UIKit

final class SplitFlapDividerView: UIView {
    private lazy var gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = bounds

        let radius = bounds.width / 2
        layer.cornerRadius = radius
        gradientLayer.cornerRadius = radius
    }
}

// MARK: - Private
private extension SplitFlapDividerView {
    func initialize() {
        backgroundColor = .clear

        layer.masksToBounds = false

        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.colors = [
            UIColor(red: 0.19, green: 0.20, blue: 0.24, alpha: 1.0).cgColor,
            UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1.0).cgColor,
            UIColor(red: 0.18, green: 0.20, blue: 0.24, alpha: 1.0).cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]

        layer.addSublayer(gradientLayer)

        layer.borderWidth = 1.scale
        layer.borderColor = Appearance.color_FFFFFF.withAlphaComponent(0.1).cgColor
    }
}
