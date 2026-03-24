//
//  LocationManager.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 24.03.2026.
//

import RxSwift
import RxCocoa

protocol LocationManagerProtocol {
    func fetchLocations(search: String, page: Int) -> Single<Page<[Location]>?>
}

final class LocationManager {
    private lazy var restAPITransport = RestAPITransport()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: LocationManagerProtocol
extension LocationManager: LocationManagerProtocol {
    func fetchLocations(search: String, page: Int) -> Single<Page<[Location]>?> {
        let request = FetchLocationsRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            page: page,
            search: search
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { Location.map(response: $0) }
    }
}
