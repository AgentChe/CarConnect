//
//  WidgetsPresetsViewController.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.02.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetsPresetsViewController: UIViewController {
    private lazy var mainView = WidgetsPresetsView()
    
    private lazy var viewModel = WidgetsPresetsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: WidgetsPresetsViewModel.Input(
            didTapHelper: mainView.headerView.helperButton.rx.tap.asSignal(),
            didSelectTabItem: mainView.headerView.tabView.didSelect,
            didSelectPresetsType: mainView.presetsTypesView.didSelect,
            didSelectElement: mainView.collectionView.didSelect
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        output.selectedTabItem
            .drive(Binder(mainView.headerView.tabView) { base, selectedTabItem in
                base.select(tabItem: selectedTabItem)
            })
            .disposed(by: disposeBag)
        
        output.selectedPresetsType
            .drive(Binder(mainView.presetsTypesView) { base, selectedPresetsType in
                base.select(type: selectedPresetsType)
            })
            .disposed(by: disposeBag)
        
        output.collectionElements
            .drive(Binder(mainView.collectionView) { base, elements in
                base.setup(elements: elements)
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

// MARK: Public
extension WidgetsPresetsViewController {
    static func make() -> UIViewController {
        WidgetsPresetsViewController()
    }
}

// MARK: Private
private extension WidgetsPresetsViewController {
    func action(_ action: WidgetsPresetsViewModel.Action) {
        switch action {
        case .openWidgetsHelper:
            let vc = WidgetsHelperViewController.make()
            present(vc, animated: true)
        case .openTextManuallyBuilder:
            break // TODO:
        case .openTextQuoteBuilder(let quote, let config):
            let vc = WidgetTextQuoteViewController.create(quote: quote, configuration: config)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
