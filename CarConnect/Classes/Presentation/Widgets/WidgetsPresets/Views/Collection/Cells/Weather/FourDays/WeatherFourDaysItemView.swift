//
//  WeatherFourDaysItemView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 21.03.2026.
//

import UIKit

final class WeatherFourDaysItemView: UIView {
    enum Metrics {
        case small, large
    }
    
    lazy var temperatureLabel = makeLabel()
    lazy var dayLabel = makeLabel()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "EEE"
        return formatter
    }()
    
    private let metrics: Metrics
    
    init(metrics: Metrics) {
        self.metrics = metrics
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WeatherFourDaysItemView {
    func setup(configuration: WidgetWeatherConfiguration, weather: WeatherSummary) {
        let temperature: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(configuration.textColor)
                .font(configuration.font.uiFont(baseSize: 15.scale))
                .textAlignment(.center)
            let temperature: String = {
                let temperature = weather.temperature
                
                switch configuration.temperatureType {
                case .celsius:
                    return "\(Int(temperature.celsius.rounded()))"
                case .fahrenheit:
                    return "\(Int(temperature.fahrenheit.rounded()))"
                }
            }()
            return temperature.attributed(with: attrs)
        }()
        temperatureLabel.attributedText = temperature
        
        let day: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(configuration.textColor)
                .font(configuration.font.uiFont(baseSize: 12.scale))
                .textAlignment(.center)
            return dateFormatter.string(from: weather.date).attributed(with: attrs)
        }()
        dayLabel.attributedText = day
    }
}

// MARK: Private
private extension WeatherFourDaysItemView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension WeatherFourDaysItemView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            temperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            dayLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            dayLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WeatherFourDaysItemView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
