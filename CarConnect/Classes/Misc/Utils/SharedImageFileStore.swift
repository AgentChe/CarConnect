//
//  SharedImageFileStore.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 04.03.2026.
//

import UIKit
import ImageIO
import MobileCoreServices

final class SharedImageFileStore {
    enum Constants {
        static let folderName = "widget_background_images"
    }
    
    enum Format {
        case png
        case jpeg(quality: CGFloat)
    }
    
    static let shared = SharedImageFileStore()

    private init() {}
}

// MARK: Public
extension SharedImageFileStore {
    func save(image: UIImage, format: Format = .jpeg(quality: 0.9)) -> String? {
        guard let folder = sharedFolderURL() else { return nil }

        let (data, fileExtension): (Data, String) = {
            switch format {
            case .png:
                return (image.pngData() ?? Data(), "png")
            case .jpeg(let quality):
                let q = max(0.0, min(1.0, quality))
                return (image.jpegData(compressionQuality: q) ?? Data(), "jpg")
            }
        }()

        guard !data.isEmpty else { return nil }

        let baseNameSafe = makeSafeFileBaseName(UUID().uuidString)
        
        guard !baseNameSafe.isEmpty else { return nil }

        let fileName = "\(baseNameSafe).\(fileExtension)"
        let fileURL = folder.appendingPathComponent(fileName, isDirectory: false)

        do {
            try data.write(to: fileURL, options: [.atomic])
        } catch {
            return nil
        }

        return fileName
    }

    func loadImage(fileName: String) -> UIImage? {
        guard let url = fileURL(for: fileName), let data = try? Data(contentsOf: url) else { return nil }
        
        return UIImage(data: data)
    }
    
    func loadDownsampledImage(fileName: String, size: CGSize, scale: CGFloat) -> UIImage? {
        guard let url = fileURL(for: fileName) else { return nil }

        let maxDimension = max(size.width, size.height) * scale

        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else { return nil }

        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: Int(maxDimension)
        ]

        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else { return nil }

        return UIImage(cgImage: cgImage)
    }

    func removeImage(fileName: String) {
        guard let url = fileURL(for: fileName), FileManager.default.fileExists(atPath: url.path) else { return }
        
        try? FileManager.default.removeItem(at: url)
    }
}

// MARK: Private
private extension SharedImageFileStore {
    func fileURL(for fileName: String) -> URL? {
        guard let folder = sharedFolderURL() else { return nil }
        
        let safe = makeSafeFileName(fileName)
        
        guard !safe.contains(".."), !safe.contains("/") else {
            return nil
        }
        
        return folder.appendingPathComponent(safe, isDirectory: false)
    }
    
    func sharedFolderURL() -> URL? {
        guard let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: GlobalDefinitions.appGroupId) else { return nil }
        
        let folder = container.appendingPathComponent(Constants.folderName, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: folder.path) {
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        }
        
        return folder
    }
    
    func makeSafeFileBaseName(_ raw: String) -> String {
        let invalid = CharacterSet(charactersIn: "/:\\?%*|\"<>.")
        let cleaned = raw
            .components(separatedBy: invalid)
            .joined(separator: "_")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return cleaned.isEmpty ? UUID().uuidString : cleaned
    }
    
    func makeSafeFileName(_ raw: String) -> String {
        let invalid = CharacterSet(charactersIn: "/:\\?%*|\"<>")
        let cleaned = raw
            .components(separatedBy: invalid)
            .joined(separator: "_")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return cleaned.isEmpty ? UUID().uuidString : cleaned
    }
}
