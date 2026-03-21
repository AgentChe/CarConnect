//
//  WidgetCalendarConfiguration.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 05.03.2026.
//

import UIKit

struct WidgetCalendarConfiguration: Codable, Hashable {
    let style: WidgetCalendarStyle
    let background: WidgetBackground
    @CodableColor var fontColor: UIColor
    let font: WidgetsFonts
    
    static func `default`(for style: WidgetCalendarStyle) -> WidgetCalendarConfiguration {
        WidgetCalendarConfiguration(
            style: style,
            background: .gradient([
                CodableColor(wrappedValue: Appearance.color_373B47),
                CodableColor(wrappedValue: Appearance.color_2C2F39)
            ]),
            fontColor: Appearance.color_FFFFFF,
            font: WidgetsFonts.inter
        )
    }
}
