//
//  RouteBuilderDepartureTimeViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.05.2026.
//

import RxSwift
import RxCocoa

final class RouteBuilderDepartureTimeViewModel {
    enum Action {
        case close
        case reset
        case done
    }
}

// MARK: Public
extension RouteBuilderDepartureTimeViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didTapReset: Signal<Void>
        let didTapDone: Signal<Void>
    }
    
    struct Output {
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            action: makeAction(
                didTapClose: input.didTapClose,
                didTapReset: input.didTapReset,
                didTapDone: input.didTapDone
            )
        )
    }
}

// MARK: Private
private extension RouteBuilderDepartureTimeViewModel {
    func makeAction(
        didTapClose: Signal<Void>,
        didTapReset: Signal<Void>,
        didTapDone: Signal<Void>
    ) -> Driver<Action> {
        let close = didTapClose
            .map { Action.close }
            .asDriver(onErrorDriveWith: .never())
        
        let reset = didTapReset
            .map { Action.reset }
            .asDriver(onErrorDriveWith: .never())
        
        let done = didTapDone
            .map { Action.done }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(close, reset, done)
    }
}
