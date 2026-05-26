//
//  SearchPlaceViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 26.05.2026.
//

import RxSwift
import RxCocoa

final class SearchPlaceViewModel {
    enum Action {
        case close
        case selected(NavigatorPlace)
    }
    
    private lazy var manager = RouteBuilderManager()
    
    private let userCoordinate: Driver<Coordinate>
    
    private lazy var activity = RxActivityIndicator()
    
    init(coordinate: Coordinate) {
        userCoordinate = BehaviorRelay(value: coordinate).asDriver()
    }
}

// MARK: Public
extension SearchPlaceViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didEnterAddress: Signal<String>
        let didSelectElement: Signal<SearchPlaceTableElement>
    }
    
    struct Output {
        let action: Driver<Action>
        let elements: Driver<[SearchPlaceTableElement]>
        let activity: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        Output(
            action: makeAction(
                didTapClose: input.didTapClose,
                didSelectElement: input.didSelectElement
            ),
            elements: makeElements(
                didEnterAddress: input.didEnterAddress,
                didSelectElement: input.didSelectElement
            ),
            activity: activity.asDriver()
        )
    }
}

// MARK: Private
private extension SearchPlaceViewModel {
    func makeAction(
        didTapClose: Signal<Void>,
        didSelectElement: Signal<SearchPlaceTableElement>
    ) -> Driver<Action> {
        let close = didTapClose
            .map { Action.close }
            .asDriver(onErrorDriveWith: .never())
        
        let selected = didSelectElement
            .asDriver(onErrorDriveWith: .never())
            .flatMapLatest { [weak self] element -> Driver<Action> in
                guard let self else { return .empty() }

                switch element {
                case .preset:
                    return .empty()

                case .place(.fromPreset(let place)):
                    return .just(.selected(place))

                case .place(.searched(let place)):
                    return manager
                        .fetchPlaceDetails(placeId: place.id)
                        .compactMap { $0 }
                        .map { Action.selected($0) }
                        .trackActivity(activity)
                        .asDriver(onErrorDriveWith: .empty())
                }
            }

        return Driver
            .merge(close, selected)
    }
    
    func makeElements(
        didEnterAddress: Signal<String>,
        didSelectElement: Signal<SearchPlaceTableElement>
    ) -> Driver<[SearchPlaceTableElement]> {
        let presets = NavigatorPreset.allCases.map { SearchPlaceTableElement.preset($0) }

        let searchByAddress = didEnterAddress
            .debounce(.milliseconds(500))
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(userCoordinate) { ($0, $1) }
            .flatMapLatest { [weak self] query, coordinate -> Driver<[SearchPlaceTableElement]> in
                guard let self else { return .just(presets) }

                let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else { return .just(presets) }

                return manager
                    .searchPlaces(query: trimmed, coordinate: coordinate)
                    .map { $0.map { SearchPlaceTableElement.place(.searched($0)) } }
                    .trackActivity(activity)
                    .asDriver(onErrorJustReturn: [])
            }

        let searchByPreset = didSelectElement
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(userCoordinate) { ($0, $1) }
            .flatMapLatest { [weak self] element, coordinate -> Driver<[SearchPlaceTableElement]> in
                guard let self, case .preset(let preset) = element else { return .empty() }

                return manager
                    .searchNearby(preset: preset, coordinate: coordinate)
                    .map { $0.map { SearchPlaceTableElement.place(.fromPreset($0)) } }
                    .trackActivity(activity)
                    .asDriver(onErrorJustReturn: [])
            }

        return Driver.merge(
            .just(presets),
            searchByAddress,
            searchByPreset
        )
    }
}
