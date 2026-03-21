//
//  WidgetWeatherService.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 18.03.2026.
//

import RxSwift

protocol WidgetWeatherServiceProtocol {
    func save(name: String, configuration: WidgetWeatherConfiguration) -> Single<WidgetWeatherStorageModel>
    func edit(
        name: String,
        storageModelId: String,
        configuration: WidgetWeatherConfiguration
    ) -> Single<WidgetWeatherStorageModel>
    func delete(storageModelId: String) -> Single<Void>
    func fetchConfigurations() -> Single<[WidgetWeatherStorageModel]>
}

final class WidgetWeatherService {
    private lazy var storage = WidgetWeatherStorage.shared
    
    private lazy var queue = DispatchQueue(label: "mobile.carconnect.widgetWeatherService", qos: .utility)
}

// MARK: WidgetWeatherServiceProtocol
extension WidgetWeatherService: WidgetWeatherServiceProtocol {
    func save(name: String, configuration: WidgetWeatherConfiguration) -> Single<WidgetWeatherStorageModel> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }
            
            var items = storage.loadAllConfigurations()

            let model = WidgetWeatherStorageModel(
                id: UUID().uuidString,
                name: name,
                configuration: configuration
            )

            items.append(model)
            storage.persist(configurations: items)
            
            WidgetWeatherMediator.shared.saved(weatherModel: model)

            return .just(model)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func edit(
        name: String,
        storageModelId: String,
        configuration: WidgetWeatherConfiguration
    ) -> Single<WidgetWeatherStorageModel> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }

            var items = storage.loadAllConfigurations()

            guard let index = items.firstIndex(where: { $0.id == storageModelId }) else {
                return .error(NSError(domain: "Not found", code: 404))
            }

            let edited = WidgetWeatherStorageModel(
                id: storageModelId,
                name: name,
                configuration: configuration
            )
            
            items[index] = edited
            storage.persist(configurations: items)
            
            WidgetWeatherMediator.shared.edited(weatherModel: edited)

            return .just(edited)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func delete(storageModelId: String) -> Single<Void> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }

            var items = storage.loadAllConfigurations()
            items.removeAll { $0.id == storageModelId }

            storage.persist(configurations: items)
            
            WidgetWeatherMediator.shared.deleted(weatherModelId: storageModelId)
            
            return .just(())
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func fetchConfigurations() -> Single<[WidgetWeatherStorageModel]> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }
            
            let items = storage.loadAllConfigurations()
            
            return .just(items)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
}
