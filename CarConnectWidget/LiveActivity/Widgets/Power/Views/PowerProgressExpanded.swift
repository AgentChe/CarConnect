//
//  PowerProgressExpanded.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 23.01.2026.
//

import SwiftUI

struct PowerProgressExpanded: View {
    let state: PowerLiveActivityAttributes.ContentState
    
    private let cornerRadius = CGFloat(999)
    private let lineWidth = CGFloat(4)

    private var progress: CGFloat {
        let p = CGFloat(state.powerPercent ?? 0) / 100.0
        return min(max(p, 0), 1)
    }

    var body: some View {
        PowerCompactProgressText(state: state)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color.clear)
            )
            // базовая полупрозрачная обводка
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.16), lineWidth: lineWidth)
            )
            // прогресс поверх (старт сверху по центру, по часовой)
            .overlay(
                CapsuleTopCenterPerimeter()
                    .inset(by: lineWidth / 2) // чтобы совпало со strokeBorder
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing),
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round)
                    )
                    .animation(.easeInOut(duration: 0.25), value: progress)
            )
    }
}

// MARK: Private
private extension PowerProgressExpanded {
    var gradientColors: [Color] {
        if state.isDangerLevel {
            return [Color(hex: 0xFFF75559), Color(hex: 0xFFFF383C)]
        } else if state.isWarningLevel {
            return [Color(hex: 0xFFFF4938), Color(hex: 0xFFFF8D28)]
        } else {
            return [Color(hex: 0xFF34C759), Color(hex: 0xFF3CE273)]
        }
    }
}

/// Периметр капсулы со стартом в (midX, minY) и обходом по часовой стрелке.
/// Корнер-радиус берём как min(width, height) / 2 — то, что получается при cornerRadius=999.
private struct CapsuleTopCenterPerimeter: InsettableShape {
    var insetAmount: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        let r = rect.insetBy(dx: insetAmount, dy: insetAmount)
        let radius = min(r.width, r.height) / 2

        let topY = r.minY
        let bottomY = r.maxY
        let midX = r.midX
        let leftX = r.minX + radius
        let rightX = r.maxX - radius
        let midY = r.midY

        var p = Path()
        // старт сверху по центру
        p.move(to: CGPoint(x: midX, y: topY))

        // верхняя прямая до правого "скругления"
        p.addLine(to: CGPoint(x: rightX, y: topY))

        // правая полуокружность сверху вниз (по часовой)
        p.addArc(
            center: CGPoint(x: rightX, y: midY),
            radius: radius,
            startAngle: .degrees(-90),
            endAngle: .degrees(90),
            clockwise: false
        )

        // нижняя прямая до левого "скругления"
        p.addLine(to: CGPoint(x: leftX, y: bottomY))

        // левая полуокружность снизу вверх (по часовой)
        p.addArc(
            center: CGPoint(x: leftX, y: midY),
            radius: radius,
            startAngle: .degrees(90),
            endAngle: .degrees(270),
            clockwise: false
        )

        // верхняя прямая обратно к старту (в середину)
        p.addLine(to: CGPoint(x: midX, y: topY))
        return p
    }

    func inset(by amount: CGFloat) -> CapsuleTopCenterPerimeter {
        var s = self
        s.insetAmount += amount
        return s
    }
}
