//
//  GeoLocationAPI.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 18.03.2026.
//

import CoreLocation

final class GeoLocationAPI: NSObject {
    private lazy var locationManager = CLLocationManager()
    private lazy var geocoder = CLGeocoder()
    
    private var coordinateCompletion: ((Coordinate?) -> Void)?
    private var locationCompletion: ((Location?) -> Void)?
    
    private var isRequestingLocationName = false
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
}

// MARK: Public
extension GeoLocationAPI {
    func authorizationStatus() -> CLAuthorizationStatus {
        locationManager.authorizationStatus
    }
    
    func requestMyLocation(completion: @escaping (Location?) -> Void) {
        clearCompletions()
        
        locationCompletion = completion
        isRequestingLocationName = true
        
        handleAuthorizationAndRequestLocation()
    }
    
    func requestMyCoordinate(completion: @escaping (Coordinate?) -> Void) {
        clearCompletions()
        
        coordinateCompletion = completion
        isRequestingLocationName = false
        
        handleAuthorizationAndRequestLocation()
    }
}

// MARK: CLLocationManagerDelegate
extension GeoLocationAPI: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            finishWithNil()
        case .notDetermined:
            break
        @unknown default:
            finishWithNil()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let clLocation = locations.first else {
            finishWithNil()
            return
        }
        
        if isRequestingLocationName {
            handleLocation(clLocation)
        } else {
            handleCoordinate(clLocation.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        finishWithNil()
    }
}

// MARK: Private
private extension GeoLocationAPI {
    func handleAuthorizationAndRequestLocation() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            finishWithNil()
        @unknown default:
            finishWithNil()
        }
    }
    
    func handleCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let result = Coordinate(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        
        coordinateCompletion?(result)
        clearCompletions()
    }
    
    func handleLocation(_ clLocation: CLLocation) {
        geocoder.reverseGeocodeLocation(clLocation) { [weak self] placemarks, _ in
            guard let self else { return }
            
            let coordinate = Coordinate(
                latitude: clLocation.coordinate.latitude,
                longitude: clLocation.coordinate.longitude
            )
            
            let place = placemarks?.first
            let name =
                place?.locality ??
                place?.subLocality ??
                place?.name ??
                place?.administrativeArea ??
                place?.country
            
            guard let name else {
                self.locationCompletion?(nil)
                self.clearCompletions()
                return
            }
            
            let location = Location(
                id: UUID().uuidString,
                name: name,
                coordinate: coordinate
            )
            
            self.locationCompletion?(location)
            self.clearCompletions()
        }
    }
    
    func finishWithNil() {
        coordinateCompletion?(nil)
        locationCompletion?(nil)
        clearCompletions()
    }
    
    func clearCompletions() {
        coordinateCompletion = nil
        locationCompletion = nil
        isRequestingLocationName = false
    }
}
