//
//  SpotifyCapabilitiesMessageView.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 28.05.2026.
//

import UIKit

class SpotifyCapabilitiesMessageView: UIView {
    
    private lazy var messageLabel = makeLabel()
    
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
extension SpotifyCapabilitiesMessageView {
    func setup(message: String) {
        messageLabel.attributedText = message.attributed(with: .message)
    }
}

// MARK: Private
private extension SpotifyCapabilitiesMessageView {
    func initialize() {
        backgroundColor = Appearance.color_FFFFFF.withAlphaComponent(0.1)
        layer.cornerRadius = 17.landscapeHScale
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension SpotifyCapabilitiesMessageView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 34.landscapeHScale),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.landscapeHScale),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.landscapeHScale)
        ])
    }
}

// MARK: Lazy initialization
private extension SpotifyCapabilitiesMessageView {
    private func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

private extension TextAttributes {
    static let message = TextAttributes()
        .textColor(Appearance.color_FFFFFF)
        .font(Fonts.Inter.regular(size: 16.landscapeVScale))
        .textAlignment(.center)
}
