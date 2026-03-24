//
//  SelectLocationViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 23.03.2026.
//

import RxSwift
import RxCocoa

final class SelectLocationViewModel {
    enum Action {
        case close
        case select(Location)
    }
    
    private let initialLocation: Driver<Location?>
    
    private lazy var locationManager = LocationManager()
    
    private lazy var geoLocationAPI = GeoLocationAPI()
    
    init(location: Location?) {
        self.initialLocation = BehaviorRelay(value: location).asDriver()
    }
}

// MARK: Public
extension SelectLocationViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didEnterName: Signal<String>
        let didScrollToBottom: Signal<Void>
        let didSelectElement: Signal<SelectLocationTableElement>
    }
    
    struct Output {
        let action: Driver<Action>
        let elements: Driver<[SelectLocationTableElement]>
    }
    
    func configure(input: Input) -> Output {
        Output(
            action: makeAction(
                didTapClose: input.didTapClose,
                didSelectElement: input.didSelectElement
            ),
            elements: makeElements(
                myLocation: makeMyLocation(),
                didEnterName: input.didEnterName,
                didScrollToBottom: input.didScrollToBottom,
                initialLocation: initialLocation
            )
        )
    }
}

// MARK: Private
private extension SelectLocationViewModel {
    func makeAction(
        didTapClose: Signal<Void>,
        didSelectElement: Signal<SelectLocationTableElement>
    ) -> Driver<Action> {
        let close = didTapClose
            .map { Action.close }
            .asDriver(onErrorDriveWith: .never())
        
        let select = didSelectElement
            .compactMap { element -> Location? in
                switch element {
                case .myGeo(let location):
                    return location
                case .location(let element):
                    return element.location
                default:
                    return nil
                }
            }
            .map { Action.select($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(close, select)
    }
    
    func makeElements(
        myLocation: Driver<Location?>,
        didEnterName: Signal<String>,
        didScrollToBottom: Signal<Void>,
        initialLocation: Driver<Location?>
    ) -> Driver<[SelectLocationTableElement]> {
        let enteredName = didEnterName
            .debounce(RxTimeInterval.milliseconds(300))
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .combineLatest(myLocation, enteredName, initialLocation)
            .flatMapLatest { [weak self] myLocation, enteredName, initialLocation -> Driver<[SelectLocationTableElement]> in
                guard let self else { return .never() }
                
                if enteredName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    var result = [SelectLocationTableElement]()
                    if let myLocation {
                        result.append(.myGeo(myLocation))
                    }
                    result.append(.enterName)
                    return .just(result)
                } else {
                    return makePageLocations(
                        enteredName: enteredName,
                        didScrollToBottom: didScrollToBottom
                    )
                    .scan([]) { elements, page -> [Location] in
                        page.info.current == 1 ? page.elements : (elements + page.elements)
                    }
                    .map { locations -> [SelectLocationTableElement] in
                        let count = locations.count
                        return locations.enumerated().map { index, location -> SelectLocationTableElement in
                            let isLast = (count - 1) == index
                            let element = SelectLocationElement(
                                location: location,
                                checked: location.isEqualByParams(initialLocation),
                                corneredTop: index == 0,
                                corneredBottom: isLast,
                                separatorHidden: isLast
                            )
                            return SelectLocationTableElement.location(element)
                        }
                    }
                }
            }
    }
    
    func makeMyLocation() -> Driver<Location?> {
        Single<Location?>
            .create { [weak self] single in
                guard let self else { return Disposables.create() }
                
                geoLocationAPI.requestMyLocation { location in
                    single(.success(location))
                }
                
                return Disposables.create()
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makePageLocations(
        enteredName: String,
        didScrollToBottom: Signal<Void>
    ) -> Driver<Page<[Location]>> {
        var lastPageInfo: PageInfo?
        
        func fetch(search: String, page: Int) -> Driver<Page<[Location]>> {
            locationManager
                .fetchLocations(search: search, page: page)
                .asDriver(onErrorJustReturn: nil)
                .compactMap { $0 }
                .do(onNext: { page in
                    lastPageInfo = page.info
                })
        }
        
        let firstPage = fetch(search: enteredName, page: 1)
        let downloadedPage = firstPage
            .flatMapLatest { firstPage -> Driver<Page<[Location]>> in
                didScrollToBottom
                    .asDriver(onErrorDriveWith: .never())
                    .compactMap { lastPageInfo }
                    .filter { lastPageInfo -> Bool in
                        let nextPageNotTotal = lastPageInfo.next <= lastPageInfo.total
                        let currentNotTotal = lastPageInfo.current != lastPageInfo.total
                        return nextPageNotTotal && currentNotTotal
                    }
                    .flatMapFirst { lastPageInfo -> Driver<Page<[Location]>> in
                        fetch(search: enteredName, page: lastPageInfo.next)
                    }
                    .startWith(firstPage)
            }
        return downloadedPage
    }
}

// MARK: Additional
private extension Location {
    func isEqualByParams(_ location: Location?) -> Bool {
        (name == location?.name) && (coordinate == location?.coordinate)
    }
}
