//
//  StripedIndicatorBar.swift
//  CarConnectWidgetExtension
//
//  Created by Андрей Чернышев on 23.01.2026.
//

import SwiftUI

struct StripedIndicatorBar: View {
    var height: CGFloat = 32

    var backgroundColor: Color = Color(hex: 0xFF2C2C2E)
    var stripeColor: Color = Color(hex: 0xFF1C1C1E)
    var backgroundOpacity: Double = 0.35
    var stripeOpacity: Double = 0.55

    var stripeWidth: CGFloat = 6
    var stripeGap: CGFloat = 6
    var angleDegrees: Double = -25

    var body: some View {
        Canvas { context, size in
            let rect = CGRect(origin: .zero, size: size)

            context.fill(
                Path(rect),
                with: .color(backgroundColor.opacity(backgroundOpacity))
            )

            let w = size.width
            let h = size.height
            let diag = sqrt(w * w + h * h)

            let startX = -diag
            let endX = w + diag
            let topY = -diag
            let fullH = diag * 2

            let step = stripeWidth + stripeGap
            let angle = Angle.degrees(angleDegrees)

            context.drawLayer { layer in
                layer.translateBy(x: w / 2, y: h / 2)
                layer.rotate(by: angle)
                layer.translateBy(x: -w / 2, y: -h / 2)

                var x = startX
                while x < endX {
                    let r = CGRect(x: x, y: topY, width: stripeWidth, height: fullH)
                    layer.fill(Path(r), with: .color(stripeColor.opacity(stripeOpacity)))
                    x += step
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: height / 2, style: .continuous))
    }
}
