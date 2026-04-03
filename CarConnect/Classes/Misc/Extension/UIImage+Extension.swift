//
//  UIImage+Extension.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.04.2026.
//

import UIKit

extension UIImage {
    convenience init?(base64: String) {
        let cleanedBase64: String

        if let commaIndex = base64.firstIndex(of: ",") {
            cleanedBase64 = String(base64[base64.index(after: commaIndex)...])
        } else {
            cleanedBase64 = base64
        }

        guard let data = Data(base64Encoded: cleanedBase64, options: [.ignoreUnknownCharacters]) else {
            return nil
        }

        self.init(data: data)
    }
}
