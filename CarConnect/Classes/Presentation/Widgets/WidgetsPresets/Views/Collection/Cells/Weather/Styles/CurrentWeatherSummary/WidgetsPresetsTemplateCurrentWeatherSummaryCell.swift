//
//  WidgetsPresetsTemplateCurrentWeatherSummaryCell.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 18.03.2026.
//

import UIKit

final class WidgetsPresetsTemplateCurrentWeatherSummaryCell: UICollectionViewCell {
    lazy var weatherView = makeWeatherView()
    
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
extension WidgetsPresetsTemplateCurrentWeatherSummaryCell {
    func setup(configuration: WidgetWeatherConfiguration, weatherData: WeatherData) {
        weatherView.setup(configuration: configuration, weatherData: weatherData)
    }
}

// MARK: Private
private extension WidgetsPresetsTemplateCurrentWeatherSummaryCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension WidgetsPresetsTemplateCurrentWeatherSummaryCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            weatherView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            weatherView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            weatherView.topAnchor.constraint(equalTo: contentView.topAnchor),
            weatherView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPresetsTemplateCurrentWeatherSummaryCell {
    func makeWeatherView() -> CurrentWeatherSummaryView {
        let view = CurrentWeatherSummaryView(metrics: .small)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
