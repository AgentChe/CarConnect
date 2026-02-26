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
    
    static func ambitionDriveDefault() -> WidgetTextQuoteConfiguration {
        WidgetTextQuoteConfiguration(
            font: .inter,
            textColor: Appearance.color_FFFFFF
        )
    }
    
    static func mindsetGrowthDefault() -> WidgetTextQuoteConfiguration {
        WidgetTextQuoteConfiguration(
            font: .abrilFatface,
            textColor: Appearance.color_FFFFFF
        )
    }
    
    static func leadershipImpactDefault() -> WidgetTextQuoteConfiguration {
        WidgetTextQuoteConfiguration(
            font: .georgia,
            textColor: Appearance.color_FFFFFF
        )
    }
    
    static func lifeMeaningDefault() -> WidgetTextQuoteConfiguration {
        WidgetTextQuoteConfiguration(
            font: .playfairDisplay,
            textColor: Appearance.color_FFFFFF
        )
    }
}
