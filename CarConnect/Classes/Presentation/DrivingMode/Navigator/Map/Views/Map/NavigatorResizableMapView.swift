//
//  NavigatorResizableMapView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.05.2026.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

final class NavigatorResizableMapView: UIView {
    enum MapPresentationState {
        case compact
        case expanded
    }
    
    private lazy var didTapResizeTrigger = PublishRelay<Void>()
    private lazy var didTapBuildRouteTrigger = PublishRelay<Coordinate>()
    private lazy var didTapUnlockLocationTrackingTrigger = PublishRelay<Void>()
    
    private lazy var geoLocationAPI = GeoLocationAPI()
    
    private var mapView: NavigatorMapView?
    private var unlockGeoView: NavigatorMapUnlockGeoView?
    
    private var mapPresentationState: NavigatorResizableMapView.MapPresentationState?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
        displayGeoState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension NavigatorResizableMapView {
    func setup(mapPresentationState: NavigatorResizableMapView.MapPresentationState) {
        self.mapPresentationState = mapPresentationState
        
        mapView?.setup(mapPresentationState: mapPresentationState)
    }

    var didTapResize: Signal<Void> {
        didTapResizeTrigger.asSignal()
    }
    
    var didTapBuildRoute: Signal<Coordinate> {
        didTapBuildRouteTrigger.asSignal()
    }
    
    var didTapUnlockLocationTracking: Signal<Void> {
        didTapUnlockLocationTrackingTrigger.asSignal()
    }
}

// MARK: Private
private extension NavigatorResizableMapView {
    func initialize() {
        backgroundColor = UIColor.clear
        layer.cornerRadius = 10.landscapeHScale
        
        geoLocationAPI.didChangeAuthorizationStatus = { [weak self] status in
            self?.displayGeoState(status: status)
        }
    }
    
    func displayGeoState(status: CLAuthorizationStatus? = nil) {
        mapView = nil
        unlockGeoView = nil
        
        let status = status ?? geoLocationAPI.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            let view = NavigatorMapView()
            display(view)
            
            if let mapPresentationState {
                view.setup(mapPresentationState: mapPresentationState)
            }
            
            view.didTapResize = { [weak self] in
                self?.didTapResizeTrigger.accept(Void())
            }
            
            view.didTapBuildRoute = { [weak self] coordinate in
                self?.didTapBuildRouteTrigger.accept(coordinate)
            }
            
            self.mapView = view
        default:
            let view = NavigatorMapUnlockGeoView()
            display(view)
            
            view.didTapAction = { [weak self] in
                self?.didTapUnlockLocationTrackingTrigger.accept(Void())
            }
            
            self.unlockGeoView = view
        }
    }
    
    func display(_ view: UIView) {
        subviews.forEach { $0.removeFromSuperview() }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
