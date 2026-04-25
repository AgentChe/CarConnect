//
//  CarLogoWidgetView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.04.2026.
//

import SwiftUI
import Photos

struct CarLogoWidgetView: View {
    let configuration: WidgetCarLogoConfiguration

    private let baseSide: CGFloat = 343

    var body: some View {
        GeometryReader { geo in
            let side = min(geo.size.width, geo.size.height)
            let scale = side / baseSide

            ZStack {
                backgroundView(size: geo.size)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                
                logoView(size: geo.size)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10 * scale))
        }
    }
}

// MARK: - Private
private extension CarLogoWidgetView {
    @ViewBuilder
    func logoView(size: CGSize) -> some View {
        if let image = SharedImageFileStore.shared.loadImage(url: configuration.brand.logo) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width, height: size.height)
                .clipped()
        } else {
            Color.clear
        }
    }
    
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
