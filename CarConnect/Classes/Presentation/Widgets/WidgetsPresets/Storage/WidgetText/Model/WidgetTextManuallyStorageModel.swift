//
//  WidgetTextManuallyStorageModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 04.03.2026.
//

struct WidgetTextManuallyStorageModel: Codable, Hashable {
    let id: String
    let name: String
    let configuration: WidgetTextManuallyConfiguration
}
