//
//  TirePressureLockScreenView.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 21.01.2026.
//

import SwiftUI
import ActivityKit
import WidgetKit

struct TirePressureLockScreenView: View {
    let context: ActivityViewContext<TirePressureLiveActivityAttributes>
    let isMetric: Bool

    var body: some View {
        content
            .modifier(GradientBottomOverlayIfNeeded())
    }
    
    private var content: some View {
        HStack(alignment: .bottom) {
            VStack(spacing: 16) {
                WheelIndicatorCircle(value: context.state.fLeft, isMetric: isMetric, position: .frontLeft)
                WheelIndicatorCircle(value: context.state.bLeft, isMetric: isMetric, position: .backLeft)
            }
            .frame(maxHeight: .infinity)
            .padding(.vertical, 16)

            VStack(spacing: 24) {
                HStack(spacing: 4) {
                    Text(LocalizedStringKey("TirePressure"))
                        .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(Color.white)
                    
                    (Text("(") + Text(isMetric ? "LiveActivity.kpa".localized : "LiveActivity.psi".localized)) + Text(")")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.white.opacity(0.8))
                }
                
                Image("TirePressure.Car")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 108, height: 109)
                    .accessibilityHidden(true)
            }
            .frame(maxWidth: .infinity)

            VStack(spacing: 16) {
                WheelIndicatorCircle(value: context.state.fRight, isMetric: isMetric, position: .frontRight)
                WheelIndicatorCircle(value: context.state.bRight, isMetric: isMetric, position: .backRight)
            }
            .frame(maxHeight: .infinity)
            .padding(.vertical, 16)
        }
        .padding(.horizontal, 16)
    }
}

// MARK: WheelPosition
private enum WheelPosition {
    case frontLeft, backLeft, frontRight, backRight

    var arc: (centerAngle: Double, sweep: Double) {
        let sweep = 86.0

        switch self {
        case .frontLeft:
            return (centerAngle: 225.0, sweep: sweep)
        case .backLeft:
            return (centerAngle: 135.0, sweep: sweep)
        case .frontRight:
            return (centerAngle: 315.0, sweep: sweep)
        case .backRight:
            return (centerAngle: 45.0, sweep: sweep)
        }
    }
}

// MARK: WheelIndicatorCircle
private struct WheelIndicatorCircle: View {
    let value: Double?
    let isMetric: Bool
    let position: WheelPosition

    private let size = CGFloat(60)
    private let lineWidth = CGFloat(4)

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.16), lineWidth: lineWidth)

            WheelArcShape(
                startAngle: startAngle,
                endAngle: endAngle
            )
            .stroke(
                Color.white,
                style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
            )
            
            let valueDisplay: String = {
                guard let value else { return "-" }
                
                let metricValue = isMetric ? value : value * GlobalDefinitions.Metrics.psi
                return String(Int(metricValue))
            }()
            
            Text(valueDisplay)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)
        }
        .frame(width: size, height: size)
    }

    private var startAngle: Angle {
        let a = position.arc
        return .degrees(a.centerAngle - a.sweep / 2.0)
    }

    private var endAngle: Angle {
        let a = position.arc
        return .degrees(a.centerAngle + a.sweep / 2.0)
    }
}

// MARK: WheelArcShape
private struct WheelArcShape: Shape {
    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)

        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        return path
    }
}

// MARK: GradientBottomOverlayIfNeeded
private struct GradientBottomOverlayIfNeeded: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
        } else {
            content.overlay(alignment: .bottom) {
                LinearGradient(
                    colors: [Color.black.opacity(0.0), Color.black.opacity(1.0)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 16)
                .frame(maxWidth: .infinity)
                .allowsHitTesting(false)
            }
        }
    }
}
