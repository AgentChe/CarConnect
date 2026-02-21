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
    
    private let requestReview: Bool
    
    private init(requestReview: Bool) {
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
                base.coordinator.tap(on: .garage)
                base.mainView.tabView.select(tabItem: .garage)
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
            .bind(to: Binder(self) { base, tappedItem in
                base.coordinator.tap(on: tappedItem)
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
        
        if requestReview {
            RequestReview.request()
        }
    }
}

// MARK: Public
extension MainViewController {
    static func make(requestReview: Bool) -> NavigationController {
        let vc = MainViewController(requestReview: requestReview)
        vc.navigationItem.backButtonTitle = " "
        return NavigationController(rootViewController: vc)
    }
}
