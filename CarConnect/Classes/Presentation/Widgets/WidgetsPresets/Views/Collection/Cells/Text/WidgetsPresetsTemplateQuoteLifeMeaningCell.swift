//
//  WidgetsPresetsTemplateQuoteLifeMeaningCell.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.02.2026.
//

import UIKit

final class WidgetsPresetsTemplateQuoteLifeMeaningCell: UICollectionViewCell {
    lazy var container = makeContainer()
    lazy var refreshTimeView = makeRefreshTimeView()
    lazy var quotationMarkView = makeQuotationMarkView()
    lazy var textLabel = makeTextLabel()
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
extension WidgetsPresetsTemplateQuoteLifeMeaningCell {
    func setup(element: WidgetTextQuoteLifeMeaning, configuration: WidgetTextQuoteConfiguration) {
        
        let textAttrs = TextAttributes()
            .textColor(configuration.textColor)
            .font(configuration.font.uiFont(baseSize: 18.scale))
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
private extension WidgetsPresetsTemplateQuoteLifeMeaningCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension WidgetsPresetsTemplateQuoteLifeMeaningCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            refreshTimeView.widthAnchor.constraint(equalToConstant: 61.scale),
            refreshTimeView.heightAnchor.constraint(equalToConstant: 26.scale),
            refreshTimeView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8.scale),
            refreshTimeView.topAnchor.constraint(equalTo: container.topAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            quotationMarkView.widthAnchor.constraint(equalToConstant: 24.scale),
            quotationMarkView.heightAnchor.constraint(equalToConstant: 24.scale),
            quotationMarkView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10.scale),
            quotationMarkView.topAnchor.constraint(equalTo: container.topAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10.scale),
            textLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10.scale),
            textLabel.topAnchor.constraint(equalTo: quotationMarkView.bottomAnchor, constant: 18.scale)
        ])
        
        NSLayoutConstraint.activate([
            authorNameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10.scale),
            authorNameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10.scale),
            authorNameLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPresetsTemplateQuoteLifeMeaningCell {
    func makeContainer() -> GradientView {
        let view = GradientView()
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        view.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.gradientLayer.locations = [NSNumber(value: 0), NSNumber(value: 1)]
        view.gradientLayer.colors = [
            Appearance.color_4B4F5B.cgColor,
            Appearance.color_2C2F39.cgColor
        ]
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.color_2C2F39.cgColor
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
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
    
    func makeQuotationMarkView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "TextQuote.LifeMeaning.QuotationMark")
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeTextLabel() -> UILabel {
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
