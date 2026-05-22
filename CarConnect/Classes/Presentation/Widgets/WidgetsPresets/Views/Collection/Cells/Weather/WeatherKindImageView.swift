//
//  WeatherKindImageView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 18.03.2026.
//

import UIKit

final class WeatherKindImageView: UIImageView {
    func setup(icon: WeatherKind) {
        let iconName: String = {
            switch icon {
            case .clearSky:
                return "Weather.Icon.Sunny"
            case .rain, .showerRain, .thunderstorm:
                return "Weather.Icon.Rainy"
            case .snow:
                return "Weather.Icon.Snowy"
            case .fewClouds, .brokenClouds, .scatteredClouds:
                return "Weather.Icon.Cloudy"
            case .mist:
                return "Weather.Icon.Windy"
            }
        }()
        image = UIImage(named: iconName)
    }
    
    func setup(background: WeatherKind) {
        let iconName: String = {
            switch background {
            case .clearSky:
                return "Weather.Background.Sunny"
            case .rain, .showerRain, .thunderstorm:
                return "Weather.Background.Rainy"
            case .snow:
                return "Weather.Background.Snowy"
            case .fewClouds, .brokenClouds, .scatteredClouds:
                return "Weather.Background.Cloudy"
            case .mist:
                return "Weather.Background.Windy"
            }
        }()
        image = UIImage(named: iconName)
    }
}
