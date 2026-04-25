//
//  PhotoCarouselWidgetView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 05.04.2026.
//

import SwiftUI
import Photos

struct PhotoCarouselSwiftUIView: View {
    enum Metrics {
        case small
        case large
    }

    let configuration: WidgetPhotoCarouselConfiguration
    let metrics: Metrics = .large

    private let smallDesignSize = CGSize(width: 165, height: 165)
    private let largeDesignSize = CGSize(width: 343, height: 343)

    var body: some View {
        GeometryReader { geo in
            let designSize = metrics == .small ? smallDesignSize : largeDesignSize
            let scale = min(
                geo.size.width / designSize.width,
                geo.size.height / designSize.height
            )

            ZStack {
                backgroundPhoto(size: geo.size)
                blurredOverlay(size: geo.size, scale: scale)

                cardsLayer(scale: scale)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipShape(RoundedRectangle(cornerRadius: 10 * scale))
        }
    }
}

// MARK: - Private
private extension PhotoCarouselSwiftUIView {
    var sidePhotoWidth: CGFloat {
        switch metrics {
        case .small: return 86
        case .large: return 178
        }
    }

    var sidePhotoHeight: CGFloat {
        switch metrics {
        case .small: return 109
        case .large: return 225
        }
    }

    var centerPhotoWidth: CGFloat {
        switch metrics {
        case .small: return 132
        case .large: return 273
        }
    }

    var centerPhotoHeight: CGFloat {
        switch metrics {
        case .small: return 141
        case .large: return 293
        }
    }

    var horizontalSpacing: CGFloat {
        switch metrics {
        case .small: return 4
        case .large: return 8
        }
    }

    var cardCornerRadius: CGFloat {
        switch metrics {
        case .small: return 4
        case .large: return 8
        }
    }

    @ViewBuilder
    func backgroundPhoto(size: CGSize) -> some View {
        photoView(configuration.photo2, size: size)
    }

    @ViewBuilder
    func blurredOverlay(size: CGSize, scale: CGFloat) -> some View {
        photoView(configuration.photo2, size: size)
            .blur(radius: 12 * scale)
            .overlay(
                Color.white.opacity(0.18)
            )
    }

    @ViewBuilder
    func cardsLayer(scale: CGFloat) -> some View {
        let sideWidth = sidePhotoWidth * scale
        let sideHeight = sidePhotoHeight * scale
        let centerWidth = centerPhotoWidth * scale
        let centerHeight = centerPhotoHeight * scale
        let spacing = horizontalSpacing * scale
        let sideOffset = (centerWidth / 2) + (sideWidth / 2) + spacing

        ZStack {
            ShadowPhotoCard(
                content: {
                    photoView(
                        configuration.photo1,
                        size: CGSize(width: sideWidth, height: sideHeight)
                    )
                },
                cornerRadius: cardCornerRadius * scale,
                shadowRadius: 8 * scale,
                shadowYOffset: 2 * scale
            )
            .frame(width: sideWidth, height: sideHeight)
            .offset(x: -sideOffset)

            ShadowPhotoCard(
                content: {
                    photoView(
                        configuration.photo2,
                        size: CGSize(width: centerWidth, height: centerHeight)
                    )
                },
                cornerRadius: cardCornerRadius * scale,
                shadowRadius: 8 * scale,
                shadowYOffset: 2 * scale
            )
            .frame(width: centerWidth, height: centerHeight)

            ShadowPhotoCard(
                content: {
                    photoView(
                        configuration.photo3,
                        size: CGSize(width: sideWidth, height: sideHeight)
                    )
                },
                cornerRadius: cardCornerRadius * scale,
                shadowRadius: 8 * scale,
                shadowYOffset: 2 * scale
            )
            .frame(width: sideWidth, height: sideHeight)
            .offset(x: sideOffset)
        }
    }

    @ViewBuilder
    func photoView(_ photo: WidgetPhoto, size: CGSize) -> some View {
        switch photo {
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

private struct ShadowPhotoCard<Content: View>: View {
    let content: () -> Content
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    let shadowYOffset: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.clear)
                .shadow(
                    color: .black.opacity(0.12),
                    radius: shadowRadius,
                    x: 0,
                    y: shadowYOffset
                )

            content()
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
}
