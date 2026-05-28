//
//  RouteBuilderDepartureTimeView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.05.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class RouteBuilderDepartureTimeView: UIView {
    var didClose: (() -> Void)?
    var didReset: (() -> Void)?
    var didDone: ((Date) -> Void)?
    
    private lazy var rootView = makeRootView()
    
    private lazy var viewModel = RouteBuilderDepartureTimeViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private let initialDate: Date?
    
    init(date: Date?) {
        self.initialDate = date
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension RouteBuilderDepartureTimeView {
    func initialize() {
        backgroundColor = UIColor.clear
        rootView.datePicker.date = initialDate ?? Date()
        
        let output = viewModel.configure(input: RouteBuilderDepartureTimeViewModel.Input(
            didTapClose: rootView.closeButton.rx.tap.asSignal(),
            didTapReset: rootView.resetButton.rx.tap.asSignal(),
            didTapDone: rootView.doneButton.rx.tap.asSignal()
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
    }
    
    func action(_ action: RouteBuilderDepartureTimeViewModel.Action) {
        switch action {
        case .close:
            didClose?()
        case .reset:
            didReset?()
        case .done:
            didDone?(rootView.datePicker.date)
        }
    }
}

// MARK: Make constraints
private extension RouteBuilderDepartureTimeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            rootView.leadingAnchor.constraint(equalTo: leadingAnchor),
            rootView.trailingAnchor.constraint(equalTo: trailingAnchor),
            rootView.topAnchor.constraint(equalTo: topAnchor),
            rootView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension RouteBuilderDepartureTimeView {
    func makeRootView() -> RouteBuilderDepartureTimeRootView {
        let view = RouteBuilderDepartureTimeRootView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
