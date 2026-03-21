//
//  WidgetWeatherStyle.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 17.03.2026.
//

enum WidgetWeatherStyle: Codable, Hashable {
    case weatherIconTemperature // город + иконка погоды + температура
    case currentWeatherSummary // температура + как ощущается + состояние + краткий прогноз
    case locationTemperature // город + страна + крупная температура
    case compactWeatherForecast // текущая температура + компактный прогноз по дням
    case todayTomorrowWeather // сегодняшняя погода + короткий текст про завтра
    case weatherClock // время + дата + температура/иконка погоды
    case weatherConditionForecast // температура + текстовое состояние погоды + прогноз по дням
    case digitalWeatherClock // яркая карточка с today / temperature / digital clock.
}
