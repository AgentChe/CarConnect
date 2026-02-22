//
//  WidgetsPresetsTypesView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.02.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetsPresetsTypesView: UIView {
    lazy var scrollView = makeScrollView()
    lazy var container = makeContainer()
    lazy var allButton = makeButton(title: "WidgetsPresets.Types.All".localized)
    lazy var calendarButton = makeButton(title: "WidgetsPresets.Types.Calendar".localized)
    lazy var clockButton = makeButton(title: "WidgetsPresets.Types.Clock".localized)
    lazy var carLogoButton = makeButton(title: "WidgetsPresets.Types.СarLogo".localized)
    lazy var textButton = makeButton(title: "WidgetsPresets.Types.Text".localized)
    lazy var photoButton = makeButton(title: "WidgetsPresets.Types.Photo".localized)
    lazy var weatherButton = makeButton(title: "WidgetsPresets.Types.Weather".localized)
    
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
extension WidgetsPresetsTypesView {
    func select(type: WidgetsPresetsType) {
        allButton.configuration?.baseBackgroundColor = type == .all ? Appearance.color_4178F6 : Appearance.color_2C2F39
        calendarButton.configuration?.baseBackgroundColor = type == .calendar ? Appearance.color_4178F6 : Appearance.color_2C2F39
        clockButton.configuration?.baseBackgroundColor = type == .clock ? Appearance.color_4178F6 : Appearance.color_2C2F39
        carLogoButton.configuration?.baseBackgroundColor = type == .carLogo ? Appearance.color_4178F6 : Appearance.color_2C2F39
        textButton.configuration?.baseBackgroundColor = type == .text ? Appearance.color_4178F6 : Appearance.color_2C2F39
        photoButton.configuration?.baseBackgroundColor = type == .photo ? Appearance.color_4178F6 : Appearance.color_2C2F39
        weatherButton.configuration?.baseBackgroundColor = type == .weather ? Appearance.color_4178F6 : Appearance.color_2C2F39
    }
    
    var didSelect: Signal<WidgetsPresetsType> {
        Signal
            .merge(
                allButton.rx.tap
                    .map { WidgetsPresetsType.all }
                    .asSignal(onErrorSignalWith: .never()),
                calendarButton.rx.tap
                    .map { WidgetsPresetsType.calendar }
                    .asSignal(onErrorSignalWith: .never()),
                clockButton.rx.tap
                    .map { WidgetsPresetsType.clock }
                    .asSignal(onErrorSignalWith: .never()),
                carLogoButton.rx.tap
                    .map { WidgetsPresetsType.carLogo }
                    .asSignal(onErrorSignalWith: .never()),
                textButton.rx.tap
                    .map { WidgetsPresetsType.text }
                    .asSignal(onErrorSignalWith: .never()),
                photoButton.rx.tap
                    .map { WidgetsPresetsType.photo }
                    .asSignal(onErrorSignalWith: .never()),
                weatherButton.rx.tap
                    .map { WidgetsPresetsType.weather }
                    .asSignal(onErrorSignalWith: .never())
            )
    }
}

// MARK: Private
private extension WidgetsPresetsTypesView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension WidgetsPresetsTypesView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            container.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8.scale),
            container.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -12.scale),
            container.topAnchor.constraint(equalTo: topAnchor, constant: 8.scale),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.scale)
        ])
        
        NSLayoutConstraint.activate([
            allButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            allButton.topAnchor.constraint(equalTo: container.topAnchor),
            allButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            calendarButton.leadingAnchor.constraint(equalTo: allButton.trailingAnchor, constant: 8.scale),
            calendarButton.topAnchor.constraint(equalTo: container.topAnchor),
            calendarButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            clockButton.leadingAnchor.constraint(equalTo: calendarButton.trailingAnchor, constant: 8.scale),
            clockButton.topAnchor.constraint(equalTo: container.topAnchor),
            clockButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            carLogoButton.leadingAnchor.constraint(equalTo: clockButton.trailingAnchor, constant: 8.scale),
            carLogoButton.topAnchor.constraint(equalTo: container.topAnchor),
            carLogoButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textButton.leadingAnchor.constraint(equalTo: carLogoButton.trailingAnchor, constant: 8.scale),
            textButton.topAnchor.constraint(equalTo: container.topAnchor),
            textButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            photoButton.leadingAnchor.constraint(equalTo: textButton.trailingAnchor, constant: 8.scale),
            photoButton.topAnchor.constraint(equalTo: container.topAnchor),
            photoButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            weatherButton.leadingAnchor.constraint(equalTo: photoButton.trailingAnchor, constant: 8.scale),
            weatherButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            weatherButton.topAnchor.constraint(equalTo: container.topAnchor),
            weatherButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPresetsTypesView {
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.contentInset = UIEdgeInsets(horizontal: 16.scale)
        view.setContentOffset(CGPoint(x: 16.scale, y: 0), animated: false)
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeButton(title: String) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = Appearance.color_2C2F39
        config.cornerStyle = .fixed
        config.background.cornerRadius = 19.5.scale
        config.contentInsets = NSDirectionalEdgeInsets(top: 8.scale, leading: 16.scale, bottom: 8.scale, trailing: 16.scale)
        
        let attrs = AttributeContainer([
            .foregroundColor: Appearance.color_FFFFFF,
            .font: Fonts.Inter.regular(size: 16.scale)
        ])
        config.attributedTitle = AttributedString(title, attributes: attrs)

        let view = UIButton(configuration: config)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
