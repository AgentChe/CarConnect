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
        let collectionElements: Driver<[WidgetsPresetsTemplatesCollectionElement]>
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
            selectedPresetsType: selectedPresetsType,
            collectionElements: makeCollectionElements(
                selectedTabItem: selectedTabItem,
                selectedPresetsType: selectedPresetsType
            )
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
    
    // TODO:
    func makeCollectionElements(
        selectedTabItem: Driver<WidgetsPresetsTabView.TabItem>,
        selectedPresetsType: Driver<WidgetsPresetsType>
    ) -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
        Driver
            .combineLatest(selectedTabItem, selectedPresetsType)
            .map { tabItem, presetsType -> [WidgetsPresetsTemplatesCollectionElement] in
                let saved = tabItem == .saved
                
                switch presetsType {
                case .all:
                    return []
                case .calendar:
                    return []
                case .clock:
                    return []
                case .carLogo:
                    return []
                case .text:
                    return saved ? [] : [
                        WidgetsPresetsTemplatesCollectionElement.textManually(WidgetTextManuallyConfiguration.default()),
                        {
                            guard let template = WidgetTextQuoteMindsetGrowth.templates().first else { return nil }
                            return .quoteMindsetGrowth(template, WidgetTextQuoteConfiguration.mindsetGrowthDefault())
                        }(),
                        {
                            guard let template = WidgetTextQuoteAmbitionDrive.templates().first else { return nil }
                            return .quoteAmbitionDrive(template, WidgetTextQuoteConfiguration.ambitionDriveDefault())
                        }(),
                        {
                            guard let template = WidgetTextQuoteLeadershipImpact.templates().first else { return nil }
                            return .quoteLeadershipImpact(template, WidgetTextQuoteConfiguration.leadershipImpactDefault())
                        }(),
                        {
                            guard let template = WidgetTextQuoteLifeMeaning.templates().first else { return nil }
                            return .quoteLifeMeaning(template, WidgetTextQuoteConfiguration.lifeMeaningDefault())
                        }()
                    ].compactMap { $0 }
                case .photo:
                    return []
                case .weather:
                    return []
                }
            }
    }
}
