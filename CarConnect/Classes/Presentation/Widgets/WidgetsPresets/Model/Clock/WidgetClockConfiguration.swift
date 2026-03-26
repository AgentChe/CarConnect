//
//  WidgetClockConfiguration.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 25.03.2026.
//

import UIKit

struct WidgetClockConfiguration: Codable, Hashable {
    let style: WidgetClockStyle
    let background: WidgetBackground
    let font: WidgetsFonts
    let textColor: CodableColor
    let timeFormat: TimeFormat
}

// MARK: Public
extension WidgetClockConfiguration {
    static func `default`(for style: WidgetClockStyle) -> WidgetClockConfiguration {
        WidgetClockConfiguration(
            style: style,
            background: .gradient([
                CodableColor(wrappedValue: Appearance.color_373B47),
                CodableColor(wrappedValue: Appearance.color_2C2F39)
            ]),
            font: WidgetsFonts.orbitron,
            textColor: CodableColor(wrappedValue: Appearance.color_FFFFFF),
            timeFormat: .twentyFourHour
        )
    }
}
