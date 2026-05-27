//
//  RouteOptionsViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.05.2026.
//

import RxSwift
import RxCocoa

final class RouteOptionsViewModel {
    enum Action {
        case close
    }
}

// MARK: Public
extension RouteOptionsViewModel {
    struct Input {
        let didTapClose: Signal<Void>
    }
    
    struct Output {
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            action: makeAction(didTapClose: input.didTapClose)
        )
    }
}

// MARK: Private
private extension RouteOptionsViewModel {
    func makeAction(didTapClose: Signal<Void>) -> Driver<Action> {
        didTapClose
            .map { Action.close }
            .asDriver(onErrorDriveWith: .never())
    }
}
