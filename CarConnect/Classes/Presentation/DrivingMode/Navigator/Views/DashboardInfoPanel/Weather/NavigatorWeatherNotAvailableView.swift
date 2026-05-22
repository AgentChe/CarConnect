//
//  NavigatorWeatherNotAvailableView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.05.2026.
//

import UIKit

final class NavigatorWeatherNotAvailableView: GradientView {
    lazy var notAvailableLabel = makeNotAvailableLabel()
    lazy var dottedLineLabel = makeDottedLineLabel()
    
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
private extension NavigatorWeatherNotAvailableView {
    func initialize() {
        layer.cornerRadius = 10.landscapeHScale
        gradientLayer.cornerRadius = 10.landscapeHScale
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [
            NSNumber(value: 0),
            NSNumber(value: 1)
        ]
        gradientLayer.colors = [
            Appearance.color_9EBAFA.withAlphaComponent(0).cgColor,
            Appearance.color_0943C8.cgColor
        ]
    }
}

// MARK: Make constraints
private extension NavigatorWeatherNotAvailableView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            notAvailableLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11.landscapeHScale),
            notAvailableLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14.landscapeVScale)
        ])
        
        NSLayoutConstraint.activate([
            dottedLineLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11.landscapeHScale),
            dottedLineLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14.landscapeVScale)
        ])
    }
}

// MARK: Lazy initialization
private extension NavigatorWeatherNotAvailableView {
    func makeNotAvailableLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.medium(size: 16.landscapeHScale))
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Navigator.Weather.NotAvailable".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDottedLineLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.medium(size: 16.landscapeHScale))
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "—".attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
