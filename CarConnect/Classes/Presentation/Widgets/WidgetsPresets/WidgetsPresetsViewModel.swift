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
        case openTextManuallyBuilder
        case openTextQuoteBuilder(WidgetTextQuote, WidgetTextQuoteConfiguration)
    }
}

// MARK: Public
extension WidgetsPresetsViewModel {
    struct Input {
        let didTapHelper: Signal<Void>
        let didSelectTabItem: Signal<WidgetsPresetsTabView.TabItem>
        let didSelectPresetsType: Signal<WidgetsPresetsType>
        let didSelectElement: Signal<WidgetsPresetsTemplatesCollectionElement>
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
            action: makeAction(
                didTapHelper: input.didTapHelper,
                didSelectElement: input.didSelectElement
            ),
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
    func makeAction(
        didTapHelper: Signal<Void>,
        didSelectElement: Signal<WidgetsPresetsTemplatesCollectionElement>
    ) -> Driver<Action> {
        let openWidgetsHelper = didTapHelper
            .map { Action.openWidgetsHelper }
            .asDriver(onErrorDriveWith: .never())
        
        let openBuilder = didSelectElement
            .asDriver(onErrorDriveWith: .never())
            .map { element -> Action in
                switch element {
                case .textManually:
                    return Action.openTextManuallyBuilder
                case .quoteAmbitionDrive(let quote, let config):
                    return .openTextQuoteBuilder(.ambitionDrive(quote), config)
                case .quoteLeadershipImpact(let quote, let config):
                    return .openTextQuoteBuilder(.leadershipImpact(quote), config)
                case .quoteLifeMeaning(let quote, let config):
                    return .openTextQuoteBuilder(.lifeMeaning(quote), config)
                case .quoteMindsetGrowth(let quote, let config):
                    return .openTextQuoteBuilder(.mindsetGrowth(quote), config)
                }
            }
        
        return Driver
            .merge(openWidgetsHelper, openBuilder)
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
