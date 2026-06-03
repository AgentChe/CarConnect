//
//  KeypadButton.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.06.2026.
//

import UIKit

final class KeypadButton: UIButton {
    let key: String

    init(key: String) {
        self.key = key

        super.init(frame: .zero)

        makeConstraints()
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension KeypadButton {
    func initialize() {
        backgroundColor = Appearance.color_FFFFFF.withAlphaComponent(0.1)
        layer.cornerRadius = 34.landscapeVScale

        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.regular(size: 34.landscapeHScale))
            .textAlignment(.center)
        setAttributedTitle(key.attributed(with: attrs), for: .normal)
    }
}

// MARK: Make constraints
private extension KeypadButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 68.landscapeVScale),
            heightAnchor.constraint(equalToConstant: 68.landscapeVScale)
        ])
    }
}
