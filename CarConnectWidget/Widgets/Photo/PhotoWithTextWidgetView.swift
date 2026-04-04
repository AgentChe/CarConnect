//
//  PhotoWithTextWidgetView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 04.04.2026.
//

//
//  PhotoWithTextWidgetView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 04.04.2026.
//

import SwiftUI
import Photos

struct PhotoWithTextWidgetView: View {
    enum Metrics {
        case small
        case large
        
        var designSize: CGSize {
            switch self {
            case .small:
                return CGSize(width: 165, height: 165)
            case .large:
                return CGSize(width: 343, height: 343)
            }
        }
        
        var baseFontSize: CGFloat {
            switch self {
            case .small: return 20
            case .large: return 40
            }
        }
        
        var baseHorizontalInset: CGFloat {
            switch self {
            case .small: return 12
            case .large: return 24
            }
        }
        
        var baseBottomInset: CGFloat {
            switch self {
            case .small: return 12
            case .large: return 24
            }
        }
        
        var baseCornerRadius: CGFloat { 10 }
    }
    
    let configuration: WidgetPhotoWithTextConfiguration
    let metrics: Metrics = Metrics.large
    
    var body: some View {
        GeometryReader { geo in
            let designSize = metrics.designSize
            let scale = min(
                geo.size.width / designSize.width,
                geo.size.height / designSize.height
            )
            
            ZStack {
                backgroundView(size: geo.size)
                
                LinearGradient(
                    stops: [
                        .init(color: Color(uiColor: Appearance.color_2E2E2E).opacity(0), location: 0),
                        .init(color: Color(uiColor: Appearance.color_242424).opacity(0.4), location: 1)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                textView(scale: scale)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipShape(
                RoundedRectangle(cornerRadius: metrics.baseCornerRadius * scale)
            )
        }
    }
}

// MARK: - Private
private extension PhotoWithTextWidgetView {
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
    
    func textView(scale: CGFloat) -> some View {
        Text(configuration.text)
            .font(configuration.font.swiftUIFont(size: metrics.baseFontSize * scale))
            .foregroundStyle(Color(uiColor: configuration.textColor.wrappedValue))
            .multilineTextAlignment(.leading)
            .lineLimit(nil)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding(.horizontal, metrics.baseHorizontalInset * scale)
            .padding(.bottom, metrics.baseBottomInset * scale)
    }
}
