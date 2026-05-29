//
//  NavigatorMapView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.05.2026.
//

import UIKit
import CoreLocation
import GoogleMaps

final class NavigatorMapView: UIView {
    var didTapResize: (() -> Void)?
    var didTapBuildRoute: ((Coordinate) -> Void)?

    lazy var googleMapView = makeGoogleMapView()
    lazy var resizeButton = makeResizeButton()
    lazy var buildRouteButton = makeBuildRouteButton()
    lazy var myGeoButton = makeMyGeoButton()

    private var myLocationObservation: NSKeyValueObservation?

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

    func makeResizeButton() -> UIButton {
        let view = TapAreaButton()
        view.addTarget(self, action: #selector(resizeTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBuildRouteButton() -> UIButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Navigator.BuildRoute"), for: .normal)
        view.addTarget(self, action: #selector(buildRouteTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }

    func makeMyGeoButton() -> UIButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Navigator.MyGeo"), for: .normal)
        view.addTarget(self, action: #selector(myGeoTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
