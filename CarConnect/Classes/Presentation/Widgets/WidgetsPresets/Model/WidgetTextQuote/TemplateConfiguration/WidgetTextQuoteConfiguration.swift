//
//  WidgetTextQuoteConfiguration.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.02.2026.
//

import UIKit

struct WidgetTextQuoteConfiguration {
    let font: WidgetsFonts
    let textColor: UIColor
    
    // TODO: заменить шрифт
    static func ambitionDriveDefault() -> WidgetTextQuoteConfiguration {
        WidgetTextQuoteConfiguration(
            font: .gravitasOne,
            textColor: Appearance.color_FFFFFF
        )
    }
    
    // TODO: заменить шрифт
    static func mindsetGrowthDefault() -> WidgetTextQuoteConfiguration {
        WidgetTextQuoteConfiguration(
            font: .caveatBrush,
            textColor: Appearance.color_FFFFFF
        )
    }
    
    // TODO: заменить шрифт
    static func leadershipImpactDefault() -> WidgetTextQuoteConfiguration {
        WidgetTextQuoteConfiguration(
            font: .bebasNeue,
            textColor: Appearance.color_FFFFFF
        )
    }
    
    // TODO: заменить шрифт
    static func lifeMeaningDefault() -> WidgetTextQuoteConfiguration {
        WidgetTextQuoteConfiguration(
            font: .dseg7Classic,
            textColor: Appearance.color_FFFFFF
        )
    }
}
