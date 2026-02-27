//
//  WidgetsPreviewViewController.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.02.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetsPreviewViewController: UIViewController {
    private let mainView: WidgetsPreviewView
    
    private lazy var viewModel = WidgetsPreviewViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private init(snapshot: UIImage) {
        mainView = WidgetsPreviewView(snapshot: snapshot)
        
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
        
        let output = viewModel.configure(input: WidgetsPreviewViewModel.Input(
            didTapClose: mainView.closeButton.rx.tap.asSignal(),
            didTapTabItem: mainView.tabView.didTap
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        output.tabItem
            .drive(Binder(mainView) { base, tabItem in
                base.tabView.select(tabItem: tabItem)
                
                base.carPlayView.setup(count: {
                    switch tabItem {
                    case .oneWidget:
                        return .one
                    case .twoWidgets:
                        return .two
                    case .threeWidgets:
                        return .three
                    }
                }())
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension WidgetsPreviewViewController {
    static func make(snapshot: UIImage) -> WidgetsPreviewViewController {
        WidgetsPreviewViewController(snapshot: snapshot)
    }
}

// MARK: Private
private extension WidgetsPreviewViewController {
    func action(_ action: WidgetsPreviewViewModel.Action) {
        switch action {
        case .close:
            dismiss(animated: true)
        }
    }
}
