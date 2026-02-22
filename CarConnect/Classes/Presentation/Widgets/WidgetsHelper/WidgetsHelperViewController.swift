//
//  WidgetsHelperViewController.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 21.02.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetsHelperViewController: UIViewController {
    private lazy var mainView = WidgetsHelperView()
    
    private lazy var viewModel = WidgetsHelperViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: WidgetsHelperViewModel.Input(
            didTapClose: Signal<Void>
                .merge(
                    mainView.closeButton.rx.tap.asSignal(),
                    mainView.scrollView.didTapAccept
                ),
            didSelectTabItem: mainView.tabView.didTap
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        output.selectedTab
            .drive(Binder(mainView.tabView) { base, selectedTab in
                base.select(tabItem: selectedTab)
            })
            .disposed(by: disposeBag)
        
        output.representation
            .drive(Binder(mainView.scrollView) { base, representation in
                base.accept(representation: representation)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension WidgetsHelperViewController {
    static func make() -> WidgetsHelperViewController {
        WidgetsHelperViewController()
    }
}

// MARK: Private
private extension WidgetsHelperViewController {
    func action(_ action: WidgetsHelperViewModel.Action) {
        switch action {
        case .close:
            dismiss(animated: true)
        }
    }
}
