//
//  WidgetPhoto.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 04.04.2026.
//

enum WidgetPhoto: Hashable, Codable {
    case assetName(String)
    case fileName(String)
    case photoAssetId(String)
}
