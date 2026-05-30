//
//  NavigatorView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 21.05.2026.
//

import UIKit

final class NavigatorView: UIView {
    lazy var mapView = makeMapView()
    lazy var dashboardInfoPanelView = makeDashboardInfoPanelView()
    
    private lazy var mapViewTrailingConstraint = NSLayoutConstraint()
    
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
extension NavigatorView {
    func setup(mapPresentationState: NavigatorResizableMapView.MapPresentationState) {
        mapViewTrailingConstraint.isActive = false
        mapViewTrailingConstraint.constant = {
            switch mapPresentationState {
            case .compact:
                return -280.landscapeHScale
            case .expanded:
                return -16.landscapeHScale
            }
        }()
        mapViewTrailingConstraint.isActive = true
        
        // Если карта становится компактной, сразу показываем dashboard
        if mapPresentationState == .compact {
            dashboardInfoPanelView.isHidden = false
        }
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.dashboardInfoPanelView.isHidden = mapPresentationState == .expanded
            self?.mapView.setup(mapPresentationState: mapPresentationState)
        })
    }
}

// MARK: Private
private extension NavigatorView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension NavigatorView {
    func makeConstraints() {
        mapViewTrailingConstraint = mapView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -280.landscapeHScale)
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.topAnchor.constraint(equalTo: topAnchor, constant: 20.landscapeVScale),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.landscapeVScale),
            mapViewTrailingConstraint
        ])
        
        NSLayoutConstraint.activate([
            dashboardInfoPanelView.widthAnchor.constraint(equalToConstant: 244.landscapeHScale),
            dashboardInfoPanelView.leadingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: 12.landscapeHScale),
            dashboardInfoPanelView.topAnchor.constraint(equalTo: topAnchor, constant: 20.landscapeVScale),
            dashboardInfoPanelView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.landscapeVScale)
        ])
    }
}

// MARK: Lazy initialization
private extension NavigatorView {
    func makeMapView() -> NavigatorResizableMapView {
        let view = NavigatorResizableMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDashboardInfoPanelView() -> NavigatorDashboardInfoPanelView {
        let view = NavigatorDashboardInfoPanelView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
