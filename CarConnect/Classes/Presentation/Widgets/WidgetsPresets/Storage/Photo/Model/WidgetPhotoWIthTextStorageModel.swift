//
//  WidgetPhotoWIthTextStorageModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 04.04.2026.
//

struct WidgetPhotoWithTextStorageModel: Codable, Hashable {
    let id: String
    let name: String
    let configuration: WidgetPhotoWithTextConfiguration
}
