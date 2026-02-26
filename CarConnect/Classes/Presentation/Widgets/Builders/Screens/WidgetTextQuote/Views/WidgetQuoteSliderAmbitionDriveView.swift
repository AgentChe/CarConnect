//
//  WidgetQuoteSliderAmbitionDriveView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 25.02.2026.
//

import UIKit

final class WidgetQuoteSliderAmbitionDriveView: WidgetQuoteSliderItemView {
    lazy var imageView = makeImageView()
    lazy var gradientView = makeGradientView()
    lazy var quotationMarkLabel = makeLabel()
    lazy var textLabel = makeLabel()
    lazy var authorContainer = makeAuthorContainer()
    lazy var authorImageView = makeAuthorImageView()
    lazy var authorNameLabel = makeAuthorLabel()
    lazy var authorSocialRoleLabel = makeAuthorLabel()
    
    private let quote: WidgetTextQuoteAmbitionDrive
    
    init(quote: WidgetTextQuoteAmbitionDrive) {
        self.quote = quote
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup(configuration: WidgetTextQuoteConfiguration) {
        imageView.image = UIImage(named: quote.picture)
        authorImageView.image = UIImage(named: quote.picture)
        
        let quotationMarkAttrs = TextAttributes()
            .textColor(configuration.textColor)
            .font(configuration.font.uiFont(baseSize: 74.scale))
            .textAlignment(.left)
            .lineBreakMode(.byTruncatingTail)
        quotationMarkLabel.attributedText = "“".attributed(with: quotationMarkAttrs)
        
        let textAttrs = TextAttributes()
            .textColor(configuration.textColor)
            .font(configuration.font.uiFont(baseSize: 30.scale))
            .textAlignment(.left)
            .lineBreakMode(.byTruncatingTail)
        textLabel.attributedText = quote.text.attributed(with: textAttrs)
        
        let authorNameAttrs = TextAttributes()
            .textColor(configuration.textColor)
            .font(configuration.font.uiFont(baseSize: 20.scale))
            .textAlignment(.left)
            .lineBreakMode(.byTruncatingTail)
        authorNameLabel.attributedText = quote.authorName.attributed(with: authorNameAttrs)
        
        let authorSocialRoleAttrs = TextAttributes()
            .textColor(configuration.textColor.withAlphaComponent(0.4))
            .font(configuration.font.uiFont(baseSize: 20.scale))
            .textAlignment(.left)
            .lineBreakMode(.byTruncatingTail)
        authorSocialRoleLabel.attributedText = quote.authorSocialRole.attributed(with: authorSocialRoleAttrs)
    }
}

// MARK: Private
private extension WidgetQuoteSliderAmbitionDriveView {
    func initialize() {
        backgroundColor = UIColor.clear
        layer.cornerRadius = 10.scale
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension WidgetQuoteSliderAmbitionDriveView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.topAnchor.constraint(equalTo: topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            quotationMarkLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 21.scale),
            quotationMarkLabel.topAnchor.constraint(equalTo: topAnchor, constant: 21.scale)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 21.scale),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -21.scale),
            textLabel.bottomAnchor.constraint(equalTo: authorContainer.topAnchor, constant: -21.scale)
        ])
        
        NSLayoutConstraint.activate([
            authorContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 21.scale),
            authorContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -21.scale),
            authorContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -21.scale),
            authorContainer.heightAnchor.constraint(equalToConstant: 58.scale)
        ])
        
        NSLayoutConstraint.activate([
            authorImageView.widthAnchor.constraint(equalToConstant: 58.scale),
            authorImageView.heightAnchor.constraint(equalToConstant: 58.scale),
            authorImageView.leadingAnchor.constraint(equalTo: authorContainer.leadingAnchor),
            authorImageView.centerYAnchor.constraint(equalTo: authorContainer.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            authorNameLabel.leadingAnchor.constraint(equalTo: authorContainer.leadingAnchor, constant: 74.scale),
            authorNameLabel.trailingAnchor.constraint(equalTo: authorContainer.trailingAnchor),
            authorNameLabel.topAnchor.constraint(equalTo: authorContainer.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            authorSocialRoleLabel.leadingAnchor.constraint(equalTo: authorContainer.leadingAnchor, constant: 74.scale),
            authorSocialRoleLabel.trailingAnchor.constraint(equalTo: authorContainer.trailingAnchor),
            authorSocialRoleLabel.bottomAnchor.constraint(equalTo: authorContainer.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetQuoteSliderAmbitionDriveView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeGradientView() -> GradientView {
        let view = GradientView()
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.color_2C2F39.cgColor
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        view.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.gradientLayer.locations = [
            NSNumber(value: 0),
            NSNumber(value: 0.58),
            NSNumber(value: 1)
        ]
        view.gradientLayer.colors = [
            Appearance.color_2E2E2E.withAlphaComponent(0).cgColor,
            Appearance.color_272727.withAlphaComponent(0.74).cgColor,
            Appearance.color_242424.cgColor
        ]
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAuthorContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAuthorImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 12.scale
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        authorContainer.addSubview(view)
        return view
    }
    
    func makeAuthorLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        authorContainer.addSubview(view)
        return view
    }
}
