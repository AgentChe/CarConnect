//
//  SelectTemperatureTypeView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 23.03.2026.
//

import UIKit

final class SelectTemperatureTypeView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var closeButton = makeCloseButton()
    lazy var container = makeContainer()
    lazy var celsiusButton = makeItemButton(temperatureType: .celsius)
    lazy var separator = makeSeparator()
    lazy var fahrenheitButton = makeItemButton(temperatureType: .fahrenheit)
    
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
private extension SelectTemperatureTypeView {
    func initialize() {
        backgroundColor = Appearance.color_21232A
    }
}

// MARK: Make constraints
private extension SelectTemperatureTypeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 18.scale)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 34.scale)
        ])
        
        NSLayoutConstraint.activate([
            celsiusButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            celsiusButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            celsiusButton.topAnchor.constraint(equalTo: container.topAnchor),
            celsiusButton.heightAnchor.constraint(equalToConstant: 64.scale)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            separator.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            separator.topAnchor.constraint(equalTo: celsiusButton.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.scale)
        ])
        
        NSLayoutConstraint.activate([
            fahrenheitButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            fahrenheitButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            fahrenheitButton.topAnchor.constraint(equalTo: separator.bottomAnchor),
            fahrenheitButton.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            fahrenheitButton.heightAnchor.constraint(equalToConstant: 64.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SelectTemperatureTypeView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "WidgetsBuilders.TemperatureType.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "WidgetsBuilders.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.color_2C2F39
        view.layer.cornerRadius = 12.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeItemButton(temperatureType: TemperatureUnit) -> SelectTemperatureTypeCellButton {
        let view = SelectTemperatureTypeCellButton(temperatureType: temperatureType)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.color_868EB2.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
