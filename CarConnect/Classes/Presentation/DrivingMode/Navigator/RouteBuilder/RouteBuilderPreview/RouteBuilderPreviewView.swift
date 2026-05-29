//
//  RouteBuilderPreviewView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.05.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class RouteBuilderPreviewView: UIView {
    var didClose: (() -> Void)?
    var didTapMenu: (() -> Void)?
    var didTapAddStop: (() -> Void)?
    var didTapStart: ((NavigatorRoute) -> Void)?
    var didReceiveRoute: ((NavigatorRoute?) -> Void)?
    
    private lazy var rootView = makeRootView()
    
    private let viewModel: RouteBuilderPreviewViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    init(
        departureCoordinate: Coordinate,
        destinationPlace: NavigatorPlace,
        routeOptions: RouteOptions,
        waypoints: [NavigatorPlace],
        departureTime: Date?
    ) {
        viewModel = RouteBuilderPreviewViewModel(
            departureCoordinate: departureCoordinate,
            destinationPlace: destinationPlace,
            routeOptions: routeOptions,
            waypoints: waypoints,
            departureTime: departureTime
        )
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension RouteBuilderPreviewView {
    func initialize() {
        backgroundColor = UIColor.clear
        
        let output = viewModel.configure(input: RouteBuilderPreviewViewModel.Input(
            didTapClose: rootView.closeButton.rx.tap.asSignal(),
            didTapMenu: rootView.menuButton.rx.tap.asSignal(),
            didTapAddStop: rootView.addStopButton.rx.tap.asSignal(),
            didTapStart: rootView.startButton.rx.tap.asSignal(),
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        output.activity
            .drive(Binder(rootView) { base, activity in
                activity ? base.preloader.startAnimating() : base.preloader.stopAnimating()
                
                base.label.isHidden = activity
                base.menuButton.isHidden = activity
                base.addStopButton.isHidden = activity
                base.startButton.isHidden = activity
            })
            .disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.rootView.setup(route: route)
                
                base.didReceiveRoute?(route)
            })
            .disposed(by: disposeBag)
    }
    
    func action(_ action: RouteBuilderPreviewViewModel.Action) {
        switch action {
        case .close:
            didClose?()
        case .menu:
            didTapMenu?()
        case .addStop:
            didTapAddStop?()
        case .start(let route):
            didTapStart?(route)
        }
    }
}

// MARK: Make constraints
private extension RouteBuilderPreviewView {
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
private extension RouteBuilderPreviewView {
    func makeRootView() -> RouteBuilderPreviewRootView {
        let view = RouteBuilderPreviewRootView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
