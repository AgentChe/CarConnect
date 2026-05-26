//
//  NavigatorViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 21.05.2026.
//

import RxSwift
import RxCocoa

final class NavigatorViewModel {
    enum Action {
        case openSettings
        case showRouteBuilder(Coordinate)
    }
}

// MARK: Public
extension NavigatorViewModel {
    struct Input {
        let didTapResizeMap: Signal<Void>
        let didTapBuildRoute: Signal<Coordinate>
        let didTapUnlockLocationTracking: Signal<Void>
    }
    
    struct Output {
        let mapPresentationState: Driver<NavigatorResizableMapView.MapPresentationState>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            mapPresentationState: makeMapPresentationState(didTapResizeMap: input.didTapResizeMap),
            action: makeAction(
                didTapUnlockLocationTracking: input.didTapUnlockLocationTracking,
                didTapBuildRoute: input.didTapBuildRoute
            )
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
    
    func makeAction(
        didTapUnlockLocationTracking: Signal<Void>,
        didTapBuildRoute: Signal<Coordinate>
    ) -> Driver<Action> {
        let openSettings = didTapUnlockLocationTracking
            .map { Action.openSettings }
            .asDriver(onErrorDriveWith: .never())

        let showRouteBuilder = didTapBuildRoute
            .map { Action.showRouteBuilder($0) }
            .asDriver(onErrorDriveWith: .never())

        return Driver.merge(openSettings, showRouteBuilder)
    }
}
