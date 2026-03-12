//
//  MKContentRating.swift
//  MusicKitSample
//
//  Created by Андрей Чернышев on 30.03.2023.
//

import MusicKit

@available(iOS 16.0, *)
public enum MKContentRating: Hashable {
    case clean, explicit
    
    init?(contentRating: ContentRating?) {
        guard let contentRating = contentRating else {
            return nil
        }
        
        switch contentRating {
        case .clean:
            self = .clean
        case .explicit:
            self = .explicit
        @unknown default:
            return nil
        }
    }
}
