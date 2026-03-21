//
//  WeatherIconTemperatureView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 18.03.2026.
//

import UIKit
 
final class WeatherIconTemperatureView: WeatherStyleView {
    enum Metrics {
        case small, large
    }
    
    lazy var backgroundView = makeBackgroundView()
    lazy var placeLabel = makeLabel()
    lazy var iconView = makeIconView()
    lazy var temperatureLabel = makeLabel()
    
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
        iconView.setup(icon: weatherData.current.condition)
        
        let placeAttrs = TextAttributes()
            .textColor(configuration.textColor)
            .font(configuration.font.uiFont(baseSize: {
                switch metrics {
                case .small:
                    return 15.scale
                case .large:
                    return 15.scale
                }
            }()))
            .textAlignment(.center)
        placeLabel.attributedText = weatherData.location.name.attributed(with: placeAttrs)
        
        let temperatureAttrs = TextAttributes()
            .textColor(configuration.textColor)
            .font(configuration.font.uiFont(baseSize: {
                switch metrics {
                case .small:
                    return 34.scale
                case .large:
                    return 34.scale
                }
            }()))
            .textAlignment(.center)
        let temperature: String = {
            let temperature = weatherData.current.temperature
            
            switch configuration.temperatureType {
            case .celsius:
                return "\(Int(temperature.celsius.rounded()))°C"
            case .fahrenheit:
                return "\(Int(temperature.fahrenheit.rounded()))°F"
            }
        }()
        temperatureLabel.attributedText = temperature.attributed(with: temperatureAttrs)
    }
}

// MARK: Private
private extension WeatherIconTemperatureView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension WeatherIconTemperatureView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            placeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale),
            placeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale),
            placeLabel.topAnchor.constraint(equalTo: topAnchor, constant: {
                switch metrics {
                case .small:
                    return 12.scale
                case .large:
                    return 12.scale
                }
            }())
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: {
                switch metrics {
                case .small:
                    return 52.scale
                case .large:
                    return 52.scale
                }
            }()),
            iconView.heightAnchor.constraint(equalToConstant: {
                switch metrics {
                case .small:
                    return 52.scale
                case .large:
                    return 52.scale
                }
            }()),
            iconView.topAnchor.constraint(equalTo: placeLabel.bottomAnchor, constant: {
                switch metrics {
                case .small:
                    return 16.scale
                case .large:
                    return 16.scale
                }
            }()),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            temperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale),
            temperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale),
            temperatureLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: {
                switch metrics {
                case .small:
                    return -12.scale
                case .large:
                    return -12.scale
                }
            }())
        ])
    }
}

// MARK: Lazy initialization
private extension WeatherIconTemperatureView {
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
    
    func makeIconView() -> WeatherKindImageView {
        let view = WeatherKindImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
