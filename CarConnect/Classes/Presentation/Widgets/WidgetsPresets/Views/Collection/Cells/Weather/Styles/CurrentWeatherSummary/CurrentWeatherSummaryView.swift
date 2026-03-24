//
//  CurrentWeatherSummaryView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 18.03.2026.
//

import UIKit
 
final class CurrentWeatherSummaryView: WeatherStyleView {
    enum Metrics {
        case small, large
    }
    
    lazy var backgroundView = makeBackgroundView()
    lazy var nowInLabel = makeLabel()
    lazy var placeLabel = makeLabel()
    lazy var feelsLabel = makeLabel()
    lazy var kindIconView = makeIconView()
    lazy var kindNameLabel = makeLabel()
    
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
        
        let textSize: CGFloat = {
            switch metrics {
            case .small:
                return 20.scale
            case .large:
                return 40.scale
            }
        }()
        
        let nowIn: NSAttributedString = {
            let temperatureAttrs = TextAttributes()
                .textColor(configuration.textColor)
                .font(configuration.font.uiFont(baseSize: textSize))
            let temperature: String = {
                let temperature = weatherData.current.temperature
                
                switch configuration.temperatureType {
                case .celsius:
                    return "\(Int(temperature.celsius.rounded()))°C"
                case .fahrenheit:
                    return "\(Int(temperature.fahrenheit.rounded()))°F"
                }
            }()
            
            let placeholderAttrs = TextAttributes()
                .textColor(configuration.textColor.withAlphaComponent(0.6))
                .font(configuration.font.uiFont(baseSize: textSize))
            
            let result = NSMutableAttributedString()
            result.append(temperature.attributed(with: temperatureAttrs))
            result.append("WidgetsPresets.Weather.NowIn".localized.attributed(with: placeholderAttrs))
            return result
        }()
        nowInLabel.attributedText = nowIn
        
        let place: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(configuration.textColor)
                .font(configuration.font.uiFont(baseSize: textSize))
                .lineBreakMode(.byTruncatingTail)
            return weatherData.location.name.attributed(with: attrs)
        }()
        placeLabel.attributedText = place
        
        let feels: NSAttributedString = {
            let placeholderAttrs = TextAttributes()
                .textColor(configuration.textColor.withAlphaComponent(0.6))
                .font(configuration.font.uiFont(baseSize: textSize))
            
            let temperatureAttrs = TextAttributes()
                .textColor(configuration.textColor)
                .font(configuration.font.uiFont(baseSize: textSize))
            let temperature: String = {
                let temperature = weatherData.current.feelsLike
                
                switch configuration.temperatureType {
                case .celsius:
                    return "\(Int(temperature.celsius.rounded()))°C"
                case .fahrenheit:
                    return "\(Int(temperature.fahrenheit.rounded()))°F"
                }
            }()
            
            let result = NSMutableAttributedString()
            result.append("WidgetsPresets.Weather.Feels".localized.attributed(with: placeholderAttrs))
            result.append(temperature.attributed(with: temperatureAttrs))
            return result
        }()
        feelsLabel.attributedText = feels
        
        let kind: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(configuration.textColor)
                .font(configuration.font.uiFont(baseSize: textSize))
            
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
        kindNameLabel.attributedText = kind
    }
}

// MARK: Private
private extension CurrentWeatherSummaryView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension CurrentWeatherSummaryView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        let inset: CGFloat = {
            switch metrics {
            case .small:
                return 12.scale
            case .large:
                return 24.scale
            }
        }()
        
        NSLayoutConstraint.activate([
            nowInLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            nowInLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            nowInLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset)
        ])
        
        NSLayoutConstraint.activate([
            placeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            placeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            placeLabel.topAnchor.constraint(equalTo: nowInLabel.bottomAnchor, constant: {
                switch metrics {
                case .small:
                    return 4.scale
                case .large:
                    return 8.scale
                }
            }())
        ])
        
        NSLayoutConstraint.activate([
            feelsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            feelsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            feelsLabel.topAnchor.constraint(equalTo: placeLabel.bottomAnchor, constant: {
                switch metrics {
                case .small:
                    return 4.scale
                case .large:
                    return 8.scale
                }
            }())
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
            kindIconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            kindIconView.centerYAnchor.constraint(equalTo: kindNameLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            kindNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: {
                switch metrics {
                case .small:
                    return 46.scale
                case .large:
                    return 92.scale
                }
            }()),
            kindNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            kindNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
    }
}

// MARK: Lazy initialization
private extension CurrentWeatherSummaryView {
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
