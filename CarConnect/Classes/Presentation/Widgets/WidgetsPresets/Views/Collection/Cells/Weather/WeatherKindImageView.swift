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
            case .sunny:
                return "Weather.Icon.Sunny"
            case .rainy:
                return "Weather.Icon.Rainy"
            case .snowy:
                return "Weather.Icon.Snowy"
            case .cloudy:
                return "Weather.Icon.Cloudy"
            case .windy:
                return "Weather.Icon.Windy"
            }
        }()
        image = UIImage(named: iconName)
    }
    
    func setup(background: WeatherKind) {
        let iconName: String = {
            switch background {
            case .sunny:
                return "Weather.Background.Sunny"
            case .rainy:
                return "Weather.Background.Rainy"
            case .snowy:
                return "Weather.Background.Snowy"
            case .cloudy:
                return "Weather.Background.Cloudy"
            case .windy:
                return "Weather.Background.Windy"
            }
        }()
        image = UIImage(named: iconName)
    }
}
