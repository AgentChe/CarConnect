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
        
        mainView.dashboardInfoPanelView.musicPlayerView.controlDelegate = viewModel
        mainView.dashboardInfoPanelView.musicPlayerView.sourceDelegate = viewModel
        
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
        
        output.trackInfo
            .withLatestFrom(output.musicSource) { ($0, $1) }
            .drive(Binder(mainView) { base, args in
                let (info, source) = args
                base.setupTrackInfo(model: info, source: source ?? .appleMusic)
            })
            .disposed(by: disposeBag)
        
        output.playbackInfo
            .drive(Binder(mainView) { base, info in
                base.setupPlayerState(model: info)
            })
            .disposed(by: disposeBag)
        
        output.musicSource
            .drive(Binder(mainView) { base, source in
                base.setupMusicState(source: source)
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
                    self?.mainView.mapView.setupMarkers(places: nil)
                    self?.mainView.mapView.drawRoute(nil)
                },
                didStart: { [weak self] route in
                    guard let self else { return }

                    self.mainView.mapView.setupMarkers(places: nil)
                    self.mainView.mapView.drawRoute(nil)

                    self.mainView.mapView.didEndNavigation = { [weak self] in
                        self?.mainView.mapView.setup(buildRouteHidden: false)
                    }

                    self.mainView.mapView.startNavigation(route: route)
                },
                didLookingAtPresetPlaces: { [weak self] places in
                    self?.mainView.mapView.setupMarkers(places: places)
                },
                didReceiveRoute: { [weak self] route in
                    self?.mainView.mapView.drawRoute(route)
                }
            )
        }
    }

    func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL)
    }
}
