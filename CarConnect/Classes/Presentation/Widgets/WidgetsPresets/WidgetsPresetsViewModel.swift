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
        case openTextQuoteBuilder(String?, WidgetTextQuote, WidgetTextQuoteConfiguration)
    }
    
    private lazy var textStorage = WidgetTextStorage()
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
                case .quoteAmbitionDrive(let storageModelId, let quote, let config):
                    return .openTextQuoteBuilder(storageModelId, .ambitionDrive(quote), config)
                case .quoteLeadershipImpact(let storageModelId, let quote, let config):
                    return .openTextQuoteBuilder(storageModelId, .leadershipImpact(quote), config)
                case .quoteLifeMeaning(let storageModelId, let quote, let config):
                    return .openTextQuoteBuilder(storageModelId, .lifeMeaning(quote), config)
                case .quoteMindsetGrowth(let storageModelId, let quote, let config):
                    return .openTextQuoteBuilder(storageModelId, .mindsetGrowth(quote), config)
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
            .flatMapLatest { [weak self] tabItem, presetsType -> Driver<[WidgetsPresetsTemplatesCollectionElement]> in
                guard let self else { return .just([]) }
                
                let saved = tabItem == .saved
                
                switch presetsType {
                case .all:
                    return .just([])
                case .calendar:
                    return .just([])
                case .clock:
                    return .just([])
                case .carLogo:
                    return .just([])
                case .text:
                    return makeTextElements(isSaved: saved)
                case .photo:
                    return .just([])
                case .weather:
                    return .just([])
                }
            }
    }
    
    func makeTextElements(isSaved: Bool) -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
        func saved() -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
            enum Action {
                case initial([WidgetTextQuoteStorageModel])
                case added(WidgetTextQuoteStorageModel)
                case edited(WidgetTextQuoteStorageModel)
                case deleted(String)
            }
            
            let initial = textStorage
                .fetchQuotes()
                .map { Action.initial($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let added = WidgetTextStorageMediator.shared
                .didSavedQuoteModel
                .map { Action.added($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let edited = WidgetTextStorageMediator.shared
                .didEditedQuoteModel
                .map { Action.edited($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let deleted = WidgetTextStorageMediator.shared
                .didDeletedQuoteModelId
                .map { Action.deleted($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let action = Driver
                .merge(initial, added, edited, deleted)
            
            let models = action
                .scan([]) { models, action -> [WidgetTextQuoteStorageModel] in
                    switch action {
                    case .initial(let models):
                        return models
                    case .added(let model):
                        var result = models
                        result.append(model)
                        return result
                    case .edited(let model):
                        var result = models
                        if let index = result.firstIndex(where: { $0.id == model.id }) {
                            result[index] = model
                        }
                        return result
                    case .deleted(let id):
                        var result = models
                        result.removeAll(where: { $0.id == id })
                        return result
                    }
                }
            
            return models
                .map { models -> [WidgetsPresetsTemplatesCollectionElement] in
                    models.map { model -> WidgetsPresetsTemplatesCollectionElement in
                        switch model.quote {
                        case .ambitionDrive(let quote):
                            return .quoteAmbitionDrive(model.id, quote, model.configuration)
                        case .mindsetGrowth(let quote):
                            return .quoteMindsetGrowth(model.id, quote, model.configuration)
                        case .leadershipImpact(let quote):
                            return .quoteLeadershipImpact(model.id, quote, model.configuration)
                        case .lifeMeaning(let quote):
                            return .quoteLifeMeaning(model.id, quote, model.configuration)
                        }
                    }
                }
        }
        
        func templates() -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
            Single
                .deferred {
                    let templates = [
                        WidgetsPresetsTemplatesCollectionElement.textManually(WidgetTextManuallyConfiguration.default()),
                        {
                            guard let template = WidgetTextQuoteMindsetGrowth.templates().first else { return nil }
                            return .quoteMindsetGrowth(nil, template, WidgetTextQuoteConfiguration.mindsetGrowthDefault())
                        }(),
                        {
                            guard let template = WidgetTextQuoteAmbitionDrive.templates().first else { return nil }
                            return .quoteAmbitionDrive(nil, template, WidgetTextQuoteConfiguration.ambitionDriveDefault())
                        }(),
                        {
                            guard let template = WidgetTextQuoteLeadershipImpact.templates().first else { return nil }
                            return .quoteLeadershipImpact(nil, template, WidgetTextQuoteConfiguration.leadershipImpactDefault())
                        }(),
                        {
                            guard let template = WidgetTextQuoteLifeMeaning.templates().first else { return nil }
                            return .quoteLifeMeaning(nil, template, WidgetTextQuoteConfiguration.lifeMeaningDefault())
                        }()
                    ].compactMap { $0 }
                    
                    return .just(templates)
                }
                .asDriver(onErrorDriveWith: .never())
        }
        
        return isSaved ? saved() : templates()
    }
}
