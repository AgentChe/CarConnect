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
}
