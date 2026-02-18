//
//  PowerProgressBar.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 23.01.2026.
//

import SwiftUI

struct PowerProgressBar: View {
    let value: Int
    let isWarningLevel: Bool
    let isDangerLevel: Bool

    var height: CGFloat = 32

    var body: some View {
        ZStack {
            StripedIndicatorBar(height: height)

            PowerProgressFill(
                value: value,
                height: height,
                gradientColors: gradientColors
            )
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
    }
}

// MARK: Private
private extension PowerProgressBar {
    var gradientColors: [Color] {
        if isDangerLevel {
            return [Color(hex: 0xFFF75559), Color(hex: 0xFFFF383C)]
        } else if isWarningLevel {
            return [Color(hex: 0xFFFF4938), Color(hex: 0xFFFF8D28)]
        } else {
            return [Color(hex: 0xFF34C759), Color(hex: 0xFF3CE273)]
        }
    }
}
