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
    
    private lazy var textService = WidgetTextService()
}

// MARK: Public
extension WidgetsPresetsViewModel {
    struct Input {
        let didTapHelper: Signal<Void>
        let didTapOpenHelperFromCollection: Signal<Void>
        let didSelectTabItem: Signal<WidgetsPresetsTabView.TabItem>
        let didSelectPresetsType: Signal<WidgetsPresetsType>
        let didSelectElement: Signal<WidgetsPresetsTemplatesCollectionElement>
        let didTapGoToCatalog: Signal<Void>
    }
    
    struct Output {
        let action: Driver<Action>
        let selectedTabItem: Driver<WidgetsPresetsTabView.TabItem>
        let selectedPresetsType: Driver<WidgetsPresetsType>
        let collectionElements: Driver<[WidgetsPresetsTemplatesCollectionElement]>
        let emptyHidden: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let selectedTabItem = makeSelectedTabItem(
            didSelectTabItem: input.didSelectTabItem,
            didTapGoToCatalog: input.didTapGoToCatalog
        )
        let selectedPresetsType = input.didSelectPresetsType
            .startWith(.calendar)
            .asDriver(onErrorDriveWith: .never())
            .distinctUntilChanged()
        let collectionElements = makeCollectionElements(
            selectedTabItem: selectedTabItem,
            selectedPresetsType: selectedPresetsType,
            helperCellWasDisplayed: makeHelperCellWasDisplayed(didTapOpenHelperFromCollection: input.didTapOpenHelperFromCollection)
        )
        
        return Output(
            action: makeAction(
                didTapHelper: input.didTapHelper,
                didTapOpenHelperFromCollection: input.didTapOpenHelperFromCollection,
                didSelectElement: input.didSelectElement
            ),
            selectedTabItem: selectedTabItem,
            selectedPresetsType: selectedPresetsType,
            collectionElements: collectionElements,
            emptyHidden: makeEmptyHidden(
                selectedTabItem: selectedTabItem,
                elements: collectionElements
            )
        )
    }
}

// MARK: Private
private extension WidgetsPresetsViewModel {
    enum Constants {
        static let helperCellWasDisplayed = "helpder_cell_was_displayed" 
    }
    
    func makeSelectedTabItem(
        didSelectTabItem: Signal<WidgetsPresetsTabView.TabItem>,
        didTapGoToCatalog: Signal<Void>
    ) -> Driver<WidgetsPresetsTabView.TabItem> {
        let selectTab = didSelectTabItem
            .startWith(.widgets)
            .asDriver(onErrorDriveWith: .never())
        
        let tapCatalogButton = didTapGoToCatalog
            .map { WidgetsPresetsTabView.TabItem.widgets }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(selectTab, tapCatalogButton)
            .distinctUntilChanged()
    }
    
    func makeAction(
        didTapHelper: Signal<Void>,
        didTapOpenHelperFromCollection: Signal<Void>,
        didSelectElement: Signal<WidgetsPresetsTemplatesCollectionElement>
    ) -> Driver<Action> {
        let openWidgetsHelper = Signal
            .merge(didTapHelper, didTapOpenHelperFromCollection)
            .map { Action.openWidgetsHelper }
            .asDriver(onErrorDriveWith: .never())
        
        let openBuilder = didSelectElement
            .asDriver(onErrorDriveWith: .never())
            .compactMap { element -> Action? in
                switch element {
                case .openHelper:
                    return nil 
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
    
    func makeHelperCellWasDisplayed(didTapOpenHelperFromCollection: Signal<Void>) -> Driver<Bool> {
        let initial = Single
            .deferred {
                let wasDisplayed = UserDefaults.standard.bool(forKey: Constants.helperCellWasDisplayed)
                return .just(wasDisplayed)
            }
            .asDriver(onErrorDriveWith: .never())
        
        let openAction = didTapOpenHelperFromCollection
            .flatMapLatest { void -> Signal<Bool> in
                Signal.deferred {
                    UserDefaults.standard.set(true, forKey: Constants.helperCellWasDisplayed)
                    
                    return .just(true)
                }
            }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(initial, openAction)
    }
    
    func makeEmptyHidden(
        selectedTabItem: Driver<WidgetsPresetsTabView.TabItem>,
        elements: Driver<[WidgetsPresetsTemplatesCollectionElement]>
    ) -> Driver<Bool> {
        Driver
            .combineLatest(selectedTabItem, elements)
            .map { selectedTabItem, elements -> Bool in
                switch selectedTabItem {
                case .widgets:
                    return true
                case .saved:
                    return !elements.isEmpty
                }
            }
            .startWith(true)
    }
    
    func makeCollectionElements(
        selectedTabItem: Driver<WidgetsPresetsTabView.TabItem>,
        selectedPresetsType: Driver<WidgetsPresetsType>,
        helperCellWasDisplayed: Driver<Bool>
    ) -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
        Driver
            .combineLatest(selectedTabItem, selectedPresetsType, helperCellWasDisplayed)
            .flatMapLatest { [weak self] tabItem, presetsType, helperCellWasDisplayed -> Driver<[WidgetsPresetsTemplatesCollectionElement]> in
                guard let self else { return .just([]) }
                
                let saved = tabItem == .saved
                
                let elements: Driver<[WidgetsPresetsTemplatesCollectionElement]> = {
                    switch presetsType {
                    case .all:
                        let textElements = self.makeTextElements(isSaved: saved)
                        
                        return textElements
                            .map { texts -> [WidgetsPresetsTemplatesCollectionElement] in
                                texts
                            }
                    case .calendar:
                        return .just([])
                    case .clock:
                        return .just([])
                    case .carLogo:
                        return .just([])
                    case .text:
                        return self.makeTextElements(isSaved: saved)
                    case .photo:
                        return .just([])
                    case .weather:
                        return .just([])
                    }
                }()
                
                return elements
                    .map { elements -> [WidgetsPresetsTemplatesCollectionElement] in
                        guard saved, !elements.isEmpty, !helperCellWasDisplayed else { return elements }
                        
                        var result = elements
                        let insertIndex = elements.count == 1 ? 1 : 2
                        result.insert(.openHelper, at: min(insertIndex, elements.count))
                        
                        return result
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
            
            let initial = textService
                .fetchQuotes()
                .map { Action.initial($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let added = WidgetTextServiceMediator.shared
                .didSavedQuoteModel
                .map { Action.added($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let edited = WidgetTextServiceMediator.shared
                .didEditedQuoteModel
                .map { Action.edited($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let deleted = WidgetTextServiceMediator.shared
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
