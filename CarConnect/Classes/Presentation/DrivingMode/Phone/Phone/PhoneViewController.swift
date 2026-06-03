//
//  PhoneViewController.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.06.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class PhoneViewController: UIViewController {
    private lazy var mainView = PhoneView()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tabView.didTap
            .asDriver(onErrorDriveWith: .never())
            .startWith(.contacts)
            .drive(Binder(mainView) { base, item in
                base.setup(selected: item)
            })
            .disposed(by: disposeBag)

        mainView.didSelectContact
            .emit(onNext: { [weak self] contact in
                let controller = ContactDetailViewController(contact: contact)
                self?.navigationController?.pushViewController(controller, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: Public
extension PhoneViewController {
    static func make() -> UIViewController {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        
        let controller = UINavigationController(rootViewController: PhoneViewController())
        controller.navigationBar.standardAppearance = appearance
        controller.navigationBar.scrollEdgeAppearance = appearance
        return controller
    }
}
