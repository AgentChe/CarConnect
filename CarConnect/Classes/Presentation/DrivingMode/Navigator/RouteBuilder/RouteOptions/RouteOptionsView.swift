//
//  RouteOptionsView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.05.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class RouteOptionsView: UIView {
    var didClose: ((RouteOptions) -> Void)?
    
    private lazy var rootView = makeRootView()
    
    private lazy var viewModel = RouteOptionsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private let initialOptions: RouteOptions
    
    init(options: RouteOptions) {
        initialOptions = options
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension RouteOptionsView {
    func initialize() {
        backgroundColor = UIColor.clear
        
        let output = viewModel.configure(input: RouteOptionsViewModel.Input(
            didTapClose: rootView.closeButton.rx.tap.asSignal()
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
    }
    
    func action(_ action: RouteOptionsViewModel.Action) {
        switch action {
        case .close:
            let routeOptions = RouteOptions(
                avoidTolls: rootView.avoidTollsView.switchView.isOn,
                avoidHighways: rootView.avoidHighwaysView.switchView.isOn,
                police: rootView.policeView.switchView.isOn,
                speedCameras: rootView.speedCamerasView.switchView.isOn,
                traffic: rootView.trafficView.switchView.isOn
            )
            
            didClose?(routeOptions)
        }
    }
}

// MARK: Make constraints
private extension RouteOptionsView {
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
private extension RouteOptionsView {
    func makeRootView() -> RouteOptionsRootView {
        let view = RouteOptionsRootView(options: initialOptions)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
