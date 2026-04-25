//
//  WidgetPhotoStorageModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 04.04.2026.
//

struct WidgetPhotoStorageModel: Codable, Hashable {
    let id: String
    let name: String
    let configuration: WidgetPhotoConfiguration
}
