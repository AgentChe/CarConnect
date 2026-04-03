//
//  VehicleAIPreviewGenerateResult.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.04.2026.
//

struct VehicleAIPreviewGenerateResult {
    let base64: String?
    
    init?(response: Any) {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? String
        else { return nil }
        
        self.base64 = body 
    }
}
