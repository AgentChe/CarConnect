//
//  TextManuallyWidgetView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 04.03.2026.
//

import SwiftUI

struct WidgetTextManuallyResultSwiftUIView: View {
    let configuration: WidgetTextManuallyConfiguration

    private let baseSide: CGFloat = 343

    var body: some View {
        GeometryReader { geo in
            let side  = min(geo.size.width, geo.size.height)
            let scale = side / baseSide

            ZStack {
                backgroundView(size: geo.size)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()

                Text(configuration.text)
                    .font(configuration.font.swiftUIFont(size: 40 * scale))
                    .foregroundStyle(Color(uiColor: configuration.textColor))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 20 * scale)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10 * scale))
        }
    }
}

// MARK: Private
private extension WidgetTextManuallyResultSwiftUIView {
    @ViewBuilder
    func backgroundView(size: CGSize) -> some View {
        switch configuration.background {
        case .color(let codableColor):
            Color(uiColor: codableColor.wrappedValue)
        case .gradient(let codableColors):
            LinearGradient(
                colors: codableColors.map { Color(uiColor: $0.wrappedValue) },
                startPoint: .top,
                endPoint: .bottom
            )
        case .fileName(let fileName):
            if let image = SharedImageFileStore.shared.loadDownsampledImage(
                fileName: fileName,
                size: size,
                scale: UIScreen.main.scale
            ) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipped()
            } else {
                Color.clear
            }
        case .photoAssetId:
            // Виджет игнорирует Photo Library background
            Color.clear
        }
    }
}
