//
//  WidgetCarBrandsListViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 02.04.2026.
//

import RxSwift
import RxCocoa

final class WidgetCarBrandsListViewModel {
    enum Action {
        case close
        case selected(WidgetCarLogoBrand)
    }
    
    private lazy var vehicleManager = VehicleManager()
    
    private let initialBrand: Driver<WidgetCarLogoBrand?>
    
    init(brand: WidgetCarLogoBrand?) {
        self.initialBrand = BehaviorRelay(value: brand).asDriver()
    }
}

// MARK: Public
extension WidgetCarBrandsListViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didEnterName: Signal<String>
        let didSelectElement: Signal<WidgetCarBrandsListTableElement>
    }
    
    struct Output {
        let action: Driver<Action>
        let elements: Driver<[WidgetCarBrandsListTableElement]>
    }
    
    func configure(input: Input) -> Output {
        Output(
            action: makeAction(
                didTapClose: input.didTapClose,
                didSelectElement: input.didSelectElement
            ),
            elements: makeElements(
                didEnterName: input.didEnterName,
                initialBrand: initialBrand
            )
        )
    }
}

// MARK: Private
private extension WidgetCarBrandsListViewModel {
    func makeAction(
        didTapClose: Signal<Void>,
        didSelectElement: Signal<WidgetCarBrandsListTableElement>
    ) -> Driver<Action> {
        let close = didTapClose
            .map { Action.close }
            .asDriver(onErrorDriveWith: .never())
        
        let selected = didSelectElement
            .map { Action.selected($0.brand) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(close, selected)
    }
    
    func makeElements(
        didEnterName: Signal<String>,
        initialBrand: Driver<WidgetCarLogoBrand?>
    ) -> Driver<[WidgetCarBrandsListTableElement]> {
        let brands = vehicleManager
            .fetchVehicleSupportLogos()
            .map { response -> [WidgetCarLogoBrand] in
                let userBrands = (response?.userBrands ?? [])
                let catalogsBrands = (response?.catalogBrands ?? [])
                let brands = userBrands + catalogsBrands
                return brands.map { WidgetCarLogoBrand(logo: $0.logo, model: $0.model) }
            }
            .asDriver(onErrorJustReturn: [])
        
        return Driver
            .combineLatest(
                brands,
                didEnterName.asDriver(onErrorDriveWith: .never()),
                initialBrand
            )
            .map { brands, name, initial -> [WidgetCarBrandsListTableElement] in
                let filteredBrands: [WidgetCarLogoBrand] = {
                    guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return brands }
                    return brands.filter { $0.model.uppercased().contains(name.uppercased()) }
                }()
                
                let count = filteredBrands.count
                
                return filteredBrands.enumerated().map { index, brand -> WidgetCarBrandsListTableElement in
                    let isLast = (count - 1) == index
                    return WidgetCarBrandsListTableElement(
                        brand: brand,
                        checked: brand == initial,
                        corneredTop: index == 0,
                        corneredBottom: isLast,
                        separatorHidden: isLast
                    )
                }
            }
    }
}
