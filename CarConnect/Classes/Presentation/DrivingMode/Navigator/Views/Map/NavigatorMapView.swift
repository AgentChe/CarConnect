//
//  NavigatorMapView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.05.2026.
//

import UIKit

final class NavigatorMapView: UIView {
    var didTapResize: (() -> Void)?
    var didTapMyGeo: (() -> Void)?
    var didTapBuildRoute: (() -> Void)?
    
    lazy var resizeButton = makeResizeButton()
    lazy var myGeoButton = makeMyGeoButton()
    lazy var buildRouteButton = makeBuildRouteButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension NavigatorMapView {
    func setup(mapPresentationState: NavigatorResizableMapView.MapPresentationState) {
        let imageName: String = {
            switch mapPresentationState {
            case .compact:
                return "Navigator.Expanded"
            case .expanded:
                return "Navigator.Compact"
            }
        }()
        let image = UIImage(named: imageName)
        resizeButton.setImage(image, for: .normal)
    }
}

// MARK: Private
private extension NavigatorMapView {
    func initialize() {
        backgroundColor = UIColor.red // TODO: 
    }
    
    @objc
    func resizeTapped() {
        didTapResize?()
    }
    
    @objc
    func myGeoTapped() {
        didTapResize?()
    }
    
    @objc
    func buildRouteTapped() {
        didTapResize?()
    }
}

// MARK: Make constraints
private extension NavigatorMapView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            resizeButton.widthAnchor.constraint(equalToConstant: 40.landscapeHScale),
            resizeButton.heightAnchor.constraint(equalToConstant: 40.landscapeHScale),
            resizeButton.topAnchor.constraint(equalTo: topAnchor, constant: 12.landscapeVScale),
            resizeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.landscapeHScale)
        ])
        
        NSLayoutConstraint.activate([
            myGeoButton.widthAnchor.constraint(equalToConstant: 40.landscapeHScale),
            myGeoButton.heightAnchor.constraint(equalToConstant: 40.landscapeHScale),
            myGeoButton.bottomAnchor.constraint(equalTo: buildRouteButton.topAnchor, constant: -12.landscapeVScale),
            myGeoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.landscapeHScale)
        ])
        
        NSLayoutConstraint.activate([
            buildRouteButton.widthAnchor.constraint(equalToConstant: 40.landscapeHScale),
            buildRouteButton.heightAnchor.constraint(equalToConstant: 40.landscapeHScale),
            buildRouteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.landscapeVScale),
            buildRouteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.landscapeHScale)
        ])
    }
}

// MARK: Lazy initialization
private extension NavigatorMapView {
    func makeResizeButton() -> UIButton {
        let view = TapAreaButton()
        view.addTarget(self, action: #selector(resizeTapped), for: .touchUpInside)
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
    
    func makeBuildRouteButton() -> UIButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Navigator.BuildRoute"), for: .normal)
        view.addTarget(self, action: #selector(buildRouteTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
