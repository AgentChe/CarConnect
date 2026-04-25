//
//  WidgetCarBrandsListViewController.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 02.04.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetCarBrandsListViewController: UIViewController {
    private lazy var mainView = WidgetCarBrandsListView()
    
    private let viewModel: WidgetCarBrandsListViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private let didSelect: (WidgetCarLogoBrand) -> Void
    
    init(brand: WidgetCarLogoBrand?, didSelect: @escaping (WidgetCarLogoBrand) -> Void) {
        self.viewModel = WidgetCarBrandsListViewModel(brand: brand)
        self.didSelect = didSelect
        
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
        
        mainView.tableView.rx.willBeginDragging
            .bind(to: mainView.rx.hideKeyboardObserver)
            .disposed(by: disposeBag)
        
        let output = viewModel.configure(input: WidgetCarBrandsListViewModel.Input(
            didTapClose: mainView.closeButton.rx.tap.asSignal(),
            didEnterName: mainView.searchField.didEnterName,
            didSelectElement: mainView.tableView.didSelect
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension WidgetCarBrandsListViewController {
    static func make(brand: WidgetCarLogoBrand?, didSelect: @escaping (WidgetCarLogoBrand) -> Void) -> WidgetCarBrandsListViewController {
        WidgetCarBrandsListViewController(brand: brand, didSelect: didSelect)
    }
}

// MARK: Private
private extension WidgetCarBrandsListViewController {
    func action(_ action: WidgetCarBrandsListViewModel.Action) {
        switch action {
        case .close:
            dismiss(animated: true)
        case .selected(let brand):
            dismiss(animated: true) { [weak self] in
                self?.didSelect(brand)
            }
        }
    }
}
