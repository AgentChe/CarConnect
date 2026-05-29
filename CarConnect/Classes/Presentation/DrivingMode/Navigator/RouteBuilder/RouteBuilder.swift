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
    func buildRoute(
        departureLocation: Coordinate,
        didCancel: (() -> Void)? = nil,
        didStart: ((NavigatorRoute) -> Void)? = nil,
        didLookingAtPresetPlaces: (([NavigatorPlace]?) -> Void)? = nil,
        didReceiveRoute: ((NavigatorRoute?) -> Void)? = nil
    ) {
        searchDestinationPlace(
            departureLocation: departureLocation,
            didClose: {
                didCancel?()
            },
            searchedPlace: { [weak self] destinationPlace in
                self?.showRoutePreview(
                    departureLocation: departureLocation,
                    destinationPlace: destinationPlace,
                    didClose: {
                        didCancel?()
                    },
                    didStart: { route in
                        didStart?(route)
                    },
                    didLookingAtPresetPlaces: didLookingAtPresetPlaces,
                    didReceiveRoute: didReceiveRoute
                )
            },
            didLookingAtPresetPlaces: didLookingAtPresetPlaces
        )
    }
}

// MARK: Private
private extension RouteBuilder {
    func searchDestinationPlace(
        departureLocation: Coordinate,
        didClose: (() -> Void)? = nil,
        searchedPlace: @escaping (NavigatorPlace) -> Void,
        didLookingAtPresetPlaces: (([NavigatorPlace]?) -> Void)?
    ) {
        guard let container else { return }
        
        let searchPlaceView = SearchPlaceView(coordinate: departureLocation)
        searchPlaceView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(searchPlaceView)
        
        NSLayoutConstraint.activate([
            searchPlaceView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12.landscapeHScale),
            searchPlaceView.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.landscapeVScale),
            searchPlaceView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            searchPlaceView.widthAnchor.constraint(equalToConstant: 356.landscapeHScale)
        ])
        
        searchPlaceView.didClose = { [weak self, weak searchPlaceView] in
            didLookingAtPresetPlaces?(nil)
            
            self?.animateHide(view: searchPlaceView) {
                didClose?()
            }
        }
        
        searchPlaceView.didSelectPlace = { [weak self, weak searchPlaceView] place in
            didLookingAtPresetPlaces?(nil)
            
            self?.animateHide(view: searchPlaceView) {
                searchedPlace(place)
            }
        }
        
        searchPlaceView.didLookingAtPresetPlaces = { places in
            didLookingAtPresetPlaces?(places)
        }
        
        animateShow(view: searchPlaceView, in: container)
    }
    
    func showRoutePreview(
        departureLocation: Coordinate,
        destinationPlace: NavigatorPlace,
        routeOptions: RouteOptions = RouteOptionsStorage.shared.options,
        waypoints: [NavigatorPlace] = [],
        departureTime: Date? = nil,
        didClose: (() -> Void)? = nil,
        didStart: ((NavigatorRoute) -> Void)? = nil,
        didLookingAtPresetPlaces: (([NavigatorPlace]?) -> Void)?,
        didReceiveRoute: ((NavigatorRoute?) -> Void)?
    ) {
        guard let container else { return }
        
        let routePreviewView = RouteBuilderPreviewView(
            departureCoordinate: departureLocation,
            destinationPlace: destinationPlace,
            routeOptions: routeOptions,
            waypoints: waypoints,
            departureTime: departureTime
        )
        routePreviewView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(routePreviewView)
        
        NSLayoutConstraint.activate([
            routePreviewView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12.landscapeHScale),
            routePreviewView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            routePreviewView.widthAnchor.constraint(equalToConstant: 325.landscapeHScale),
            routePreviewView.heightAnchor.constraint(equalToConstant: 136.landscapeHScale)
        ])
        
        routePreviewView.didClose = { [weak self, weak routePreviewView] in
            didReceiveRoute?(nil)
            
            self?.animateHide(view: routePreviewView) {
                didClose?()
            }
        }
        
        routePreviewView.didTapMenu = { [weak self, weak routePreviewView] in
            self?.animateHide(view: routePreviewView) {
                self?.showMenu(
                    departureLocation: departureLocation,
                    destinationPlace: destinationPlace,
                    routeOptions: routeOptions,
                    waypoints: waypoints,
                    departureTime: departureTime,
                    didClosePreview: didClose,
                    didStart: didStart,
                    didLookingAtPresetPlaces: didLookingAtPresetPlaces,
                    didReceiveRoute: didReceiveRoute
                )
            }
        }
        
        routePreviewView.didTapAddStop = { [weak self, weak routePreviewView] in
            self?.animateHide(view: routePreviewView) {
                self?.searchDestinationPlace(
                    departureLocation: departureLocation,
                    didClose: {
                        self?.showRoutePreview(
                            departureLocation: departureLocation,
                            destinationPlace: destinationPlace,
                            routeOptions: routeOptions,
                            waypoints: waypoints,
                            departureTime: departureTime,
                            didClose: didClose,
                            didStart: didStart,
                            didLookingAtPresetPlaces: didLookingAtPresetPlaces,
                            didReceiveRoute: didReceiveRoute
                        )
                    },
                    searchedPlace: { waypoint in
                        self?.showRoutePreview(
                            departureLocation: departureLocation,
                            destinationPlace: destinationPlace,
                            routeOptions: routeOptions,
                            waypoints: waypoints + [waypoint],
                            departureTime: departureTime,
                            didClose: didClose,
                            didStart: didStart,
                            didLookingAtPresetPlaces: didLookingAtPresetPlaces,
                            didReceiveRoute: didReceiveRoute
                        )
                    },
                    didLookingAtPresetPlaces: didLookingAtPresetPlaces
                )
            }
        }
        
        routePreviewView.didTapStart = { [weak self, weak routePreviewView] route in
            self?.animateHide(view: routePreviewView) {
                didStart?(route)
            }
        }
        
        routePreviewView.didReceiveRoute = { route in
            didReceiveRoute?(route)
        }
        
        animateShow(view: routePreviewView, in: container)
    }
    
    func showMenu(
        departureLocation: Coordinate,
        destinationPlace: NavigatorPlace,
        routeOptions: RouteOptions,
        waypoints: [NavigatorPlace],
        departureTime: Date?,
        didClosePreview: (() -> Void)?,
        didStart: ((NavigatorRoute) -> Void)?,
        didLookingAtPresetPlaces: (([NavigatorPlace]?) -> Void)?,
        didReceiveRoute: ((NavigatorRoute?) -> Void)?
    ) {
        guard let container else { return }
        
        let menuView = RouteBuilderMenuView()
        menuView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(menuView)
        
        NSLayoutConstraint.activate([
            menuView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12.landscapeHScale),
            menuView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            menuView.widthAnchor.constraint(equalToConstant: 325.landscapeHScale),
            menuView.heightAnchor.constraint(equalToConstant: 246.landscapeHScale)
        ])
        
        menuView.didClose = { [weak self, weak menuView] in
            self?.animateHide(view: menuView) {
                self?.showRoutePreview(
                    departureLocation: departureLocation,
                    destinationPlace: destinationPlace,
                    routeOptions: routeOptions,
                    waypoints: waypoints,
                    departureTime: departureTime,
                    didClose: didClosePreview,
                    didStart: didStart,
                    didLookingAtPresetPlaces: didLookingAtPresetPlaces,
                    didReceiveRoute: didReceiveRoute
                )
            }
        }
        
        menuView.didAddStop = { [weak self, weak menuView] in
            self?.animateHide(view: menuView) {
                self?.addStopFromMenu(
                    departureLocation: departureLocation,
                    destinationPlace: destinationPlace,
                    routeOptions: routeOptions,
                    waypoints: waypoints,
                    departureTime: departureTime,
                    didClosePreview: didClosePreview,
                    didStart: didStart,
                    didLookingAtPresetPlaces: didLookingAtPresetPlaces,
                    didReceiveRoute: didReceiveRoute
                )
            }
        }
        
        menuView.didRouteOptions = { [weak self, weak menuView] in
            self?.animateHide(view: menuView) {
                self?.routeOptions(
                    departureLocation: departureLocation,
                    destinationPlace: destinationPlace,
                    routeOptions: routeOptions,
                    waypoints: waypoints,
                    departureTime: departureTime,
                    didClosePreview: didClosePreview,
                    didStart: didStart,
                    didLookingAtPresetPlaces: didLookingAtPresetPlaces,
                    didReceiveRoute: didReceiveRoute
                )
            }
        }
        
        menuView.didSetDepartureTime = { [weak self, weak menuView] in
            self?.animateHide(view: menuView) {
                self?.setDepartureTime(
                    departureLocation: departureLocation,
                    destinationPlace: destinationPlace,
                    routeOptions: routeOptions,
                    waypoints: waypoints,
                    departureTime: departureTime,
                    didClosePreview: didClosePreview,
                    didStart: didStart,
                    didLookingAtPresetPlaces: didLookingAtPresetPlaces,
                    didReceiveRoute: didReceiveRoute
                )
            }
        }
        
        animateShow(view: menuView, in: container)
    }
    
    func addStopFromMenu(
        departureLocation: Coordinate,
        destinationPlace: NavigatorPlace,
        routeOptions: RouteOptions,
        waypoints: [NavigatorPlace],
        departureTime: Date?,
        didClosePreview: (() -> Void)?,
        didStart: ((NavigatorRoute) -> Void)?,
        didLookingAtPresetPlaces: (([NavigatorPlace]?) -> Void)?,
        didReceiveRoute: ((NavigatorRoute?) -> Void)?
    ) {
        searchDestinationPlace(
            departureLocation: departureLocation,
            didClose: { [weak self] in
                self?.showMenu(
                    departureLocation: departureLocation,
                    destinationPlace: destinationPlace,
                    routeOptions: routeOptions,
                    waypoints: waypoints,
                    departureTime: departureTime,
                    didClosePreview: didClosePreview,
                    didStart: didStart,
                    didLookingAtPresetPlaces: didLookingAtPresetPlaces,
                    didReceiveRoute: didReceiveRoute
                )
            },
            searchedPlace: { [weak self] waypoint in
                self?.showMenu(
                    departureLocation: departureLocation,
                    destinationPlace: destinationPlace,
                    routeOptions: routeOptions,
                    waypoints: waypoints + [waypoint],
                    departureTime: departureTime,
                    didClosePreview: didClosePreview,
                    didStart: didStart,
                    didLookingAtPresetPlaces: didLookingAtPresetPlaces,
                    didReceiveRoute: didReceiveRoute
                )
            },
            didLookingAtPresetPlaces: didLookingAtPresetPlaces
        )
    }
    
    func routeOptions(
        departureLocation: Coordinate,
        destinationPlace: NavigatorPlace,
        routeOptions: RouteOptions,
        waypoints: [NavigatorPlace],
        departureTime: Date?,
        didClosePreview: (() -> Void)?,
        didStart: ((NavigatorRoute) -> Void)?,
        didLookingAtPresetPlaces: (([NavigatorPlace]?) -> Void)?,
        didReceiveRoute: ((NavigatorRoute?) -> Void)?
    ) {
        guard let container else { return }
        
        let routeOptionsView = RouteOptionsView(options: routeOptions)
        routeOptionsView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(routeOptionsView)
        
        NSLayoutConstraint.activate([
            routeOptionsView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12.landscapeHScale),
            routeOptionsView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            routeOptionsView.widthAnchor.constraint(equalToConstant: 325.landscapeHScale),
            routeOptionsView.heightAnchor.constraint(equalToConstant: 210.landscapeHScale)
        ])
        
        routeOptionsView.didClose = { [weak self, weak routeOptionsView] options in
            self?.animateHide(view: routeOptionsView) {
                self?.showMenu(
                    departureLocation: departureLocation,
                    destinationPlace: destinationPlace,
                    routeOptions: options,
                    waypoints: waypoints,
                    departureTime: departureTime,
                    didClosePreview: didClosePreview,
                    didStart: didStart,
                    didLookingAtPresetPlaces: didLookingAtPresetPlaces,
                    didReceiveRoute: didReceiveRoute
                )
            }
        }
        
        animateShow(view: routeOptionsView, in: container)
    }
    
    func setDepartureTime(
        departureLocation: Coordinate,
        destinationPlace: NavigatorPlace,
        routeOptions: RouteOptions,
        waypoints: [NavigatorPlace],
        departureTime: Date?,
        didClosePreview: (() -> Void)?,
        didStart: ((NavigatorRoute) -> Void)?,
        didLookingAtPresetPlaces: (([NavigatorPlace]?) -> Void)?,
        didReceiveRoute: ((NavigatorRoute?) -> Void)?
    ) {
        guard let container else { return }
        
        let setDepartureTimeView = RouteBuilderDepartureTimeView(date: departureTime)
        setDepartureTimeView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(setDepartureTimeView)
        
        NSLayoutConstraint.activate([
            setDepartureTimeView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12.landscapeHScale),
            setDepartureTimeView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            setDepartureTimeView.widthAnchor.constraint(equalToConstant: 325.landscapeHScale),
            setDepartureTimeView.heightAnchor.constraint(equalToConstant: 290.landscapeHScale)
        ])
        
        setDepartureTimeView.didClose = { [weak self, weak setDepartureTimeView] in
            self?.animateHide(view: setDepartureTimeView) {
                self?.showMenu(
                    departureLocation: departureLocation,
                    destinationPlace: destinationPlace,
                    routeOptions: routeOptions,
                    waypoints: waypoints,
                    departureTime: departureTime,
                    didClosePreview: didClosePreview,
                    didStart: didStart,
                    didLookingAtPresetPlaces: didLookingAtPresetPlaces,
                    didReceiveRoute: didReceiveRoute
                )
            }
        }
        
        setDepartureTimeView.didReset = { [weak self, weak setDepartureTimeView] in
            self?.animateHide(view: setDepartureTimeView) {
                self?.showMenu(
                    departureLocation: departureLocation,
                    destinationPlace: destinationPlace,
                    routeOptions: routeOptions,
                    waypoints: waypoints,
                    departureTime: nil,
                    didClosePreview: didClosePreview,
                    didStart: didStart,
                    didLookingAtPresetPlaces: didLookingAtPresetPlaces,
                    didReceiveRoute: didReceiveRoute
                )
            }
        }
        
        setDepartureTimeView.didDone = { [weak self, weak setDepartureTimeView] date in
            self?.animateHide(view: setDepartureTimeView) {
                self?.showMenu(
                    departureLocation: departureLocation,
                    destinationPlace: destinationPlace,
                    routeOptions: routeOptions,
                    waypoints: waypoints,
                    departureTime: date,
                    didClosePreview: didClosePreview,
                    didStart: didStart,
                    didLookingAtPresetPlaces: didLookingAtPresetPlaces,
                    didReceiveRoute: didReceiveRoute
                )
            }
        }
        
        animateShow(view: setDepartureTimeView, in: container)
    }
    
    func animateShow(view: UIView, in container: UIView) {
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

    func animateHide(view: UIView?, completion: (() -> Void)? = nil) {
        guard let view, let container = view.superview else { return }

        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseIn
        ) {
            view.transform = CGAffineTransform(translationX: 0, y: container.bounds.height)
            view.alpha = 0
        } completion: { _ in
            view.removeFromSuperview()
            
            completion?()
        }
    }
}
