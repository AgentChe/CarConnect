//
//  WidgetTextService.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.02.2026.
//

import RxSwift

protocol WidgetTextServiceProtocol {
    func save(
        name: String,
        quote: WidgetTextQuote,
        configuration: WidgetTextQuoteConfiguration
    ) -> Single<WidgetTextQuoteStorageModel>
    func edit(
        name: String,
        quoteStorageModelId: String,
        quote: WidgetTextQuote,
        configuration: WidgetTextQuoteConfiguration
    ) -> Single<WidgetTextQuoteStorageModel>
    func delete(quoteStorageModelId: String) -> Single<Void>
    func fetchQuotes() -> Single<[WidgetTextQuoteStorageModel]>
    
    func save(
        name: String,
        manuallyConfiguration: WidgetTextManuallyConfiguration
    ) -> Single<WidgetTextManuallyStorageModel>
    func edit(
        name: String,
        manuallyConfigurationStorageModelId: String,
        manuallyConfiguration: WidgetTextManuallyConfiguration
    ) -> Single<WidgetTextManuallyStorageModel>
    func delete(manuallyConfigurationStorageModelId: String) -> Single<Void>
    func fetchManuallyConfigurations() -> Single<[WidgetTextManuallyStorageModel]>
}

final class WidgetTextService {
    private lazy var storage = WidgetTextStorage.shared
    
    private lazy var queue = DispatchQueue(label: "mobile.carconnect.widgetTextService", qos: .utility)
}

// MARK: WidgetTextServiceProtocol
extension WidgetTextService: WidgetTextServiceProtocol {
    func save(
        name: String,
        quote: WidgetTextQuote,
        configuration: WidgetTextQuoteConfiguration
    ) -> Single<WidgetTextQuoteStorageModel> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }
            
            var items = storage.loadAllQuotes()

            let model = WidgetTextQuoteStorageModel(
                id: UUID().uuidString,
                name: name,
                quote: quote,
                configuration: configuration
            )

            items.append(model)
            storage.persist(quotesModels: items)
            
            WidgetTextServiceMediator.shared.saved(quoteModel: model)

            return .just(model)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func edit(
        name: String,
        quoteStorageModelId: String,
        quote: WidgetTextQuote,
        configuration: WidgetTextQuoteConfiguration
    ) -> Single<WidgetTextQuoteStorageModel> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }

            var items = storage.loadAllQuotes()

            guard let index = items.firstIndex(where: { $0.id == quoteStorageModelId }) else {
                return .error(NSError(domain: "Not found", code: 404))
            }

            let edited = WidgetTextQuoteStorageModel(
                id: quoteStorageModelId,
                name: name,
                quote: quote,
                configuration: configuration
            )
            
            items[index] = edited
            storage.persist(quotesModels: items)
            
            WidgetTextServiceMediator.shared.edited(quoteModel: edited)

            return .just(edited)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }

    func delete(quoteStorageModelId: String) -> Single<Void> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }

            var items = storage.loadAllQuotes()
            items.removeAll { $0.id == quoteStorageModelId }

            storage.persist(quotesModels: items)
            
            WidgetTextServiceMediator.shared.deleted(quoteModelId: quoteStorageModelId)
            
            return .just(())
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }

    func fetchQuotes() -> Single<[WidgetTextQuoteStorageModel]> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }
            
            let items = storage.loadAllQuotes()
            
            return .just(items)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func save(
        name: String,
        manuallyConfiguration: WidgetTextManuallyConfiguration
    ) -> Single<WidgetTextManuallyStorageModel> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }
            
            var items = storage.loadAllManuallyConfigurations()

            let model = WidgetTextManuallyStorageModel(
                id: UUID().uuidString,
                name: name,
                configuration: manuallyConfiguration
            )

            items.append(model)
            storage.persist(manuallyConfigurations: items)
            
            WidgetTextServiceMediator.shared.saved(manuallyConfigurationModel: model)

            return .just(model)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func edit(
        name: String,
        manuallyConfigurationStorageModelId: String,
        manuallyConfiguration: WidgetTextManuallyConfiguration
    ) -> Single<WidgetTextManuallyStorageModel> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }

            var items = storage.loadAllManuallyConfigurations()

            guard let index = items.firstIndex(where: { $0.id == manuallyConfigurationStorageModelId }) else {
                return .error(NSError(domain: "Not found", code: 404))
            }

            let edited = WidgetTextManuallyStorageModel(
                id: manuallyConfigurationStorageModelId,
                name: name,
                configuration: manuallyConfiguration
            )
            
            items[index] = edited
            storage.persist(manuallyConfigurations: items)
            
            WidgetTextServiceMediator.shared.edited(manuallyConfigurationModel: edited)

            return .just(edited)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func delete(manuallyConfigurationStorageModelId: String) -> Single<Void> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }

            var items = storage.loadAllManuallyConfigurations()
            items.removeAll { $0.id == manuallyConfigurationStorageModelId }

            storage.persist(manuallyConfigurations: items)
            
            WidgetTextServiceMediator.shared.deleted(manuallyConfigurationModelId: manuallyConfigurationStorageModelId)
            
            return .just(())
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func fetchManuallyConfigurations() -> Single<[WidgetTextManuallyStorageModel]> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }
            
            let items = storage.loadAllManuallyConfigurations()
            
            return .just(items)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
}
