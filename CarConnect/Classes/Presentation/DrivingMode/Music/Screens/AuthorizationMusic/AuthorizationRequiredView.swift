//
//  AuthorizationRequiredView.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 24.05.2026.
//

import Foundation
import UIKit

final class AuthorizationRequiredView: UIView {
    private lazy var titleLabel = makeTitleLabel()
    private lazy var subtitleLabel = makeSubtitleLabel()
    private lazy var containerView = makeContainer()
    lazy var actionButton = makeActionButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension AuthorizationRequiredView {
    func initialize() {
        backgroundColor = Appearance.color_080A0C
    }
}

// MARK: Public
extension AuthorizationRequiredView {
    func setup(source: MusicSource) {
        var configuration = UIButton.Configuration.filled()
        var background = UIBackgroundConfiguration.clear()
        
        background.cornerRadius = 10.landscapeVScale
        
        switch source {
        case .appleMusic:
            background.backgroundColor = Appearance.color_FA4159
            configuration.contentInsets = .init(top: 15.landscapeVScale, leading: 45.landscapeHScale, bottom: 17.landscapeVScale, trailing: 45.landscapeHScale)
            
            titleLabel.attributedText = "AppleMusic.Auth.Title".localized.attributed(with: .title)
            subtitleLabel.attributedText = "AppleMusic.Auth.Subtitle".localized.attributed(with: .subtitle)
            configuration.attributedTitle = AttributedString("AppleMusic.Auth.Button".localized.attributed(with: .buttonAttrs))
        case .spotify:
            background.backgroundColor = Appearance.color_1DB954
            configuration.contentInsets = .init(top: 15.landscapeVScale, leading: 70.landscapeHScale, bottom: 17.landscapeVScale, trailing: 70.landscapeHScale)
            
            titleLabel.attributedText = "Spotify.Auth.Title".localized.attributed(with: .title)
            subtitleLabel.attributedText = "Spotify.Auth.Subtitle".localized.attributed(with: .subtitle)
            configuration.attributedTitle = AttributedString("Spotify.Auth.Button".localized.attributed(with: .buttonAttrs))
        case .radio:
            break
        }
        
        configuration.background = background
        actionButton.configuration = configuration
        actionButton.setNeedsUpdateConfiguration()
    }
}

// MARK: Make constraints
private extension AuthorizationRequiredView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 408.landscapeHScale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20.landscapeVScale),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 16.landscapeHScale),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: containerView.trailingAnchor, constant: -16.landscapeHScale)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.landscapeVScale),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24.landscapeVScale),
            actionButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20.landscapeVScale),
            actionButton.heightAnchor.constraint(equalToConstant: 60.landscapeVScale)
        ])
    }
}

// MARK: Lazy initialization
private extension AuthorizationRequiredView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.bold(size: 24.landscapeVScale))
            .lineHeight(32.landscapeVScale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "AppleMusic.Auth.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
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
        containerView.addSubview(view)
        return view
    }
    
    func makeActionButton() -> UIButton {
        let view = UIButton(configuration: .filled(), primaryAction: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Appearance.color_FFFFFF.withAlphaComponent(0.1)
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        addSubview(view)
        return view
    }
}

private extension TextAttributes {
    static let title = TextAttributes()
        .textColor(Appearance.color_FFFFFF)
        .font(Fonts.Inter.bold(size: 24.landscapeVScale))
        .lineHeight(32.landscapeVScale)
        .textAlignment(.center)
    
    static let subtitle = TextAttributes()
        .textColor(Appearance.color_FFFFFF)
        .font(Fonts.Inter.regular(size: 18.landscapeVScale))
        .lineHeight(24.landscapeVScale)
        .textAlignment(.center)
    
    static let buttonAttrs = TextAttributes()
        .textColor(Appearance.color_FFFFFF)
        .font(Fonts.Inter.bold(size: 20.landscapeVScale))
        .lineHeight(28.landscapeVScale)
}
