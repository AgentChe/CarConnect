//
//  RBPIconButton.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 28.05.2026.
//

import UIKit

final class RBPIconButton: UIButton {
    lazy var iconView = makeIconView()
    
    private let iconName: String
    
    init(iconName: String) {
        self.iconName = iconName
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension RBPIconButton {
    func initialize() {
        backgroundColor = Appearance.color_FFFFFF.withAlphaComponent(0.16)
        layer.cornerRadius = 20.landscapeHScale
    }
}

// MARK: Make constraints
private extension RBPIconButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.landscapeHScale),
            iconView.heightAnchor.constraint(equalToConstant: 24.landscapeHScale),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension RBPIconButton {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.isUserInteractionEnabled = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: iconName)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
