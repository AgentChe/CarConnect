//
//  WidgetsPresetsTemplateQuoteMindsetGrowthCell.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.02.2026.
//

import UIKit

final class WidgetsPresetsTemplateQuoteMindsetGrowthCell: UICollectionViewCell {
    lazy var container = makeContainer()
    lazy var imageView = makeImageView()
    lazy var gradientView = makeGradientView()
    lazy var refreshTimeView = makeRefreshTimeView()
    lazy var quotationMarkLabel = makeLabel()
    lazy var textLabel = makeLabel()
    lazy var authorNameLabel = makeAuthorLabel()
    
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
extension WidgetsPresetsTemplateQuoteMindsetGrowthCell {
    func setup(element: WidgetTextQuoteMindsetGrowth, configuration: WidgetTextQuoteConfiguration) {
        imageView.image = UIImage(named: element.picture)
        
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
            .textColor(configuration.textColor.withAlphaComponent(0.4))
            .font(configuration.font.uiFont(baseSize: 12.scale)) 
            .textAlignment(.left)
            .lineBreakMode(.byTruncatingTail)
        authorNameLabel.attributedText = element.authorName.attributed(with: authorNameAttrs)
    }
}

// MARK: Private
private extension WidgetsPresetsTemplateQuoteMindsetGrowthCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension WidgetsPresetsTemplateQuoteMindsetGrowthCell {
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
            quotationMarkLabel.bottomAnchor.constraint(equalTo: textLabel.topAnchor, constant: -5.scale)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10.scale),
            textLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10.scale),
            textLabel.bottomAnchor.constraint(equalTo: authorNameLabel.topAnchor, constant: -5.scale)
        ])
        
        NSLayoutConstraint.activate([
            authorNameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10.scale),
            authorNameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10.scale),
            authorNameLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPresetsTemplateQuoteMindsetGrowthCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.color_2C2F39.cgColor
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeGradientView() -> GradientView {
        let view = GradientView()
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
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
    
    func makeAuthorLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
