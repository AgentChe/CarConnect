//
//  AIPhotoWidgetView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.04.2026.
//

import SwiftUI
import Photos

struct AIPhotoWidgetView: View {
    let configuration: WidgetAIPhotoConfiguration

    private let baseSide: CGFloat = 343

    var body: some View {
        GeometryReader { geo in
            let side = min(geo.size.width, geo.size.height)
            let scale = side / baseSide

            backgroundView(size: geo.size)
                .clipShape(RoundedRectangle(cornerRadius: 10 * scale))
        }
    }
}

// MARK: - Private
private extension AIPhotoWidgetView {
    @ViewBuilder
    func backgroundView(size: CGSize) -> some View {
        if let image = SharedImageFileStore.shared.loadDownsampledImage(
            fileName: configuration.aiPreviewFileName,
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
    }
}
