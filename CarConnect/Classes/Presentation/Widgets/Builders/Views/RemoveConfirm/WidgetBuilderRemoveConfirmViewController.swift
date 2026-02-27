//
//  WidgetBuilderRemoveConfirmViewController.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.02.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetBuilderRemoveConfirmViewController: UIViewController {
    private lazy var mainView = WidgetBuilderRemoveConfirmView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let remove: () -> Void
    
    private init(remove: @escaping () -> Void) {
        self.remove = remove
        
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
        
        mainView.removeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.mainView.animateOut {
                    base.dismiss(animated: false) {
                        base.remove()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        mainView.cancelButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.mainView.animateOut {
                    base.dismiss(animated: false)
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainView.animateIn()
    }
}

// MARK: Public
extension WidgetBuilderRemoveConfirmViewController {
    static func make(remove: @escaping () -> Void) -> WidgetBuilderRemoveConfirmViewController {
        let vc = WidgetBuilderRemoveConfirmViewController(remove: remove)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }
}
