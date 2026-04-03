//
//  WidgetCarLogoConfiguration.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 02.04.2026.
//

import Foundation

struct WidgetCarLogoConfiguration: Codable, Hashable {
    let brand: WidgetCarLogoBrand
    let background: WidgetBackground
}

// MARK: Public
extension WidgetCarLogoConfiguration {
    static func `default`(brand: WidgetCarLogoBrand) -> WidgetCarLogoConfiguration {
        WidgetCarLogoConfiguration(
            brand: brand,
            background: .gradient([
                CodableColor(wrappedValue: Appearance.color_373B47),
                CodableColor(wrappedValue: Appearance.color_2C2F39)
            ]),
        )
    }
}
