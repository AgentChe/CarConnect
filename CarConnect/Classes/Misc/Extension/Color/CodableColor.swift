//
//  CodableColor.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.02.2026.
//

import UIKit

@propertyWrapper
struct CodableColor: Codable {
    var wrappedValue: UIColor

    init(wrappedValue: UIColor) {
        self.wrappedValue = wrappedValue
    }

    init(from decoder: Decoder) throws {
        let rgba = try RGBA(from: decoder)
        wrappedValue = UIColor(
            red: CGFloat(rgba.r),
            green: CGFloat(rgba.g),
            blue: CGFloat(rgba.b),
            alpha: CGFloat(rgba.a)
        )
    }

    func encode(to encoder: Encoder) throws {
        try RGBA(from: wrappedValue).encode(to: encoder)
    }

    private struct RGBA: Codable {
        let r: Double, g: Double, b: Double, a: Double

        init?(from color: UIColor) throws {
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            
            guard color.getRed(&r, green: &g, blue: &b, alpha: &a) else {
                throw EncodingError.invalidValue(color, .init(codingPath: [], debugDescription: "Unsupported UIColor color space (non-RGB)."))
            }
            
            self.r = Double(r); self.g = Double(g); self.b = Double(b); self.a = Double(a)
        }
    }
}
