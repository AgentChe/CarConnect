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
        
        Observable<DrivingModeRouteItemButton.Item>
            .merge([
                mainView.menuView.mapItemButton
                    .rx.tap.map { .map },
                mainView.menuView.musicItemButton
                    .rx.tap.map { .music(MusicManager.shared.currentSource.map { .player($0) } ?? .source(current: nil) )},
                mainView.menuView.phoneItemButton
                    .rx.tap.map { .phone },
                SceneDelegateMediator.shared.didOpenURLContexts
                    .compactMap { contexts in
                        if contexts.contains(where: { DeepLink.isDrivingModeNavigator($0.url) }) {
                            return .map
                        } else if contexts.contains(where: { DeepLink.isSpotifyModeNavigator($0.url) }) {
                            return .music(.player(.spotify))
                        } else {
                            return nil
                        }
                    }
                    .asObservable(),
                MusicManager.shared.playerRoute
                    .map { .music($0) }
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
                MusicManager.shared.playerRoute
                    .map { _ in true }
                    .asObservable(),
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
        
        MusicManager.shared.musicSource
            .drive(Binder(mainView) { base, source in
                let image = UIImage(named: DrivingModeRouteItemButton.Item.music(.player(source ?? .appleMusic)).iconName)
                base.menuView.musicItemButton.iconView.image = image
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension DrivingModeViewController {
    static func make() -> DrivingModeViewController {
        DrivingModeViewController()
    }
}
