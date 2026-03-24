//
//  SelectLocationViewController.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 23.03.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class SelectLocationViewController: UIViewController {
    private lazy var mainView = SelectLocationView()
    
    private let viewModel: SelectLocationViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private let didSelect: (Location) -> Void
    
    private init(location: Location?, didSelect: @escaping (Location) -> Void) {
        self.viewModel = SelectLocationViewModel(location: location)
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
        
        let output = viewModel.configure(input: SelectLocationViewModel.Input(
            didTapClose: mainView.closeButton.rx.tap.asSignal(),
            didEnterName: mainView.searchField.didEnterName,
            didScrollToBottom: mainView.tableView.didScrollToBottom,
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
extension SelectLocationViewController {
    static func make(location: Location?, didSelect: @escaping (Location) -> Void) -> SelectLocationViewController {
        SelectLocationViewController(location: location, didSelect: didSelect)
    }
}

// MARK: Private
private extension SelectLocationViewController {
    func action(_ action: SelectLocationViewModel.Action) {
        switch action {
        case .close:
            dismiss(animated: true)
        case .select(let location):
            dismiss(animated: true) { [weak self] in
                self?.didSelect(location)
            }
        }
    }
}
