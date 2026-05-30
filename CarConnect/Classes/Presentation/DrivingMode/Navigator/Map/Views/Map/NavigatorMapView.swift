//
//  NavigatorMapView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.05.2026.
//

import UIKit
import CoreLocation
import GoogleMaps
import GoogleNavigation

final class NavigatorMapView: UIView {
    var didTapResize: (() -> Void)?
    var didTapBuildRoute: ((Coordinate) -> Void)?
    var didEndNavigation: (() -> Void)?

    lazy var googleMapView = makeGoogleMapView()
    lazy var resizeButton = makeResizeButton()
    lazy var buildRouteButton = makeBuildRouteButton()
    lazy var myGeoButton = makeMyGeoButton()
    lazy var muteButton = makeMuteButton()
    lazy var endNavigationButton = makeEndNavigationButton()

    private var myLocationObservation: NSKeyValueObservation?

    private(set) var isNavigating = false
    private var pendingDestinationsCount = 0

    override init(frame: CGRect) {
        super.init(frame: frame)

        makeConstraints()
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        myLocationObservation = nil
    }
}

// MARK: Public
extension NavigatorMapView {
    func drawMarkers(places: [NavigatorPlace]?) {
        googleMapView.clear()

        places?.forEach { place in
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(
                latitude: place.coordinate.latitude,
                longitude: place.coordinate.longitude
            )
            marker.title = place.name
            marker.map = googleMapView
        }
    }
    
    func drawRoute(_ route: NavigatorRoute?) {
        googleMapView.clear()
        
        guard let route, let path = GMSPath(fromEncodedPath: route.encodedPolyline) else { return }
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 4
        polyline.strokeColor = Appearance.color_4178F6
        polyline.map = googleMapView
        
        let bounds = GMSCoordinateBounds(path: path)
        let update = GMSCameraUpdate.fit(bounds, withPadding: 40)
        googleMapView.animate(with: update)
    }
    
    func setup(mapPresentationState: NavigatorResizableMapView.MapPresentationState) {
        let imageName: String = {
            switch mapPresentationState {
            case .compact:
                return "Navigator.Expanded"
            case .expanded:
                return "Navigator.Compact"
            }
        }()
        resizeButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    func startNavigation(route: NavigatorRoute) {
        guard !isNavigating else { return }

        if GMSNavigationServices.areTermsAndConditionsAccepted() {
            beginNavigation(route: route)
        } else {
            let options = GMSNavigationTermsAndConditionsOptions(companyName: "Bloomupapps LTD")
            GMSNavigationServices.showTermsAndConditionsDialogIfNeeded(with: options) { [weak self] accepted in
                guard accepted else { return }
                
                self?.beginNavigation(route: route)
            }
        }
    }
    
    func stopNavigation() {
        guard isNavigating else { return }
        
        isNavigating = false
        
        pendingDestinationsCount = 0

        if let navigator = googleMapView.navigator {
            navigator.isGuidanceActive = false
            navigator.clearDestinations()
            navigator.remove(self)
        }

        googleMapView.cameraMode = .free
        googleMapView.isNavigationEnabled = false

        muteButton.isHidden = true
        endNavigationButton.isHidden = true
        myGeoButton.isHidden = false
    }
}

// MARK: GMSNavigatorListener
extension NavigatorMapView: GMSNavigatorListener {
    func navigator(_ navigator: GMSNavigator, didArriveAt waypoint: GMSNavigationWaypoint) {
        pendingDestinationsCount -= 1

        if pendingDestinationsCount <= 0 {
            stopNavigation()
            didEndNavigation?()
        } else {
            navigator.continueToNextDestination { [weak self] _, _ in
                self?.googleMapView.navigator?.isGuidanceActive = true
            }
        }
    }
}

// MARK: Private
private extension NavigatorMapView {
    func initialize() {
        backgroundColor = .clear
        layer.cornerRadius = 10.landscapeHScale

        centerOnUserLocationOnce()
    }

    func centerOnUserLocationOnce() {
        myLocationObservation = googleMapView.observe(\.myLocation, options: .new) { [weak self] mapView, change in
            guard let self, let location = change.newValue ?? nil else { return }
            
            self.myLocationObservation = nil
            
            mapView.animate(to: GMSCameraPosition(target: location.coordinate, zoom: 15))
        }
    }
    
    func beginNavigation(route: NavigatorRoute) {
        myLocationObservation = nil
        
        googleMapView.isNavigationEnabled = true
        
        guard let navigator = googleMapView.navigator else {
            return
        }
        
        isNavigating = true
        
        googleMapView.cameraMode = .following
        googleMapView.followingPerspective = .tilted
        googleMapView.travelMode = .driving
        googleMapView.lightingMode = .lowLight
        googleMapView.isMyLocationEnabled = true
        
        googleMapView.settings.isNavigationHeaderEnabled = true
        googleMapView.settings.isNavigationFooterEnabled = true
        googleMapView.settings.isRecenterButtonEnabled = true
        googleMapView.settings.isNavigationReportIncidentButtonEnabled = false
        googleMapView.settings.showsDestinationMarkers = true
        
        navigator.voiceGuidance = .alertsAndGuidance
        navigator.audioDeviceType = .bluetooth
        navigator.isVibrationEnabled = true
        navigator.sendsBackgroundNotifications = true
        navigator.avoidsTolls = route.avoidTolls
        navigator.avoidsHighways = route.avoidHighways
        navigator.add(self)
        
        var waypoints: [GMSNavigationWaypoint] = []
        
        for stop in route.waypoints {
            if let waypoint = GMSNavigationWaypoint(
                location: CLLocationCoordinate2D(
                    latitude: stop.coordinate.latitude,
                    longitude: stop.coordinate.longitude
                ),
                title: stop.name.isEmpty ? "Waypoint" : stop.name
            ) {
                waypoints.append(waypoint)
            }
        }
        
        guard let destination = GMSNavigationWaypoint(
            location: CLLocationCoordinate2D(
                latitude: route.destination.coordinate.latitude,
                longitude: route.destination.coordinate.longitude
            ),
            title: route.destination.name.isEmpty ? "Destination" : route.destination.name
        ) else {
            stopNavigation()
            return
        }
        waypoints.append(destination)
        pendingDestinationsCount = waypoints.count
        
        myGeoButton.isHidden = true
        muteButton.isHidden = false
        endNavigationButton.isHidden = false
        updateMuteButton(isMuted: false)
        
        navigator.setDestinations(waypoints) { [weak self] status in
            guard let self, self.isNavigating else { return }
            
            guard status == .OK else { return }
            
            self.googleMapView.navigator?.isGuidanceActive = true
            self.googleMapView.cameraMode = .following
        }
    }

