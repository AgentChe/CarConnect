//
//  UIColorExtension.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit
import SwiftUI

extension UIColor {
    convenience init(integralRed red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }

    func isEqualTo(_ other: UIColor, epsilon: CGFloat = 0.001) -> Bool {
        func rgbaSRGB(_ color: UIColor) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)? {
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            
            guard color.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
            
            return (r, g, b, a)
        }
        
        guard let c1 = rgbaSRGB(self), let c2 = rgbaSRGB(other) else { return false }
        
        return abs(c1.r - c2.r) <= epsilon &&
               abs(c1.g - c2.g) <= epsilon &&
               abs(c1.b - c2.b) <= epsilon &&
               abs(c1.a - c2.a) <= epsilon
    }
}

extension Color {
    init(hex: UInt32) {
        let a = Double((hex >> 24) & 0xFF) / 255.0
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8)  & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}
