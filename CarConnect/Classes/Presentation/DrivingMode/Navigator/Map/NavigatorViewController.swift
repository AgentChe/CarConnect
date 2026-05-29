//
//  NavigatorViewController.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 21.05.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class NavigatorViewController: UIViewController {
    private lazy var mainView = NavigatorView()
    
    private lazy var viewModel = NavigatorViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var routeBuilder = RouteBuilder(container: mainView.mapView)
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: NavigatorViewModel.Input(
            didTapResizeMap: mainView.mapView.didTapResize,
            didTapBuildRoute: mainView.mapView.didTapBuildRoute,
            didTapUnlockLocationTracking: mainView.mapView.didTapUnlockLocationTracking
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        output.mapPresentationState
            .drive(Binder(mainView) { base, state in
                base.setup(mapPresentationState: state)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension NavigatorViewController {
    static func make() -> NavigatorViewController {
        NavigatorViewController()
    }
}

// MARK: Private
private extension NavigatorViewController {
    func action(_ action: NavigatorViewModel.Action) {
        switch action {
        case .openSettings:
            openSettings()
        case .showRouteBuilder(let coordinate):
            mainView.mapView.setup(buildRouteHidden: true)
            
            routeBuilder.buildRoute(
                departureLocation: coordinate,
                didCancel: { [weak self] in
                    self?.mainView.mapView.setup(buildRouteHidden: false)
                },
                didStart: { [weak self] route in
                    self?.mainView.mapView.setup(buildRouteHidden: false)
                }
            )
        }
    }

    func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL)
    }
}
