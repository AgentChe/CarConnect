//
//  WidgetTextQuoteStorageModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.02.2026.
//

import Foundation

struct WidgetTextQuoteStorageModel: Codable {
    let id: String
    let quote: WidgetTextQuote
    let configuration: WidgetTextQuoteConfiguration
}
