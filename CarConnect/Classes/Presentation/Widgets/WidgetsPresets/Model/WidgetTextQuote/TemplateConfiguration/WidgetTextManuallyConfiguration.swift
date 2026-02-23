//
//  WidgetTextManuallyConfiguration.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.02.2026.
//

import UIKit

struct WidgetTextManuallyConfiguration {
    enum Background {
        case fileUrl(String)
        case color(UIColor)
        case gradient([UIColor])
    }
    
    let background: Background
    let text: String
    let font: WidgetsFonts
    let textColor: UIColor
    
    // TODO: заменить шрифт
    static func `default`() -> WidgetTextManuallyConfiguration {
        WidgetTextManuallyConfiguration(
            background: .gradient([
                Appearance.color_4B4F5B,
                Appearance.color_2C2F39
            ]),
            text: "Roads are calling",
            font: .zenDots,
            textColor: Appearance.color_FFFFFF
        )
    }
}
