//
//  WidgetsPreviewViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.02.2026.
//

import RxSwift
import RxCocoa

final class WidgetsPreviewViewModel {
    enum Action {
        case close 
    }
}

// MARK: Public
extension WidgetsPreviewViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didTapTabItem: Signal<WidgetsPreviewTabView.TabItem>
    }
    
    struct Output {
        let action: Driver<Action>
        let tabItem: Driver<WidgetsPreviewTabView.TabItem>
    }
    
    func configure(input: Input) -> Output {
        Output(
            action: makeAction(didTapClose: input.didTapClose),
            tabItem: input.didTapTabItem
                .asDriver(onErrorDriveWith: .never())
                .startWith(.oneWidget)
        )
    }
}

// MARK: Private
private extension WidgetsPreviewViewModel {
    func makeAction(didTapClose: Signal<Void>) -> Driver<Action> {
        let close = didTapClose
            .map { Action.close }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(close)
    }
}
