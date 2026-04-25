//
//  PhotoWidgetView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 04.04.2026.
//

import SwiftUI
import Photos

struct PhotoWidgetView: View {
    let configuration: WidgetPhotoConfiguration

    private let baseSide: CGFloat = 343

    var body: some View {
        GeometryReader { geo in
            let side = min(geo.size.width, geo.size.height)
            let scale = side / baseSide
            
            ZStack {
                LinearGradient(
                    stops: [
                        .init(color: Color(uiColor: Appearance.color_373B47), location: 0),
                        .init(color: Color(uiColor: Appearance.color_2C2F39), location: 1)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                backgroundView(size: geo.size)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipShape(RoundedRectangle(cornerRadius: 10 * scale))

            backgroundView(size: geo.size)
                
        }
    }
}

// MARK: - Private
private extension PhotoWidgetView {
    @ViewBuilder
    func backgroundView(size: CGSize) -> some View {
        switch configuration.photo {
        case .assetName(let name):
            if let uiImage = UIImage(named: name) {
                imageView(uiImage, size: size)
            } else {
                Color.clear
            }
            
        case .fileName(let name):
            if let uiImage = SharedImageFileStore.shared.loadDownsampledImage(
                fileName: name,
                size: size,
                scale: UIScreen.main.scale
            ) {
                imageView(uiImage, size: size)
            } else {
                Color.clear
            }
            
        case .photoAssetId:
            // Виджет игнорирует Photo Library background
            Color.clear
        }
    }
    
    func imageView(_ image: UIImage, size: CGSize) -> some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width, height: size.height)
            .clipped()
    }
}
