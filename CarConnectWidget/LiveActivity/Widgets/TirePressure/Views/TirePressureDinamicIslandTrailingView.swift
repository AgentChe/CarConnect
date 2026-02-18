//
//  TirePressureDinamicIslandTrailingView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 23.01.2026.
//

import SwiftUI
import ActivityKit
import WidgetKit

struct TirePressureDinamicIslandTrailingView: View {
    let context: ActivityViewContext<TirePressureLiveActivityAttributes>
    let isMetric: Bool
    
    private let cornerRadius = CGFloat(999)
    private let lineWidth = CGFloat(4)

    var body: some View {
        Text(valuesString)
            .font(.system(size: 16, weight: .medium, design: .rounded))
            .foregroundStyle(.white)
            .lineLimit(1)
            .allowsTightening(true)
            .minimumScaleFactor(0.45)
            .padding(.horizontal, 8)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.16), lineWidth: lineWidth)
            )
            .overlay(
                CornerArcHighlightsShape(cornerRadius: cornerRadius)
                    .strokeBorder(
                        Color.white,
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round)
                    )
            )
    }

    private var valuesString: String {
        func formatValue(_ value: Double?) -> String {
            guard let value else { return "-" }
            
            let metricValue = isMetric ? value : value * GlobalDefinitions.Metrics.psi
            return String(Int(metricValue))
        }

        let state = context.state
        return "\(formatValue(state.fLeft)),\(formatValue(state.fRight)),\(formatValue(state.bLeft)),\(formatValue(state.bRight))"
    }
}

// MARK: CornerArcHighlightsShape
private struct CornerArcHighlightsShape: InsettableShape {
    var cornerRadius: CGFloat
    var straightLength = CGFloat(8)
    var arcDegrees = CGFloat(32)
    var insetAmount: CGFloat = 0

    func inset(by amount: CGFloat) -> some InsettableShape {
        var copy = self
        copy.insetAmount += amount
        return copy
    }

    func path(in rect: CGRect) -> Path {
        let rect = rect.insetBy(dx: insetAmount, dy: insetAmount)
        let w = rect.width
        let h = rect.height

        let r = min(cornerRadius, min(w, h) / 2)
        guard r > 0 else { return Path() }

        let minX = rect.minX, maxX = rect.maxX
        let minY = rect.minY, maxY = rect.maxY

        let straightTop = max(0, w - 2 * r)
        let s = min(max(0, straightLength), straightTop)

        let d = max(0, min(arcDegrees, 80))

        let cTL = CGPoint(x: minX + r, y: minY + r)
        let cTR = CGPoint(x: maxX - r, y: minY + r)
        let cBL = CGPoint(x: minX + r, y: maxY - r)
        let cBR = CGPoint(x: maxX - r, y: maxY - r)

        var p = Path()

        if s > 0 {
            p.move(to: CGPoint(x: minX + r + s, y: minY))
            p.addLine(to: CGPoint(x: minX + r, y: minY))
        } else {
            p.move(to: CGPoint(x: minX + r, y: minY))
        }
        p.addArc(center: cTL, radius: r,
                 startAngle: .degrees(-90),
                 endAngle: .degrees(-90 - d),
                 clockwise: true)

        if s > 0 {
            p.move(to: CGPoint(x: maxX - r - s, y: minY))
            p.addLine(to: CGPoint(x: maxX - r, y: minY))
        } else {
            p.move(to: CGPoint(x: maxX - r, y: minY))
        }
        p.addArc(center: cTR, radius: r,
                 startAngle: .degrees(-90),
                 endAngle: .degrees(-90 + d),
                 clockwise: false)

        if s > 0 {
            p.move(to: CGPoint(x: minX + r + s, y: maxY))
            p.addLine(to: CGPoint(x: minX + r, y: maxY))
        } else {
            p.move(to: CGPoint(x: minX + r, y: maxY))
        }
        p.addArc(center: cBL, radius: r,
                 startAngle: .degrees(90),
                 endAngle: .degrees(90 + d),
                 clockwise: false)

        if s > 0 {
            p.move(to: CGPoint(x: maxX - r - s, y: maxY))
            p.addLine(to: CGPoint(x: maxX - r, y: maxY))
        } else {
            p.move(to: CGPoint(x: maxX - r, y: maxY))
        }
        p.addArc(center: cBR, radius: r,
                 startAngle: .degrees(90),
                 endAngle: .degrees(90 - d),
                 clockwise: true)

        return p
    }
}
