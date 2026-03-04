//
//  WidgetTextManuallyConfiguration.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.02.2026.
//

import UIKit

struct WidgetTextManuallyConfiguration: Codable, Hashable {
    let background: WidgetBackground
    let text: String
    let font: WidgetsFonts
    @CodableColor var textColor: UIColor
    
    static func `default`() -> WidgetTextManuallyConfiguration {
        WidgetTextManuallyConfiguration(
            background: .gradient([
                CodableColor(wrappedValue: Appearance.color_4B4F5B),
                CodableColor(wrappedValue: Appearance.color_2C2F39)
            ]),
            text: "Roads are calling",
            font: .inter,
            textColor: Appearance.color_FFFFFF
        )
    }
}
