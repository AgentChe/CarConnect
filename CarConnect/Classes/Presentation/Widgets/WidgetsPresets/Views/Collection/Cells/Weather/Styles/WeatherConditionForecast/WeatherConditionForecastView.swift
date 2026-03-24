//
//  WeatherConditionForecastView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 18.03.2026.
//

import UIKit
 
final class WeatherConditionForecastView: WeatherStyleView {
    enum Metrics {
        case small, large
    }
    
    lazy var backgroundView = makeBackgroundView()
    lazy var temperatureLabel = makeLabel()
    lazy var kindIconView = makeKindView()
    lazy var kindLabel = makeLabel()
    lazy var dailyView = makeDailyView()
    
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
        
        let temperature: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(configuration.textColor)
                .font(configuration.font.uiFont(baseSize: {
                    switch metrics {
                    case .small:
                        return 50.scale
                    case .large:
                        return 100.scale
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
        temperatureLabel.attributedText = temperature
        
        let kind: NSAttributedString = {
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
            
            let kindLocalized: String = {
                switch weatherData.current.condition {
                case .sunny:
                    return "WeatherCondition.Sunny".localized
                case .rainy:
                    return "WeatherCondition.Rainy".localized
                case .snowy:
                    return "WeatherCondition.Snowy".localized
                case .cloudy:
                    return "WeatherCondition.Cloudy".localized
                case .windy:
                    return "WeatherCondition.Windy".localized
                }
            }()
            
            return kindLocalized.attributed(with: attrs)
        }()
        kindLabel.attributedText = kind
        
        dailyView.setup(configuration: configuration, daily: weatherData.daily)
    }
}

// MARK: Private
private extension WeatherConditionForecastView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension WeatherConditionForecastView {
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
            temperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets),
            temperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets),
            temperatureLabel.topAnchor.constraint(equalTo: topAnchor, constant: insets)
        ])
        
        NSLayoutConstraint.activate([
            kindIconView.widthAnchor.constraint(equalToConstant: {
                switch metrics {
                case .small:
                    return 24.scale
                case .large:
                    return 48.scale
                }
            }()),
            kindIconView.heightAnchor.constraint(equalToConstant: {
                switch metrics {
                case .small:
                    return 24.scale
                case .large:
                    return 48.scale
                }
            }()),
            kindIconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets),
            kindIconView.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            kindLabel.leadingAnchor.constraint(equalTo: kindIconView.trailingAnchor, constant: {
                switch metrics {
                case .small:
                    return 6.scale
                case .large:
                    return 12.scale
                }
            }()),
            kindLabel.centerYAnchor.constraint(equalTo: kindIconView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dailyView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets),
            dailyView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets),
            dailyView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets),
            dailyView.heightAnchor.constraint(equalToConstant: {
                switch metrics {
                case .small:
                    return 38.scale
                case .large:
                    return 76.scale
                }
            }())
        ])
    }
}

// MARK: Lazy initialization
private extension WeatherConditionForecastView {
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
    
    func makeDailyView() -> WeatherFourDaysView {
        let view = WeatherFourDaysView(metrics: {
            switch metrics {
            case .small:
                return .small
            case .large:
                return .large
            }
        }())
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
