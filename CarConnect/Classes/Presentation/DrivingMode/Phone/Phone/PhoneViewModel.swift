//
//  PhoneViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.06.2026.
//

import RxSwift
import RxCocoa

final class PhoneViewModel {
    
}

// MARK: Public
extension PhoneViewModel {
    struct Input{
        let didTapTabItem: Signal<PhoneTabItemView.Item>
    }
    
    struct Output {
        let tabItem: Driver<PhoneTabItemView.Item>
    }
    
    func configure(input: Input) -> Output {
        Output(
            tabItem: makeTabItem(didTapTabItem: input.didTapTabItem)
        )
    }
}

// MARK: Private
private extension PhoneViewModel {
    func makeTabItem(didTapTabItem: Signal<PhoneTabItemView.Item>) -> Driver<PhoneTabItemView.Item> {
        didTapTabItem
            .asDriver(onErrorDriveWith: .never())
            .startWith(.contacts)
    }
}
