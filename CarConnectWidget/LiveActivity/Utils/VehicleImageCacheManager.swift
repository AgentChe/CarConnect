//
//  VehicleImageCacheManager.swift
//  Runner
//
//  Created by Андрей Чернышев on 19.01.2026.
//

import Foundation
import UIKit

final class VehicleImageCacheManager {
    static let shared = VehicleImageCacheManager()

    private let folderName = "live_activity_vehicle_images"

    private init() {}
}

// MARK: Public
extension VehicleImageCacheManager {
    enum CacheError: LocalizedError {
        case badURL
        case badHTTPStatus(Int)
        case notAnImage
        case encodeFailed
        case noAppGroupContainer(String)
    }
    
    func cacheIfNeeded(vehicleId: String, urlString: String?) async -> Result<URL?, Error> {
        guard let urlString, !urlString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return .success(nil)
        }
        
        guard let url = URL(string: urlString) else {
            return .failure(CacheError.badURL)
        }

        do {
            let container = try AppGroupStore.shared.appGroupContainerURL()
            let folder = container.appendingPathComponent(folderName, isDirectory: true)
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)

            let fileURL = cachedImageFileURL(folder: folder, vehicleId: vehicleId)

            if FileManager.default.fileExists(atPath: fileURL.path) {
                return .success(fileURL)
            }

            var request = URLRequest(url: url)
            request.timeoutInterval = 20

            let (data, response) = try await URLSession.shared.data(for: request)

            if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                return .failure(CacheError.badHTTPStatus(http.statusCode))
            }

            guard let image = UIImage(data: data) else {
                return .failure(CacheError.notAnImage)
            }

            guard let png = image.pngData() else {
                return .failure(CacheError.encodeFailed)
            }
            try png.write(to: fileURL, options: [.atomic])

            return .success(fileURL)
        } catch {
            return .failure(error)
        }
    }

    func cachedImageURL(vehicleId: String) -> URL? {
        do {
            let container = try AppGroupStore.shared.appGroupContainerURL()
            let folder = container.appendingPathComponent(folderName, isDirectory: true)
            let fileURL = cachedImageFileURL(folder: folder, vehicleId: vehicleId)
            return FileManager.default.fileExists(atPath: fileURL.path) ? fileURL : nil
        } catch {
            return nil
        }
    }

    func removeCachedImage(vehicleId: String) {
        guard let url = cachedImageURL(vehicleId: vehicleId) else { return }
        try? FileManager.default.removeItem(at: url)
    }
}

// MARK: Private
private extension VehicleImageCacheManager {
    func cachedImageFileURL(folder: URL, vehicleId: String) -> URL {
        let safeId = vehicleId
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: ":", with: "_")

        return folder.appendingPathComponent("vehicle_\(safeId).png", isDirectory: false)
    }
}
