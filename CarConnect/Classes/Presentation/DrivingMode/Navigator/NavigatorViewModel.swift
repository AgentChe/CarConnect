//
//  NavigatorViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 21.05.2026.
//

import RxSwift
import RxCocoa

final class NavigatorViewModel {}

// MARK: Public
extension NavigatorViewModel {
    struct Input {
        let didTapResizeMap: Signal<Void>
    }
    
    struct Output {
        let mapPresentationState: Driver<NavigatorResizableMapView.MapPresentationState>
    }
    
    func configure(input: Input) -> Output {
        Output(
            mapPresentationState: makeMapPresentationState(didTapResizeMap: input.didTapResizeMap)
        )
    }
}

// MARK: Private
private extension NavigatorViewModel {
    func makeMapPresentationState(didTapResizeMap: Signal<Void>) -> Driver<NavigatorResizableMapView.MapPresentationState> {
        didTapResizeMap
            .scan(.compact) { current, _ -> NavigatorResizableMapView.MapPresentationState in
                switch current {
                case .compact:
                    return .expanded
                case .expanded:
                    return .compact
                }
            }
            .startWith(.compact)
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .never())
    }
}
