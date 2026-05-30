//
//  CarPlaySceneDelegate.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 30.05.2026.
//

import UIKit
import CarPlay
import RxSwift
import RxCocoa
import GoogleMaps
import GoogleNavigation

final class CarPlaySceneDelegate: UIResponder {
    private lazy var disposeBag = DisposeBag()

    private weak var interfaceController: CPInterfaceController?
    private weak var carWindow: CPWindow?
    private var mapView: GMSMapView?

    private var mapTemplate: CPMapTemplate?
    private var placeholderTemplate: CPInformationTemplate?
}

// MARK: CPTemplateApplicationSceneDelegate
extension CarPlaySceneDelegate: CPTemplateApplicationSceneDelegate {
    func templateApplicationScene(
        _ templateApplicationScene: CPTemplateApplicationScene,
        didConnect interfaceController: CPInterfaceController,
        to window: CPWindow
    ) {
        self.interfaceController = interfaceController
        self.carWindow = window

        setupMapView(in: window)
        mapTemplate = makeMapTemplate()

        bindNavigationState()
    }

    func templateApplicationScene(
        _ templateApplicationScene: CPTemplateApplicationScene,
        didDisconnect interfaceController: CPInterfaceController,
        from window: CPWindow
    ) {
        disposeBag = DisposeBag()

        self.interfaceController = nil
        self.carWindow = nil
        mapView = nil
        mapTemplate = nil
        placeholderTemplate = nil
    }
}

// MARK: CPMapTemplateDelegate
extension CarPlaySceneDelegate: CPMapTemplateDelegate {
    func mapTemplateDidBeginPanGesture(_ mapTemplate: CPMapTemplate) {
        mapView?.didBeginPanGesture()
    }

    func mapTemplate(
        _ mapTemplate: CPMapTemplate,
        didUpdatePanGestureWithTranslation translation: CGPoint,
        velocity: CGPoint
    ) {
        mapView?.didUpdatePanGesture(withTranslation: translation, velocity: velocity)
    }

    func mapTemplate(_ mapTemplate: CPMapTemplate, didEndPanGestureWithVelocity velocity: CGPoint) {
        mapView?.didEndPanGesture(withVelocity: velocity)
    }
}

// MARK: Private
private extension CarPlaySceneDelegate {
    func bindNavigationState() {
        NavigatorSession.shared.state
            .drive(onNext: { [weak self] state in
                self?.receive(state: state)
            })
            .disposed(by: disposeBag)
    }

    func receive(state: NavigatorSession.State) {
        switch state {
        case .idle:
            showPlaceholder()
        case .navigation:
            showMap()
            attachSessionToMapView()
        }
    }

    func attachSessionToMapView() {
        guard
            let mapView,
            let session = NavigatorSession.shared.session,
            mapView.enableNavigation(with: session)
        else { return }

        mapView.cameraMode = .following
        mapView.followingPerspective = .tilted
        mapView.travelMode = .driving
        mapView.lightingMode = .lowLight
        mapView.isMyLocationEnabled = true

        mapView.settings.isNavigationHeaderEnabled = false
        mapView.settings.isNavigationFooterEnabled = true
        mapView.settings.isNavigationReportIncidentButtonEnabled = false
        mapView.settings.isRecenterButtonEnabled = true
        mapView.settings.showsDestinationMarkers = true
    }
    
    func showMap() {
        guard let mapTemplate else { return }

        setRootTemplateIfNeeded(mapTemplate)
    }

    func showPlaceholder() {
        setRootTemplateIfNeeded(makePlaceholderTemplate())
    }

    func setRootTemplateIfNeeded(_ template: CPTemplate) {
        guard let interfaceController else { return }
        guard interfaceController.rootTemplate !== template else { return }

        interfaceController.setRootTemplate(template, animated: true, completion: nil)
    }

    func makeMapTemplate() -> CPMapTemplate {
        let template = CPMapTemplate()
        template.mapDelegate = self
        return template
    }

    func makePlaceholderTemplate() -> CPInformationTemplate {
        if let placeholderTemplate {
            return placeholderTemplate
        }

        let button = CPTextButton(
            title: "CarPlay.Placeholder.Button".localized,
            textStyle: .normal
        ) { _ in
            // TODO: send an intent to the app to open Driving mode / build a route.
        }

        let template = CPInformationTemplate(
            title: "CarPlay.Placeholder.Title".localized,
            layout: .leading,
            items: [
                CPInformationItem(
                    title: "CarPlay.Placeholder.Text".localized,
                    detail: nil
                )
            ],
            actions: [button]
        )

        placeholderTemplate = template

        return template
    }
    
    func setupMapView(in window: CPWindow) {
        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition(latitude: 0, longitude: 0, zoom: 2)

        let view = GMSMapView(options: options)
        view.isMyLocationEnabled = true
        view.settings.compassButton = false

        let rootViewController = UIViewController()
        rootViewController.view = view
        window.rootViewController = rootViewController

        mapView = view
    }
}
