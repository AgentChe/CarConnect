//
//  WidgetPhotoCarouselConfiguration.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 05.04.2026.
//

struct WidgetPhotoCarouselConfiguration: Codable, Hashable {
    let photo1: WidgetPhoto
    let photo2: WidgetPhoto
    let photo3: WidgetPhoto
}

// MARK: Public
extension WidgetPhotoCarouselConfiguration {
    static func `default`() -> WidgetPhotoCarouselConfiguration {
        WidgetPhotoCarouselConfiguration(
            photo1: WidgetPhoto.assetName("WidgetsPresents.PhotoCarousel.Default1"),
            photo2: WidgetPhoto.assetName("WidgetsPresents.PhotoCarousel.Default2"),
            photo3: WidgetPhoto.assetName("WidgetsPresents.PhotoCarousel.Default3")
        )
    }
}
