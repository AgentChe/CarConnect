//
//  WidgetWeatherStorageModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 18.03.2026.
//

struct WidgetWeatherStorageModel: Codable, Hashable {
    let id: String
    let name: String
    let configuration: WidgetWeatherConfiguration
}
