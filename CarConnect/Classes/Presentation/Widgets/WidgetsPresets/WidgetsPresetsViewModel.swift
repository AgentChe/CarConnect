//
//  WidgetsPresetsViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.02.2026.
//

import RxSwift
import RxCocoa

final class WidgetsPresetsViewModel {
    enum Action {
        case openWidgetsHelper
    }
}

// MARK: Public
extension WidgetsPresetsViewModel {
    struct Input {
        let didTapHelper: Signal<Void>
        let didSelectTabItem: Signal<WidgetsPresetsTabView.TabItem>
        let didSelectPresetsType: Signal<WidgetsPresetsType>
    }
    
    struct Output {
        let action: Driver<Action>
        let selectedTabItem: Driver<WidgetsPresetsTabView.TabItem>
        let selectedPresetsType: Driver<WidgetsPresetsType>
    }
    
    func configure(input: Input) -> Output {
        let selectedTabItem = input.didSelectTabItem
            .startWith(.widgets)
            .asDriver(onErrorDriveWith: .never())
            .distinctUntilChanged()
        let selectedPresetsType = input.didSelectPresetsType
            .startWith(.calendar)
            .asDriver(onErrorDriveWith: .never())
            .distinctUntilChanged()
        
        return Output(
            action: makeAction(didTapHelper: input.didTapHelper),
            selectedTabItem: selectedTabItem,
            selectedPresetsType: selectedPresetsType
        )
    }
}

// MARK: Private
private extension WidgetsPresetsViewModel {
    func makeAction(didTapHelper: Signal<Void>) -> Driver<Action> {
        let openWidgetsHelper = didTapHelper
            .map { Action.openWidgetsHelper }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(openWidgetsHelper)
    }
}
