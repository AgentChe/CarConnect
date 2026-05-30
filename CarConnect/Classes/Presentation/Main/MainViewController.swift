//
//  MainViewController.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 21.02.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    private lazy var mainView = MainView()
    
    private lazy var coordinator = MainCoordinator(
        parentVC: self,
        container: mainView.container
    )
    
    private lazy var disposeBag = DisposeBag()
    
    private let deepLinkIntent: DeepLinkIntent?
    private let requestReview: Bool
    
    private init(
        deepLinkIntent: DeepLinkIntent?,
        requestReview: Bool
    ) {
        self.deepLinkIntent = deepLinkIntent
        self.requestReview = requestReview

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .take(1)
            .bind(to: Binder(self) { base, _ in
                let tabItem: TabView.TabItem = base.deepLinkIntent == .openDrivingModeNavigator ? .drivingMode : .garage
                
                base.coordinator.tap(on: tabItem)
                base.mainView.tabView.select(tabItem: tabItem)
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge([
                mainView.tabView.garageButton
                    .rx.tap.map { TabView.TabItem.garage },
                mainView.tabView.widgetsButton
                    .rx.tap.map { TabView.TabItem.widgets },
                mainView.tabView.drivingModeButton
                    .rx.tap.map { TabView.TabItem.drivingMode }
            ])
            .bind(to: Binder(coordinator) { base, tappedItem in
                base.tap(on: tappedItem)
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge([
                mainView.tabView.garageButton
                    .rx.tap.map { TabView.TabItem.garage },
                mainView.tabView.widgetsButton
                    .rx.tap.map { TabView.TabItem.widgets }
            ])
            .bind(to: Binder(self) { base, tappedItem in
                base.mainView.tabView.select(tabItem: tappedItem)
            })
            .disposed(by: disposeBag)
        
        SceneDelegateMediator.shared.didOpenURLContexts
            .filter { $0.contains(where: { DeepLink.isDrivingModeNavigator($0.url) }) }
            .emit(to: Binder(coordinator) { base, _ in
                base.tap(on: .drivingMode)
            })
            .disposed(by: disposeBag)
        
        if requestReview {
            RequestReview.request()
        }
    }
}

// MARK: Public
extension MainViewController {
    static func make(
        deepLinkIntent: DeepLinkIntent? = nil,
        requestReview: Bool
    ) -> NavigationController {
        let vc = MainViewController(
            deepLinkIntent: deepLinkIntent,
            requestReview: requestReview
        )
        vc.navigationItem.backButtonTitle = " "
        return NavigationController(rootViewController: vc)
    }
}
