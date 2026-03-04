//
//  PhotoAssetImageLoader.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 04.03.2026.
//

import Photos
import UIKit

final class PhotoAssetImageLoader {
    static let shared = PhotoAssetImageLoader()
    
    private init() {}
}

// MARK: Public
extension PhotoAssetImageLoader {
    @discardableResult
    func loadImage(
        assetId: String,
        targetSize: CGSize = PHImageManagerMaximumSize,
        contentMode: PHImageContentMode = .aspectFill,
        completion: @escaping (_ image: UIImage?) -> Void
    ) -> PHImageRequestID {
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
        guard let asset = assets.firstObject else {
            DispatchQueue.main.async { completion(nil) }
            return PHInvalidImageRequestID
        }

        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true          
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .none
        options.version = .current

        let requestId = PHImageManager.default().requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: contentMode,
            options: options
        ) { image, _ in
            DispatchQueue.main.async { completion(image) }
        }

        return requestId
    }

    func cancel(_ requestId: PHImageRequestID) {
        guard requestId != PHInvalidImageRequestID else { return }
        PHImageManager.default().cancelImageRequest(requestId)
    }
}
