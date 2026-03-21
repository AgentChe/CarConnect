//
//  WidgetWeatherConfiguration.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 17.03.2026.
//

import UIKit

struct WidgetWeatherConfiguration: Codable, Hashable {
    let style: WidgetWeatherStyle
    let font: WidgetsFonts
    @CodableColor var textColor: UIColor
    let timeFormat: TimeFormat
    let location: Location
    let temperatureType: TemperatureType
    
    static func `default`(for style: WidgetWeatherStyle) -> WidgetWeatherConfiguration {
        let textColor: UIColor = {
            switch style {
            case .digitalWeatherClock:
                return Appearance.color_000000
            default:
                return Appearance.color_FFFFFF
            }
        }()
        
        return WidgetWeatherConfiguration(
            style: style,
            font: WidgetsFonts.inter,
            textColor: textColor,
            timeFormat: TimeFormat.twentyFourHour,
            location: Location.newYork(),
            temperatureType: TemperatureType.celsius
        )
    }
}
