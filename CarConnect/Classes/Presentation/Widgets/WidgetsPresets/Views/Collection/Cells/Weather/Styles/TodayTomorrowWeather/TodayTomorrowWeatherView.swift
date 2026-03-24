//
//  TodayTomorrowWeatherView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 18.03.2026.
//

import UIKit
 
final class TodayTomorrowWeatherView: WeatherStyleView {
    enum Metrics {
        case small, large
    }
    
    lazy var backgroundView = makeBackgroundView()
    lazy var todayLabel = makeLabel()
    lazy var todayTemperatureLabel = makeLabel()
    lazy var kindIconView = makeKindView()
    lazy var tomorrowTemperatureLabel = makeLabel()
    
    private let metrics: Metrics
    
    init(metrics: Metrics) {
        self.metrics = metrics
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup(configuration: WidgetWeatherConfiguration, weatherData: WeatherData) {
        backgroundView.setup(background: weatherData.current.condition)
        kindIconView.setup(icon: weatherData.current.condition)
        
        let today: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(configuration.textColor)
                .font(configuration.font.uiFont(baseSize: {
                    switch metrics {
                    case .small:
                        return 16.scale
                    case .large:
                        return 32.scale
                    }
                }()))
                .textAlignment(.left)
            return "WidgetsPresets.Weather.Today".localized.attributed(with: attrs)
        }()
        todayLabel.attributedText = today
        
        let todayTemperature: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(configuration.textColor)
                .font(configuration.font.uiFont(baseSize: {
                    switch metrics {
                    case .small:
                        return 32.scale
                    case .large:
                        return 64.scale
                    }
                }()))
                .textAlignment(.left)
            let temperature: String = {
                let temperature = weatherData.current.temperature
                
                switch configuration.temperatureType {
                case .celsius:
                    return "\(Int(temperature.celsius.rounded()))°C"
                case .fahrenheit:
                    return "\(Int(temperature.fahrenheit.rounded()))°F"
                }
            }()
            return temperature.attributed(with: attrs)
        }()
        todayTemperatureLabel.attributedText = todayTemperature
        
        let tomorrowTemperature: NSAttributedString? = {
            let attrs = TextAttributes()
                .textColor(configuration.textColor)
                .font(configuration.font.uiFont(baseSize: {
                    switch metrics {
                    case .small:
                        return 16.scale
                    case .large:
                        return 32.scale
                    }
                }()))
                .textAlignment(.left)
            let temperature: String? = {
                guard let temperature = weatherData.daily.first?.temperature else { return nil }
                
                switch configuration.temperatureType {
                case .celsius:
                    return "\(Int(temperature.celsius.rounded()))°C"
                case .fahrenheit:
                    return "\(Int(temperature.fahrenheit.rounded()))°F"
                }
            }()
            
            guard let temperature else { return nil }
            
            return String(format: "WidgetsPresets.Weather.TomorrowTemperature".localized, temperature).attributed(with: attrs)
        }()
        tomorrowTemperatureLabel.attributedText = tomorrowTemperature
    }
}

// MARK: Private
private extension TodayTomorrowWeatherView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension TodayTomorrowWeatherView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        let insets: CGFloat = {
            switch metrics {
            case .small:
                return 12.scale
            case .large:
                return 24.scale
            }
        }()
        
        NSLayoutConstraint.activate([
            todayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets),
            todayLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets),
            todayLabel.topAnchor.constraint(equalTo: topAnchor, constant: insets)
        ])
        
        NSLayoutConstraint.activate([
            todayTemperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets),
            todayTemperatureLabel.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: {
                switch metrics {
                case .small:
                    return 2.scale
                case .large:
                    return 4.scale
                }
            }())
        ])
        
        NSLayoutConstraint.activate([
            kindIconView.widthAnchor.constraint(equalToConstant: {
                switch metrics {
                case .small:
                    return 36.scale
                case .large:
                    return 72.scale
                }
            }()),
            kindIconView.heightAnchor.constraint(equalToConstant: {
                switch metrics {
                case .small:
                    return 36.scale
                case .large:
                    return 72.scale
                }
            }()),
            kindIconView.leadingAnchor.constraint(equalTo: todayTemperatureLabel.trailingAnchor, constant: 6.scale),
            kindIconView.centerYAnchor.constraint(equalTo: todayTemperatureLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tomorrowTemperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets),
            tomorrowTemperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets),
            tomorrowTemperatureLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets)
        ])
    }
}

// MARK: Lazy initialization
private extension TodayTomorrowWeatherView {
    func makeBackgroundView() -> WeatherKindImageView {
        let view = WeatherKindImageView()
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeKindView() -> WeatherKindImageView {
        let view = WeatherKindImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
