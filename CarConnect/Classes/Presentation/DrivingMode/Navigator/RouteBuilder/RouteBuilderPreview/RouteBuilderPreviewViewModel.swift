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
        case menu
        case addStop
        case start(NavigatorRoute)
    }
    
    private lazy var manager = RouteBuilderPreviewManager()
    
    private let departureCoordinate: Driver<Coordinate>
    private let destinationPlace: Driver<NavigatorPlace>
    private let routeOptions: Driver<RouteOptions>
    private let waypoints: Driver<[NavigatorPlace]>
    private let departureTime: Driver<Date?>
    
    private lazy var activity = RxActivityIndicator()
    
    init(
        departureCoordinate: Coordinate,
        destinationPlace: NavigatorPlace,
        routeOptions: RouteOptions,
        waypoints: [NavigatorPlace],
        departureTime: Date?
    ) {
        self.departureCoordinate = BehaviorRelay(value: departureCoordinate).asDriver()
        self.destinationPlace = BehaviorRelay(value: destinationPlace).asDriver()
        self.routeOptions = BehaviorRelay(value: routeOptions).asDriver()
        self.waypoints = BehaviorRelay(value: waypoints).asDriver()
        self.departureTime = BehaviorRelay(value: departureTime).asDriver()
    }
}

// MARK: Public
extension RouteBuilderPreviewViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didTapMenu: Signal<Void>
        let didTapAddStop: Signal<Void>
        let didTapStart: Signal<Void>
        let didTapTryAgain: Signal<Void>
    }
    
    struct Output {
        let action: Driver<Action>
        let activity: Driver<Bool>
        let route: Driver<NavigatorRoute?>
    }
    
    func configure(input: Input) -> Output {
        let route = makeRoute(
            didTapTryAgain: input.didTapTryAgain,
            departureCoordinate: departureCoordinate,
            destinationPlace: destinationPlace,
            routeOptions: routeOptions,
            waypoints: waypoints,
            departureTime: departureTime
        )
        
        return Output(
            action: makeAction(
                didTapClose: input.didTapClose,
                didTapMenu: input.didTapMenu,
                didTapAddStop: input.didTapAddStop,
                didTapStart: input.didTapStart,
                route: route
            ),
            activity: activity.asDriver(),
            route: route
        )
    }
}

// MARK: Private
private extension RouteBuilderPreviewViewModel {
    func makeAction(
        didTapClose: Signal<Void>,
        didTapMenu: Signal<Void>,
        didTapAddStop: Signal<Void>,
        didTapStart: Signal<Void>,
        route: Driver<NavigatorRoute?>
    ) -> Driver<Action> {
        let close = didTapClose
            .map { Action.close }
            .asDriver(onErrorDriveWith: .never())
        
        let menu = didTapMenu
            .map { Action.menu }
            .asDriver(onErrorDriveWith: .never())
        
        let addStop = didTapAddStop
            .map { Action.addStop }
            .asDriver(onErrorDriveWith: .never())
        
        let start = didTapStart
            .withLatestFrom(route)
            .compactMap { $0 }
            .map { Action.start($0) }
            .asDriver(onErrorDriveWith: .never())

        return Driver
            .merge(close, menu, addStop, start)
    }
    
    func makeRoute(
        didTapTryAgain: Signal<Void>,
        departureCoordinate: Driver<Coordinate>,
        destinationPlace: Driver<NavigatorPlace>,
        routeOptions: Driver<RouteOptions>,
        waypoints: Driver<[NavigatorPlace]>,
        departureTime: Driver<Date?>
    ) -> Driver<NavigatorRoute?> {
        let params = Driver.combineLatest(
            departureCoordinate,
            destinationPlace,
            routeOptions,
            waypoints,
            departureTime
        )

        let trigger = Signal
            .merge(.just(()), didTapTryAgain)
            .asDriver(onErrorDriveWith: .never())

        return trigger
            .withLatestFrom(params)
            .flatMapLatest { [weak self] departureCoordinate, destinationPlace, routeOptions, waypoints, departureTime -> Driver<NavigatorRoute?> in
                guard let self else { return .never() }

                return manager
                    .fetchDirections(
                        destination: destinationPlace,
                        departureCoordinate: departureCoordinate,
                        waypoints: waypoints,
                        avoidTolls: routeOptions.avoidTolls,
                        avoidHighways: routeOptions.avoidHighways,
                        departureTime: departureTime,
                        police: routeOptions.police,
                        speedCameras: routeOptions.speedCameras,
                        traffic: routeOptions.traffic
                    )
                    .trackActivity(activity)
                    .asDriver(onErrorJustReturn: nil)
            }
    }
}
