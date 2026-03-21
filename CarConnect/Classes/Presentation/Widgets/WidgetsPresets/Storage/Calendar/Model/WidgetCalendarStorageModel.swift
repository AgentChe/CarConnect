//
//  WidgetCalendarStorageModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 05.03.2026.
//

struct WidgetCalendarStorageModel: Codable, Hashable {
    let id: String
    let name: String
    let configuration: WidgetCalendarConfiguration
}
