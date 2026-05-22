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
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: NavigatorViewModel.Input(
            didTapResizeMap: mainView.mapView.resizeButton.rx.tap.asSignal()
        ))
        
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
    
}
