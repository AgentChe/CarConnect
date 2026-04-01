//
//  WidgetClockAIPreviewConfiguration.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 01.04.2026.
//

import Foundation

struct WidgetClockAIPreviewConfiguration: Codable, Hashable {
    let url: URL
    let font: WidgetsFonts
    let textColor: CodableColor
    let timeFormat: TimeFormat
}

// MARK: Public
extension WidgetClockAIPreviewConfiguration {
    static func `default`(url: URL) -> WidgetClockAIPreviewConfiguration {
        WidgetClockAIPreviewConfiguration(
            url: url,
            font: WidgetsFonts.orbitron,
            textColor: CodableColor(wrappedValue: Appearance.color_FFFFFF),
            timeFormat: .twentyFourHour
        )
    }
}
