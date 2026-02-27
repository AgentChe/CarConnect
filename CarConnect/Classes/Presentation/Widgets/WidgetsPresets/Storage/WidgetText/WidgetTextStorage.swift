//
//  WidgetTextStorage.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.02.2026.
//

import RxSwift

protocol WidgetTextStorageProtocol {
    func save(
        quote: WidgetTextQuote,
        configuration: WidgetTextQuoteConfiguration
    ) -> Single<WidgetTextQuoteStorageModel>
    func edit(
        quoteStorageModelId: String,
        quote: WidgetTextQuote,
        configuration: WidgetTextQuoteConfiguration
    ) -> Single<WidgetTextQuoteStorageModel>
    func delete(quoteStorageModelId: String) -> Single<Void>
    func fetchQuotes() -> Single<[WidgetTextQuoteStorageModel]>
}

final class WidgetTextStorage {
    enum Constants {
        static let quotesKey = "widget_text_storage_quotes_key"
    }
    
    private lazy var userDefaults = UserDefaults.standard
    
    private lazy var queue = DispatchQueue(label: "mobile.carconnect.widgetTextStorage", qos: .utility)
    
    private lazy var encoder = JSONEncoder()
    private lazy var decoder = JSONDecoder()
}

// MARK: WidgetTextStorageProtocol
extension WidgetTextStorage: WidgetTextStorageProtocol {
    func save(
        quote: WidgetTextQuote,
        configuration: WidgetTextQuoteConfiguration
    ) -> Single<WidgetTextQuoteStorageModel> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }
            
            var items = loadAllQuotes()

            let model = WidgetTextQuoteStorageModel(
                id: UUID().uuidString,
                quote: quote,
                configuration: configuration
            )

            items.append(model)
            persist(quotesModels: items)
            
            WidgetTextStorageMediator.shared.saved(quoteModel: model)

            return .just(model)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func edit(
        quoteStorageModelId: String,
        quote: WidgetTextQuote,
        configuration: WidgetTextQuoteConfiguration
    ) -> Single<WidgetTextQuoteStorageModel> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }

            var items = loadAllQuotes()

            guard let index = items.firstIndex(where: { $0.id == quoteStorageModelId }) else {
                return .error(NSError(domain: "Not found", code: 404))
            }

            let edited = WidgetTextQuoteStorageModel(
                id: quoteStorageModelId,
                quote: quote,
                configuration: configuration
            )
            
            items[index] = edited
            persist(quotesModels: items)
            
            WidgetTextStorageMediator.shared.edited(quoteModel: edited)

            return .just(edited)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }

    func delete(quoteStorageModelId: String) -> Single<Void> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }

            var items = loadAllQuotes()
            items.removeAll { $0.id == quoteStorageModelId }

            persist(quotesModels: items)
            
            WidgetTextStorageMediator.shared.deleted(quoteModelId: quoteStorageModelId)
            
            return .just(())
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }

    func fetchQuotes() -> Single<[WidgetTextQuoteStorageModel]> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }
            
            let items = loadAllQuotes()
            
            return .just(items)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
}

// MARK: Private
private extension WidgetTextStorage {
    func loadAllQuotes() -> [WidgetTextQuoteStorageModel] {
        guard let data = userDefaults.data(forKey: Constants.quotesKey) else { return [] }
        
        let decoded = try? decoder.decode([WidgetTextQuoteStorageModel].self, from: data)
        
        return decoded ?? []
    }
    
    func persist(quotesModels: [WidgetTextQuoteStorageModel]) {
        guard let data = try? encoder.encode(quotesModels) else { return }
        
        userDefaults.set(data, forKey: Constants.quotesKey)
    }
}
