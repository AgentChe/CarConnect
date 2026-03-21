//
//  CompactWeatherForecastView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 18.03.2026.
//

import UIKit
 
final class CompactWeatherForecastView: WeatherStyleView {
    enum Metrics {
        case small, large
    }
    
    lazy var backgroundView = makeBackgroundView()
    lazy var placeLabel = makeLabel()
    lazy var temperatureLabel = makeLabel()
    lazy var kindIconView = makeKindView()
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
        
        let place: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(configuration.textColor)
                .font(configuration.font.uiFont(baseSize: {
                    switch metrics {
                    case .small:
                        return 15.scale
                    case .large:
                        return 15.scale
                    }
                }()))
                .textAlignment(.left)
                .lineBreakMode(.byTruncatingTail)
            return weatherData.location.name.attributed(with: attrs)
        }()
        placeLabel.attributedText = place
        
        let temperature: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(configuration.textColor)
                .font(configuration.font.uiFont(baseSize: {
                    switch metrics {
                    case .small:
                        return 32.scale
                    case .large:
                        return 32.scale
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
        
        dailyView.setup(configuration: configuration, daily: weatherData.daily)
    }
}

// MARK: Private
private extension CompactWeatherForecastView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension CompactWeatherForecastView {
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
                return 12.scale
            }
        }()
        
        NSLayoutConstraint.activate([
            placeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets),
            placeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets),
            placeLabel.topAnchor.constraint(equalTo: topAnchor, constant: insets)
        ])
        
        NSLayoutConstraint.activate([
            temperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets),
            temperatureLabel.topAnchor.constraint(equalTo: placeLabel.bottomAnchor, constant: {
                switch metrics {
                case .small:
                    return 3.scale
                case .large:
                    return 3.scale
                }
            }())
        ])
        
        NSLayoutConstraint.activate([
            kindIconView.widthAnchor.constraint(equalToConstant: {
                switch metrics {
                case .small:
                    return 44.scale
                case .large:
                    return 44.scale
                }
            }()),
            kindIconView.heightAnchor.constraint(equalToConstant: {
                switch metrics {
                case .small:
                    return 44.scale
                case .large:
                    return 44.scale
                }
            }()),
            kindIconView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets),
            kindIconView.centerYAnchor.constraint(equalTo: temperatureLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dailyView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets),
            dailyView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets),
            dailyView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets),
            dailyView.heightAnchor.constraint(equalToConstant: {
                switch metrics {
                case .small:
                    return 52.scale
                case .large:
                    return 52.scale
                }
            }())
        ])
    }
}

// MARK: Lazy initialization
private extension CompactWeatherForecastView {
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
    
    func makeDailyView() -> WeatherFourDaysKindsView {
        let view = WeatherFourDaysKindsView(metrics: {
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
