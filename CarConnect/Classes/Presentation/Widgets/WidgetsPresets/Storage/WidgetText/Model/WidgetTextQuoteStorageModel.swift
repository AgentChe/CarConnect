//
//  WidgetTextQuoteStorageModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.02.2026.
//

struct WidgetTextQuoteStorageModel: Codable, Hashable {
    let id: String
    let quote: WidgetTextQuote
    let configuration: WidgetTextQuoteConfiguration
}
