//
//  WidgetTextQuoteViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 23.02.2026.
//

import RxSwift
import RxCocoa

final class WidgetTextQuoteViewModel {
    enum Action {
        case openHelper
    }
    
    private let initialConfiguration: Driver<WidgetTextQuoteConfiguration>
    
    init(configuration: WidgetTextQuoteConfiguration) {
        initialConfiguration = BehaviorRelay(value: configuration).asDriver()
    }
}

// MARK: Public
extension WidgetTextQuoteViewModel {
    struct Input {
        let didTapHelper: Signal<Void>
    }
    
    struct Output {
        let configuration: Driver<WidgetTextQuoteConfiguration>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            configuration: makeConfiguration(initialConfiguration: initialConfiguration),
            action: makeAction(didTapHelper: input.didTapHelper)
        )
    }
}

// MARK: Private
private extension WidgetTextQuoteViewModel {
    func makeConfiguration(initialConfiguration: Driver<WidgetTextQuoteConfiguration>) -> Driver<WidgetTextQuoteConfiguration> {
        initialConfiguration
    }
    
    func makeAction(didTapHelper: Signal<Void>) -> Driver<Action> {
        let openHelper = didTapHelper
            .map { Action.openHelper }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(openHelper)
    }
}
