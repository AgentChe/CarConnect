//
//  SearchPlaceView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 26.05.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchPlaceView: UIView {
    var didClose: (() -> Void)?
    var didSelectPlace: ((NavigatorPlace) -> Void)?
    var didLookingAtPresetPlaces: (([NavigatorPlace]) -> Void)?
    
    private lazy var rootView = makeRootView()
    
    private let viewModel: SearchPlaceViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    init(coordinate: Coordinate) {
        viewModel = SearchPlaceViewModel(coordinate: coordinate)
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension SearchPlaceView {
    func initialize() {
        backgroundColor = UIColor.clear
        
        let output = viewModel.configure(input: SearchPlaceViewModel.Input(
            didTapClose: rootView.closeButton.rx.tap.asSignal(),
            didEnterAddress: rootView.searchField.didEnterAddress,
            didSelectElement: rootView.tableView.didSelect
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(self) { base, elements in
                base.rootView.tableView.setup(elements: elements)
                
                let presetPlaces = elements.compactMap { element -> NavigatorPlace? in
                    switch element {
                    case .preset:
                        return nil
                    case .place(let element):
                        switch element {
                        case .fromPreset(let place):
                            return place
                        case .searched:
                            return nil
                        }
                    }
                }
                base.didLookingAtPresetPlaces?(presetPlaces)
            })
            .disposed(by: disposeBag)
        
        output.activity
            .drive(Binder(rootView) { base, activity in
                base.tableView.isHidden = activity
                activity ? base.preloader.startAnimating() : base.preloader.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        rootView.tableView.rx.willBeginDragging
            .bind(to: rootView.rx.hideKeyboardObserver)
            .disposed(by: disposeBag)
    }
    
    func action(_ action: SearchPlaceViewModel.Action) {
        switch action {
        case .close:
            didClose?()
        case .selected(let place):
            didSelectPlace?(place)
        }
    }
}

// MARK: Make constraints
private extension SearchPlaceView {
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
private extension SearchPlaceView {
    func makeRootView() -> SearchPlaceRootView {
        let view = SearchPlaceRootView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
