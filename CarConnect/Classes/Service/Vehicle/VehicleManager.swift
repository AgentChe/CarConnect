//
//  VehicleManager.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 25.03.2026.
//

import RxSwift
import RxCocoa

protocol VehicleManagerProtocol {
    func fetchWidgetPreviews() -> Single<[VehicleWidgetPreview]>
    func fetchVehicleSupportLogos() -> Single<VehicleSupportLogosResponse?>
    func vehicleAIPreviewGenerate(image: UIImage, prompt: String) -> Single<VehicleAIPreviewGenerateResult?>
}

final class VehicleManager {
    private lazy var restAPITransport = RestAPITransport()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: VehicleManagerProtocol
extension VehicleManager: VehicleManagerProtocol {
    func fetchWidgetPreviews() -> Single<[VehicleWidgetPreview]> {
        let request = FetchVehicleWidgetPreviewsRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { VehicleWidgetPreview.map(response: $0) }
    }
    
    func fetchVehicleSupportLogos() -> Single<VehicleSupportLogosResponse?> {
        let request = FetchVehicleSupportLogosRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { VehicleSupportLogosResponse(response: $0) }
    }
    
    func vehicleAIPreviewGenerate(image: UIImage, prompt: String) -> Single<VehicleAIPreviewGenerateResult?> {
        let request = VehicleAIPreviewGenerateRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            image: image,
            prompt: prompt
        )
        
        return restAPITransport
            .callServerApi(formDataBody: request)
            .map { VehicleAIPreviewGenerateResult(response: $0) }
    }
}
