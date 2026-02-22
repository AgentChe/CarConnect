//
//  WidgetsHelperViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 21.02.2026.
//

import RxSwift
import RxCocoa

final class WidgetsHelperViewModel {
    enum Action {
        case close 
    }
}

// MARK: Public
extension WidgetsHelperViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didSelectTabItem: Signal<WidgetsHelperTabView.TabItem>
    }
    
    struct Output {
        let action: Driver<Action>
        let selectedTab: Driver<WidgetsHelperTabView.TabItem>
        let representation: Driver<WidgetsHelperScrollView.Representation>
    }
    
    func configure(input: Input) -> Output {
        let selectedTab = input.didSelectTabItem
            .startWith(.setup)
            .asDriver(onErrorDriveWith: .never())
            .distinctUntilChanged()
        
        return Output(
            action: makeAction(didTapClose: input.didTapClose),
            selectedTab: selectedTab,
            representation: makeRepresentation(selectedTab: selectedTab)
        )
    }
}

// MARK: Private
private extension WidgetsHelperViewModel {
    func makeAction(didTapClose: Signal<Void>) -> Driver<Action> {
        didTapClose
            .map { Action.close }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeRepresentation(selectedTab: Driver<WidgetsHelperTabView.TabItem>) -> Driver<WidgetsHelperScrollView.Representation> {
        selectedTab.map { tab -> WidgetsHelperScrollView.Representation in
            switch tab {
            case .setup:
                return .setup
            case .carPlay:
                return .carPlay
            case .phone:
                return .phone
            }
        }
    }
}
