//
//  WidgetTextQuote.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.02.2026.
//

enum WidgetTextQuote: Codable, Hashable {
    case ambitionDrive(WidgetTextQuoteAmbitionDrive)
    case mindsetGrowth(WidgetTextQuoteMindsetGrowth)
    case leadershipImpact(WidgetTextQuoteLeadershipImpact)
    case lifeMeaning(WidgetTextQuoteLifeMeaning)
}
