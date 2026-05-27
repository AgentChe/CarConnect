//
//  RouteBuilder.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 26.05.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class RouteBuilder {
    weak var container: UIView?
    
    init(container: UIView) {
        self.container = container
    }
}

// MARK: Public
extension RouteBuilder {
    func buildRoute(currentLocation: Coordinate) {
        guard let container else { return }

        let searchPlaceView = SearchPlaceView(coordinate: currentLocation)
        searchPlaceView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(searchPlaceView)

        NSLayoutConstraint.activate([
            searchPlaceView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12.landscapeHScale),
            searchPlaceView.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.landscapeVScale),
            searchPlaceView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            searchPlaceView.widthAnchor.constraint(equalToConstant: 356.landscapeHScale)
        ])

        searchPlaceView.didClose = { [weak self, weak searchPlaceView] in
            self?.hideSearchPlaceView(searchPlaceView)
        }
        
        searchPlaceView.didSelectPlace = { [weak self, weak searchPlaceView] place in
            self?.hideSearchPlaceView(searchPlaceView)
            
            self?.showMenu(in: container) // TODO:
        }

        showSearchPlaceView(searchPlaceView, in: container)
    }
}

// MARK: Private
private extension RouteBuilder {
    func showSearchPlaceView(_ view: SearchPlaceView, in container: UIView) {
        let offset = container.bounds.height
        view.transform = CGAffineTransform(translationX: 0, y: offset)
        view.alpha = 0

        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0.3,
            options: .curveEaseOut
        ) {
            view.transform = .identity
            view.alpha = 1
        }
    }

    func hideSearchPlaceView(_ view: SearchPlaceView?) {
        guard let view, let container = view.superview else { return }

        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: .curveEaseIn
        ) {
            view.transform = CGAffineTransform(translationX: 0, y: container.bounds.height)
            view.alpha = 0
        } completion: { _ in
            view.removeFromSuperview()
        }
    }
    
    func showMenu(in container: UIView) {
        let view = RouteBuilderMenuView()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12.landscapeHScale),
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            view.widthAnchor.constraint(equalToConstant: 325.landscapeHScale),
            view.heightAnchor.constraint(equalToConstant: 230.landscapeVScale)
        ])
        
        view.didClose = { [weak view] in
            view?.removeFromSuperview()
        }
        
        view.didAddStop = { [weak view] in
            view?.removeFromSuperview()
        }
        
        view.didRouteOptions = { [weak view] in
            view?.removeFromSuperview()
            
            let routeOptions = RouteOptionsStorage.shared.options
            self.showRouteOptions(options: routeOptions, in: container)
        }
        
        view.didSetDepartureTime = { [weak view] in
            view?.removeFromSuperview()
        }
    }
    
    func showRouteOptions(options: RouteOptions, in container: UIView) {
        let view = RouteOptionsView(options: options)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12.landscapeHScale),
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            view.widthAnchor.constraint(equalToConstant: 325.landscapeHScale),
            view.heightAnchor.constraint(equalToConstant: 182.landscapeVScale)
        ])
        
        view.didClose = { [weak view] routeOptions in
            view?.removeFromSuperview()
        }
    }
}
