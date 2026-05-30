//
//  RouteBuilderMenuViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.05.2026.
//

import RxSwift
import RxCocoa

final class RouteBuilderMenuViewModel {
    enum Action {
        case close
        case addStop
        case routeOptions
        case setDepartureTime
    }
}

// MARK: Public
extension RouteBuilderMenuViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didTapAddStop: Signal<Void>
        let didTapRouteOptions: Signal<Void>
        let didTapSetDepartureTime: Signal<Void>
    }
    
    struct Output {
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            action: makeAction(
                didTapClose: input.didTapClose,
                didTapAddStop: input.didTapAddStop,
                didTapRouteOptions: input.didTapRouteOptions,
                didTapSetDepartureTime: input.didTapSetDepartureTime
            )
        )
    }
}

// MARK: Private
private extension RouteBuilderMenuViewModel {
    func makeAction(
        didTapClose: Signal<Void>,
        didTapAddStop: Signal<Void>,
        didTapRouteOptions: Signal<Void>,
        didTapSetDepartureTime: Signal<Void>
    ) -> Driver<Action> {
        let close = didTapClose
            .map { Action.close }
            .asDriver(onErrorDriveWith: .never())
        
        let addStop = didTapAddStop
            .map { Action.addStop }
            .asDriver(onErrorDriveWith: .never())
        
        let routeOptions = didTapRouteOptions
            .map { Action.routeOptions }
            .asDriver(onErrorDriveWith: .never())
        
        let setDepartureTime = didTapSetDepartureTime
            .map { Action.setDepartureTime }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(close, addStop, routeOptions, setDepartureTime)
    }
}
