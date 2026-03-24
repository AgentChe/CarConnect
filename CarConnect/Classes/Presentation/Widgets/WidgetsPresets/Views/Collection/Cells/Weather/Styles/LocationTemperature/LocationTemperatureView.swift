//
//  LocationTemperatureView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 18.03.2026.
//

import UIKit
 
final class LocationTemperatureView: WeatherStyleView {
    enum Metrics {
        case small, large
    }
    
    lazy var backgroundView = makeBackgroundView()
    lazy var placeLabel = makeLabel()
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
        
        let place: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(configuration.textColor)
                .font(configuration.font.uiFont(baseSize: {
                    switch metrics {
                    case .small:
                        return 22.scale
                    case .large:
                        return 44.scale
                    }
                }()))
                .textAlignment(.center)
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
                        return 50.scale
                    case .large:
                        return 100.scale
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
            return temperature.attributed(with: attrs)
        }()
        temperatureLabel.attributedText = temperature
    }
}

// MARK: Private
private extension LocationTemperatureView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension LocationTemperatureView {
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
            placeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets),
            placeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets),
            placeLabel.topAnchor.constraint(equalTo: topAnchor, constant: {
                switch metrics {
                case .small:
                    return 15.scale
                case .large:
                    return 30.scale
                }
            }())
        ])
        
        NSLayoutConstraint.activate([
            temperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: placeLabel.bottomAnchor, constant: {
                switch metrics {
                case .small:
                    return 24.scale
                case .large:
                    return 48.scale
                }
            }())
        ])
    }
}

// MARK: Lazy initialization
private extension LocationTemperatureView {
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
}
