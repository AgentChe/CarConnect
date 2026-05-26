//
//  NavigatorWeatherInfoView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.05.2026.
//

import UIKit

final class NavigatorWeatherInfoView: UIView {
    lazy var backgroundView = makeBackgroundView()
    lazy var locationLabel = makeLocationLabel()
    lazy var temperatureLabel = makeTemperatureLabel()
    lazy var weatherKindLabel = makeWeatherKindLabel()
    lazy var iconView = makeIconView()
    
    private let weatherData: WeatherData
    
    private lazy var temperatureType = TemperatureType.celsius // TODO: получать из настроек (стореджа)
    
    init(weatherData: WeatherData) {
        self.weatherData = weatherData
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension NavigatorWeatherInfoView {
    func initialize() {
        layer.cornerRadius = 10.landscapeHScale
    }
}

// MARK: Make constraints
private extension NavigatorWeatherInfoView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            locationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.landscapeHScale),
            locationLabel.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -8.landscapeHScale),
            locationLabel.bottomAnchor.constraint(equalTo: temperatureLabel.topAnchor, constant: -6.landscapeVScale)
        ])
        
        NSLayoutConstraint.activate([
            temperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.landscapeHScale),
            temperatureLabel.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -8.landscapeHScale),
            temperatureLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            weatherKindLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.landscapeHScale),
            weatherKindLabel.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -8.landscapeHScale),
            weatherKindLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 6.landscapeVScale)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 54.landscapeHScale),
            iconView.heightAnchor.constraint(equalToConstant: 54.landscapeHScale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.landscapeHScale)
        ])
    }
}

// MARK: Lazy initialization
private extension NavigatorWeatherInfoView {
    func makeBackgroundView() -> UIImageView {
        let imageName: String = {
            let domain: String = {
                switch weatherData.current.condition {
                case .clearSky:
                    return "Navigator.Weather.ClearSky.Back"
                case .fewClouds:
                    return "Navigator.Weather.FewClouds.Back"
                case .brokenClouds:
                    return "Navigator.Weather.BrokenClouds.Back"
                case .scatteredClouds:
                    return "Navigator.Weather.ScatteredClouds.Back"
                case .rain:
                    return "Navigator.Weather.Rain.Back"
                case .showerRain:
                    return "Navigator.Weather.ShowerRain.Back"
                case .mist:
                    return "Navigator.Weather.Mist.Back"
                case .snow:
                    return "Navigator.Weather.Snow.Back"
                case .thunderstorm:
                    return "Navigator.Weather.Thunderstorm.Back"
                }
            }()
            
            let isDay = Date.isDay(weatherData.current.date)
            
            return domain + (isDay ? ".Day" : ".Night")
        }()
        
        let view = UIImageView()
        view.image = UIImage(named: imageName)
        view.layer.cornerRadius = 10.landscapeHScale
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLocationLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.medium(size: 16.landscapeHScale))
            .textAlignment(.left)
            .lineBreakMode(.byTruncatingTail)
        
        let view = UILabel()
        view.attributedText = weatherData.location.name.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTemperatureLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.semiBold(size: 42.landscapeHScale))
            .textAlignment(.left)
            .lineBreakMode(.byTruncatingTail)
        
        let temperature: String = {
            switch temperatureType {
            case .celsius:
                let value = Int(weatherData.current.temperature.celsius)
                return "\(value)°C"
            case .fahrenheit:
                let value = Int(weatherData.current.temperature.fahrenheit)
                return "\(value)°F"
            }
        }()
        
        let view = UILabel()
        view.attributedText = temperature.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeWeatherKindLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.medium(size: 16.landscapeHScale))
            .textAlignment(.left)
            .lineBreakMode(.byTruncatingTail)
        
        let title: String = {
            switch weatherData.current.condition {
            case .clearSky:
                return "Navigator.Weather.Kind.ClearSky".localized
            case .fewClouds:
                return "Navigator.Weather.Kind.FewClouds".localized
            case .brokenClouds:
                return "Navigator.Weather.Kind.BrokenClouds".localized
            case .scatteredClouds:
                return "Navigator.Weather.Kind.ScatteredClouds".localized
            case .rain:
                return "Navigator.Weather.Kind.Rain".localized
            case .showerRain:
                return "Navigator.Weather.Kind.ShowerRain".localized
            case .mist:
                return "Navigator.Weather.Kind.Mist".localized
            case .snow:
                return "Navigator.Weather.Kind.Snow".localized
            case .thunderstorm:
                return "Navigator.Weather.Kind.Thunderstorm".localized
            }
        }()
        
        let view = UILabel()
        view.attributedText = title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let imageName: String = {
            let domain: String = {
                switch weatherData.current.condition {
                case .clearSky:
                    return "Navigator.Weather.ClearSky.Icon"
                case .fewClouds:
                    return "Navigator.Weather.FewClouds.Icon"
                case .brokenClouds:
                    return "Navigator.Weather.BrokenClouds.Icon"
                case .scatteredClouds:
                    return "Navigator.Weather.ScatteredClouds.Icon"
                case .rain:
                    return "Navigator.Weather.Rain.Icon"
                case .showerRain:
                    return "Navigator.Weather.ShowerRain.Icon"
                case .mist:
                    return "Navigator.Weather.Mist.Icon"
                case .snow:
                    return "Navigator.Weather.Snow.Icon"
                case .thunderstorm:
                    return "Navigator.Weather.Thunderstorm.Icon"
                }
            }()
            
            let isDay = Date.isDay(weatherData.current.date)
            
            return domain + (isDay ? ".Day" : ".Night")
        }()
        
        let view = UIImageView()
        view.image = UIImage(named: imageName)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