    @objc
    func resizeTapped() {
        didTapResize?()
    }

    @objc
    func myGeoTapped() {
        guard let coordinate = googleMapView.myLocation?.coordinate else { return }
        
        googleMapView.animate(to: GMSCameraPosition(target: coordinate, zoom: 15))
    }

    @objc
    func buildRouteTapped() {
        guard let locationCoordinate = googleMapView.myLocation?.coordinate else { return }
        
        let coordinate = Coordinate(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        
        didTapBuildRoute?(coordinate)
    }
    
    @objc
    func muteTapped() {
        guard let navigator = googleMapView.navigator else { return }

        let isMuted = navigator.voiceGuidance == .silent
        navigator.voiceGuidance = isMuted ? .alertsAndGuidance : .silent
        updateMuteButton(isMuted: !isMuted)
    }

    @objc
    func endNavigationTapped() {
        stopNavigation()
        didEndNavigation?()
    }
    
    func updateMuteButton(isMuted: Bool) {
        let imageName = isMuted ? "Navigator.Muted" : "Navigator.Mute"
        muteButton.setImage(UIImage(named: imageName), for: .normal)
    }
}

// MARK: Make constraints
private extension NavigatorMapView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            googleMapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            googleMapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            googleMapView.topAnchor.constraint(equalTo: topAnchor),
            googleMapView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            resizeButton.widthAnchor.constraint(equalToConstant: 40.landscapeHScale),
            resizeButton.heightAnchor.constraint(equalToConstant: 40.landscapeHScale),
            resizeButton.topAnchor.constraint(equalTo: topAnchor, constant: 12.landscapeVScale),
            resizeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.landscapeHScale)
        ])

        NSLayoutConstraint.activate([
            buildRouteButton.widthAnchor.constraint(equalToConstant: 40.landscapeHScale),
            buildRouteButton.heightAnchor.constraint(equalToConstant: 40.landscapeHScale),
            buildRouteButton.bottomAnchor.constraint(equalTo: myGeoButton.topAnchor, constant: -12.landscapeVScale),
            buildRouteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.landscapeHScale)
        ])
        
        NSLayoutConstraint.activate([
            myGeoButton.widthAnchor.constraint(equalToConstant: 40.landscapeHScale),
            myGeoButton.heightAnchor.constraint(equalToConstant: 40.landscapeHScale),
            myGeoButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.landscapeVScale),
            myGeoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.landscapeHScale)
        ])

        NSLayoutConstraint.activate([
            muteButton.widthAnchor.constraint(equalToConstant: 40.landscapeHScale),
            muteButton.heightAnchor.constraint(equalToConstant: 40.landscapeHScale),
            muteButton.bottomAnchor.constraint(equalTo: endNavigationButton.topAnchor, constant: -12.landscapeVScale),
            muteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.landscapeHScale)
        ])

        NSLayoutConstraint.activate([
            endNavigationButton.widthAnchor.constraint(equalToConstant: 40.landscapeHScale),
            endNavigationButton.heightAnchor.constraint(equalToConstant: 40.landscapeHScale),
            endNavigationButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.landscapeVScale),
            endNavigationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.landscapeHScale)
        ])
    }
}

// MARK: Lazy initialization
private extension NavigatorMapView {
    func makeGoogleMapView() -> GMSMapView {
        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition(latitude: 0, longitude: 0, zoom: 2)
        
        let view = GMSMapView(options: options)
        view.layer.cornerRadius = 10.landscapeHScale
        view.isMyLocationEnabled = true
        view.settings.myLocationButton = false
        view.settings.compassButton = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }

    func makeResizeButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.dx = -10.landscapeHScale
        view.dy = -10.landscapeHScale
        view.addTarget(self, action: #selector(resizeTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBuildRouteButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.dx = -10.landscapeHScale
        view.dy = -10.landscapeHScale
        view.setImage(UIImage(named: "Navigator.BuildRoute"), for: .normal)
        view.addTarget(self, action: #selector(buildRouteTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }

    func makeMyGeoButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.dx = -10.landscapeHScale
        view.dy = -10.landscapeHScale
        view.setImage(UIImage(named: "Navigator.MyGeo"), for: .normal)
        view.addTarget(self, action: #selector(myGeoTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }

    func makeMuteButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.dx = -10.landscapeHScale
        view.dy = -10.landscapeHScale
        view.setImage(UIImage(named: "Navigator.Mute"), for: .normal)
        view.isHidden = true
        view.addTarget(self, action: #selector(muteTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }

    func makeEndNavigationButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.dx = -10.landscapeHScale
        view.dy = -10.landscapeHScale
        view.setImage(UIImage(named: "Navigator.EndNavigation"), for: .normal)
        view.isHidden = true
        view.addTarget(self, action: #selector(endNavigationTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
