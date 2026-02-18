//
//  PowerProgressFill.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 23.01.2026.
//

import SwiftUI

struct PowerProgressFill: View {
    let value: Int
    var height: CGFloat = 32
    var radius: CGFloat? = nil
    var gradientColors: [Color] = [
        Color(hex: 0xFFFF4938),
        Color(hex: 0xFFFF8D28),
    ]

    var body: some View {
        let validValue = CGFloat(min(max(value, 0), 100)) / 100
        
        if validValue <= 0 {
            Color.clear.frame(height: height)
        } else {
            GeometryReader { geo in
                let w = geo.size.width * validValue

                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(glowColor.opacity(0.35))
                        .blur(radius: 12)
                        .allowsHitTesting(false)
                        .shadow(color: glowColor.opacity(0.45), radius: 9, x: 0, y: 0)
                        .shadow(color: glowColor.opacity(0.25), radius: 20, x: 0, y: 0)

                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(
                            LinearGradient(
                                stops: [
                                    .init(color: Color.white.opacity(0.18), location: 0.0),
                                    .init(color: Color.clear, location: 0.65),
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .allowsHitTesting(false)
                }
                .frame(width: w, height: height, alignment: .leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: height)
        }
    }
}

// MARK: Private
private extension PowerProgressFill {
    var cornerRadius: CGFloat {
        radius ?? height / 2
    }

    var glowColor: Color {
        let c1 = UIColor(gradientColors.first ?? .clear)
        let c2 = UIColor(gradientColors.last ?? .clear)
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        c1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        c2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        return Color(
            red: Double((r1 + r2) * 0.5),
            green: Double((g1 + g2) * 0.5),
            blue: Double((b1 + b2) * 0.5),
            opacity: Double((a1 + a2) * 0.5)
        )
    }
}
