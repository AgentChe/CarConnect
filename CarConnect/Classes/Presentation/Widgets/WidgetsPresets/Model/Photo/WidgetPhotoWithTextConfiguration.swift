//
//  WidgetPhotoWithTextConfiguration.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 04.04.2026.
//

struct WidgetPhotoWithTextConfiguration: Hashable, Codable {
    let photo: WidgetPhoto
    let text: String
    let font: WidgetsFonts
    let textColor: CodableColor
}

// MARK: Public
extension WidgetPhotoWithTextConfiguration {
    static func `default`() -> WidgetPhotoWithTextConfiguration {
        WidgetPhotoWithTextConfiguration(
            photo: WidgetPhoto.assetName("WidgetsPresents.PhotoWithText.Default"),
            text: "Photo from the trip",
            font: WidgetsFonts.inter,
            textColor: CodableColor(wrappedValue: Appearance.color_FFFFFF)
        )
    }
}
