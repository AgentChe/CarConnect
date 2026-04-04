//
//  WidgetPhotoConfiguration.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 04.04.2026.
//

struct WidgetPhotoConfiguration: Codable, Hashable {
    let photo: WidgetPhoto
}

// MARK: Public
extension WidgetPhotoConfiguration {
    static func `default`() -> WidgetPhotoConfiguration {
        WidgetPhotoConfiguration(photo: WidgetPhoto.assetName("WidgetsPresents.Photo.Default"))
    }
}
