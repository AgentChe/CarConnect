//
//  WidgetsPresetsTemplateQuoteAmbitionDriveCell.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.02.2026.
//

import UIKit

final class WidgetsPresetsTemplateQuoteAmbitionDriveCell: UICollectionViewCell {
    lazy var container = makeContainer()
    lazy var imageView = makeImageView()
    lazy var gradientView = makeGradientView()
    lazy var refreshTimeView = makeRefreshTimeView()
    lazy var quotationMarkLabel = makeLabel()
    lazy var textLabel = makeLabel()
    lazy var authorContainer = makeAuthorContainer()
    lazy var authorImageView = makeAuthorImageView()
    lazy var authorNameLabel = makeAuthorLabel()
    lazy var authorSocialRoleLabel = makeAuthorLabel()
    
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
extension WidgetsPresetsTemplateQuoteAmbitionDriveCell {
    func setup(element: WidgetTextQuoteAmbitionDrive, configuration: WidgetTextQuoteConfiguration) {
        imageView.image = UIImage(named: element.picture)
        authorImageView.image = UIImage(named: element.picture)
        
        let quotationMarkAttrs = TextAttributes()
            .textColor(configuration.textColor)
            .font(configuration.font.uiFont(baseSize: 36.scale))
            .textAlignment(.left)
            .lineBreakMode(.byTruncatingTail)
        quotationMarkLabel.attributedText = "“".attributed(with: quotationMarkAttrs)
        
        let textAttrs = TextAttributes()
            .textColor(configuration.textColor)
            .font(configuration.font.uiFont(baseSize: 16.scale))
            .textAlignment(.left)
            .lineBreakMode(.byTruncatingTail)
        textLabel.attributedText = element.text.attributed(with: textAttrs)
        
        let authorNameAttrs = TextAttributes()
            .textColor(configuration.textColor)
            .font(configuration.font.uiFont(baseSize: 10.scale))
            .textAlignment(.left)
            .lineBreakMode(.byTruncatingTail)
        authorNameLabel.attributedText = element.authorName.attributed(with: authorNameAttrs)
        
        let authorSocialRoleAttrs = TextAttributes()
            .textColor(configuration.textColor.withAlphaComponent(0.4))
            .font(configuration.font.uiFont(baseSize: 10.scale)) 
            .textAlignment(.left)
            .lineBreakMode(.byTruncatingTail)
        authorSocialRoleLabel.attributedText = element.authorSocialRole.attributed(with: authorSocialRoleAttrs)
    }
}

// MARK: Private
private extension WidgetsPresetsTemplateQuoteAmbitionDriveCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension WidgetsPresetsTemplateQuoteAmbitionDriveCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            gradientView.topAnchor.constraint(equalTo: container.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            refreshTimeView.widthAnchor.constraint(equalToConstant: 61.scale),
            refreshTimeView.heightAnchor.constraint(equalToConstant: 26.scale),
            refreshTimeView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8.scale),
            refreshTimeView.topAnchor.constraint(equalTo: container.topAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            quotationMarkLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10.scale),
            quotationMarkLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10.scale),
            textLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10.scale),
            textLabel.bottomAnchor.constraint(equalTo: authorContainer.topAnchor, constant: -13.scale)
        ])
        
        NSLayoutConstraint.activate([
            authorContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10.scale),
            authorContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10.scale),
            authorContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10.scale),
            authorContainer.heightAnchor.constraint(equalToConstant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            authorImageView.widthAnchor.constraint(equalToConstant: 28.scale),
            authorImageView.heightAnchor.constraint(equalToConstant: 28.scale),
            authorImageView.leadingAnchor.constraint(equalTo: authorContainer.leadingAnchor),
            authorImageView.centerYAnchor.constraint(equalTo: authorContainer.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            authorNameLabel.leadingAnchor.constraint(equalTo: authorContainer.leadingAnchor, constant: 36.scale),
            authorNameLabel.trailingAnchor.constraint(equalTo: authorContainer.trailingAnchor),
            authorNameLabel.topAnchor.constraint(equalTo: authorContainer.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            authorSocialRoleLabel.leadingAnchor.constraint(equalTo: authorContainer.leadingAnchor, constant: 36.scale),
            authorSocialRoleLabel.trailingAnchor.constraint(equalTo: authorContainer.trailingAnchor),
            authorSocialRoleLabel.bottomAnchor.constraint(equalTo: authorContainer.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPresetsTemplateQuoteAmbitionDriveCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
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
        container.addSubview(view)
        return view
    }
    
    func makeRefreshTimeView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "TextQuote.RefreshTime")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeAuthorContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeAuthorImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 6.scale
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
