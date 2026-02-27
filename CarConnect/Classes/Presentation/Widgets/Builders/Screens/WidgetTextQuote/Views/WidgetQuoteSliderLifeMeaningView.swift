//
//  WidgetQuoteSliderLifeMeaningView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 25.02.2026.
//

import UIKit

final class WidgetQuoteSliderLifeMeaningView: WidgetQuoteSliderItemView {
    lazy var quotationMarkView = makeQuotationMarkView()
    lazy var textLabel = makeTextLabel()
    lazy var authorNameLabel = makeAuthorLabel()
    
    private let quote: WidgetTextQuoteLifeMeaning
    
    init(quote: WidgetTextQuoteLifeMeaning) {
        self.quote = quote
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup(configuration: WidgetTextQuoteConfiguration) {
        let textAttrs = TextAttributes()
            .textColor(configuration.textColor)
            .font(configuration.font.uiFont(baseSize: 30.scale))
            .textAlignment(.left)
            .lineBreakMode(.byTruncatingTail)
        textLabel.attributedText = quote.text.attributed(with: textAttrs)
        
        let authorNameAttrs = TextAttributes()
            .textColor(configuration.textColor.withAlphaComponent(0.4))
            .font(configuration.font.uiFont(baseSize: 20.scale))
            .textAlignment(.left)
            .lineBreakMode(.byTruncatingTail)
        authorNameLabel.attributedText = quote.authorName.attributed(with: authorNameAttrs)
    }
    
    override func getQuote() -> WidgetTextQuote {
        .lifeMeaning(quote)
    }
}

// MARK: Private
private extension WidgetQuoteSliderLifeMeaningView {
    func initialize() {
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [NSNumber(value: 0), NSNumber(value: 1)]
        gradientLayer.colors = [
            Appearance.color_4B4F5B.cgColor,
            Appearance.color_2C2F39.cgColor
        ]
        layer.borderWidth = 1.scale
        layer.borderColor = Appearance.color_2C2F39.cgColor
        layer.cornerRadius = 10.scale
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension WidgetQuoteSliderLifeMeaningView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            quotationMarkView.widthAnchor.constraint(equalToConstant: 24.scale),
            quotationMarkView.heightAnchor.constraint(equalToConstant: 24.scale),
            quotationMarkView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 21.scale),
            quotationMarkView.topAnchor.constraint(equalTo: topAnchor, constant: 21.scale)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 21.scale),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -21.scale),
            textLabel.topAnchor.constraint(equalTo: quotationMarkView.bottomAnchor, constant: 18.scale)
        ])
        
        NSLayoutConstraint.activate([
            authorNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 21.scale),
            authorNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -21.scale),
            authorNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -21.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetQuoteSliderLifeMeaningView {
    func makeQuotationMarkView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "TextQuote.LifeMeaning.QuotationMark")
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAuthorLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
