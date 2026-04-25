//
//  WidgetClockStorageModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 25.03.2026.
//

struct WidgetClockStorageModel: Codable, Hashable {
    let id: String
    let name: String
    let configuration: WidgetClockConfiguration
}
