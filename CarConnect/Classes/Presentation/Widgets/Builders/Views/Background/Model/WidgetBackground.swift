//
//  WidgetBackground.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.03.2026.
//

enum WidgetBackground: Codable, Hashable {
    case fileName(String)
    case color(CodableColor)
    case gradient([CodableColor])
    case photoAssetId(String)
    
    func isEqual(another: WidgetBackground) -> Bool {
        switch (self, another) {
        case (.fileName(let l), .fileName(let r)):
            return l == r
        case (.photoAssetId(let l), .photoAssetId(let r)):
            return l == r
        case (.color(let l), .color(let r)):
            return l.wrappedValue.isEqualTo(r.wrappedValue)
        case (.gradient(let l), .gradient(let r)):
            guard l.count == r.count else { return false }
            return zip(l, r).allSatisfy { $0.wrappedValue.isEqualTo($1.wrappedValue) }
        default:
            return false
        }
    }
}
