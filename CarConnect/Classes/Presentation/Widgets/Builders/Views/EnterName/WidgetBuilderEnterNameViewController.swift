//
//  WidgetBuilderEnterNameViewController.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 08.03.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetBuilderEnterNameViewController: UIViewController {
    private let mainView: WidgetBuilderEnterNameView
    
    private lazy var disposeBag = DisposeBag()
    
    private let save: (String) -> Void
    
    private init(placeholder: String, save: @escaping (String) -> Void) {
        self.mainView = WidgetBuilderEnterNameView(placeholder: placeholder)
        self.save = save
        
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
        
        mainView.didTapSave
            .emit(to: Binder(self) { base, name in
                base.mainView.animateOut {
                    base.dismiss(animated: false) {
                        base.save(name)
                    }
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
extension WidgetBuilderEnterNameViewController {
    static func make(placeholder: String, save: @escaping (String) -> Void) -> WidgetBuilderEnterNameViewController {
        let vc = WidgetBuilderEnterNameViewController(placeholder: placeholder, save: save)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }
}
