//
//  AIPhotoMyCarWidgetView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 05.04.2026.
//

import SwiftUI
import Photos

struct AIPhotoMyCarWidgetView: View {
    let configuration: WidgetAIPhotoMyCarConfiguration

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
private extension AIPhotoMyCarWidgetView {
    @ViewBuilder
    func backgroundView(size: CGSize) -> some View {
        if let image = SharedImageFileStore.shared.loadImage(url: configuration.url) {
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
