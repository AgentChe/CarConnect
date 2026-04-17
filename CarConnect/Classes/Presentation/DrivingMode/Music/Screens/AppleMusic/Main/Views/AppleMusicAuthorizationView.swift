//
//  AppleMusicAuthorizationView.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 22.03.2026.
//

import UIKit

final class AppleMusicAuthorizationView: UIView {
    private lazy var titleLabel = makeTitleLabel()
    private lazy var subtitleLabel = makeSubtitleLabel()
    private lazy var actionButton = makeActionButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension AppleMusicAuthorizationView {
    func initialize() {
        backgroundColor = Appearance.color_FFFFFF.withAlphaComponent(0.1)
        layer.cornerRadius = 10.scale
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension AppleMusicAuthorizationView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20.landscapeVScale),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16.landscapeHScale),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: -16.landscapeHScale)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.landscapeVScale),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24.landscapeVScale),
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant:  54.5.landscapeHScale),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -54.5.landscapeHScale),
            actionButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.landscapeVScale),
            actionButton.heightAnchor.constraint(equalToConstant: 60.landscapeVScale)
        ])
    }
    
    @objc func openSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            DispatchQueue.main.async {
                UIApplication.shared.open(settingsURL)
            }
        }
    }
}

// MARK: Lazy initialization
private extension AppleMusicAuthorizationView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.bold(size: 24.landscapeVScale))
            .lineHeight(32.landscapeVScale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "AppleMusic.Auth.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubtitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.regular(size: 18.landscapeVScale))
            .lineHeight(24.landscapeVScale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.attributedText = "AppleMusic.Auth.Subtitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeActionButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.bold(size: 20.landscapeVScale))
            .lineHeight(28.landscapeVScale)
        
        var configuration = UIButton.Configuration.filled()
        var background = UIBackgroundConfiguration.clear()
        background.backgroundColor = Appearance.color_FA4159
        background.cornerRadius = 10.landscapeVScale
        configuration.background = background
        configuration.contentInsets = .init(top: 15.landscapeVScale, leading: 45.landscapeHScale, bottom: 17.landscapeVScale, trailing: 45.landscapeHScale)
        
        
        let view = UIButton(configuration: configuration, primaryAction: nil)
        view.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        view.setAttributedTitle("AppleMusic.Auth.Button".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = Appearance.color_FA4159
//        view.layer.cornerRadius = 10.landscapeVScale
//        view.layer.masksToBounds = true
        addSubview(view)
        return view
    }
}
