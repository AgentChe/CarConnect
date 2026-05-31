//
//  DrivingModeViewController.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 12.03.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class DrivingModeViewController: UIViewController {
    private lazy var mainView = DrivingModeView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var coordinator = DrivingModeCoordinator(
        parentVC: self,
        container: mainView.container
    )

    override func loadView() {
        view = mainView
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        [.landscapeLeft]
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        .landscapeLeft
    }

    override var shouldAutorotate: Bool {
        true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .take(1)
            .bind(to: Binder(self) { base, _ in
                base.coordinator.tap(on: .map)
                base.mainView.menuView.setup(selectedItem: .map)
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge([
                mainView.menuView.mapItemButton
                    .rx.tap.map { DrivingModeRouteItemButton.Item.map },
                mainView.menuView.musicItemButton
                    .rx.tap.map { DrivingModeRouteItemButton.Item.music(.appleMusic) }, // TODO: брать актуальный (выбранный) источник музыки
                mainView.menuView.phoneItemButton
                    .rx.tap.map { DrivingModeRouteItemButton.Item.phone },
                SceneDelegateMediator.shared.didOpenURLContexts
                    .compactMap { contexts in
                        if contexts.contains(where: { DeepLink.isDrivingModeNavigator($0.url) }) {
                            return DrivingModeRouteItemButton.Item.map
                        } else if contexts.contains(where: { DeepLink.isSpotifyModeNavigator($0.url) }) {
                            return DrivingModeRouteItemButton.Item.music(.spotify)
                        } else {
                            return nil
                        }
                    }
                    .asObservable()
            ])
            .bind(to: Binder(self) { base, item in
                base.coordinator.tap(on: item)
                base.mainView.menuView.setup(selectedItem: item)
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge([
                mainView.menuView.mapItemButton
                    .rx.tap.map { false },
                mainView.menuView.musicItemButton
                    .rx.tap.map { true },
                mainView.menuView.phoneItemButton
                    .rx.tap.map { true },
                SceneDelegateMediator.shared.didOpenURLContexts
                    .compactMap { contexts in
                        if contexts.contains(where: { DeepLink.isDrivingModeNavigator($0.url) }) {
                            return false
                        } else if contexts.contains(where: { DeepLink.isSpotifyModeNavigator($0.url) }) {
                            return true
                        } else {
                            return nil
                        }
                    }
                    .asObservable()
            ])
            .bind(to: mainView.backgroundView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension DrivingModeViewController {
    static func make() -> DrivingModeViewController {
        DrivingModeViewController()
    }
}
