//
//  RouteBuilderPreviewViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.05.2026.
//

import RxSwift
import RxCocoa

final class RouteBuilderPreviewViewModel {
    enum Action {
        case close
    }
    
    private lazy var manager = RouteBuilderPreviewManager()
    
    private let departureCoordinate: Driver<Coordinate>
    private let destinationPlace: Driver<NavigatorPlace>
    
    private lazy var activity = RxActivityIndicator()
    
    init(departureCoordinate: Coordinate, destinationPlace: NavigatorPlace) {
        self.departureCoordinate = BehaviorRelay(value: departureCoordinate).asDriver()
        self.destinationPlace = BehaviorRelay(value: destinationPlace).asDriver()
    }
}

// MARK: Public
extension RouteBuilderPreviewViewModel {
    struct Input {
        let didTapClose: Signal<Void>
    }
    
    struct Output {
        let action: Driver<Action>
        let activity: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        Output(
            action: makeAction(
                didTapClose: input.didTapClose
            ),
            activity: activity.asDriver()
        )
    }
}

// MARK: Private
private extension RouteBuilderPreviewViewModel {
    func makeAction(
        didTapClose: Signal<Void>
    ) -> Driver<Action> {
        let close = didTapClose
            .map { Action.close }
            .asDriver(onErrorDriveWith: .never())

        return Driver
            .merge(close)
    }
}
