//
//  RouteBuilderMenuView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.05.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class RouteBuilderMenuView: UIView {
    var didClose: (() -> Void)?
    var didAddStop: (() -> Void)?
    var didRouteOptions: (() -> Void)?
    var didSetDepartureTime: (() -> Void)?
    
    private lazy var rootView = makeRootView()
    
    private lazy var viewModel = RouteBuilderMenuViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension RouteBuilderMenuView {
    func initialize() {
        backgroundColor = UIColor.clear
        
        let output = viewModel.configure(input: RouteBuilderMenuViewModel.Input(
            didTapClose: rootView.closeButton.rx.tap.asSignal(),
            didTapAddStop: rootView.addStopButton.rx.tap.asSignal(),
            didTapRouteOptions: rootView.routeOptionsButton.rx.tap.asSignal(),
            didTapSetDepartureTime: rootView.setDepartureTimeButton.rx.tap.asSignal()
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
    }
    
    func action(_ action: RouteBuilderMenuViewModel.Action) {
        switch action {
        case .close:
            didClose?()
        case .addStop:
            didAddStop?()
        case .routeOptions:
            didRouteOptions?()
        case .setDepartureTime:
            didSetDepartureTime?()
        }
    }
}

// MARK: Make constraints
private extension RouteBuilderMenuView {
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
private extension RouteBuilderMenuView {
    func makeRootView() -> RouteBuilderMenuRootView {
        let view = RouteBuilderMenuRootView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
