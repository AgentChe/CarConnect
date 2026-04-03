//
//  WidgetCarLogoService.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 02.04.2026.
//

import RxSwift

protocol WidgetCarLogoServiceProtocol {
    func save(name: String, configuration: WidgetCarLogoConfiguration) -> Single<WidgetCarLogoStorageModel>
    func edit(
        name: String,
        storageModelId: String,
        configuration: WidgetCarLogoConfiguration
    ) -> Single<WidgetCarLogoStorageModel>
    func delete(storageModelId: String) -> Single<Void>
    func fetchConfigurations() -> Single<[WidgetCarLogoStorageModel]>
}

final class WidgetCarLogoService {
    private lazy var storage = WidgetCarLogoStorage.shared
    
    private lazy var queue = DispatchQueue(label: "mobile.carconnect.widgetCarLogoService", qos: .utility)
}

// MARK: WidgetCarLogoServiceProtocol
extension WidgetCarLogoService: WidgetCarLogoServiceProtocol {
    func save(name: String, configuration: WidgetCarLogoConfiguration) -> Single<WidgetCarLogoStorageModel> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }
            
            var items = storage.loadAllConfigurations()

            let model = WidgetCarLogoStorageModel(
                id: UUID().uuidString,
                name: name,
                configuration: configuration
            )

            items.append(model)
            storage.persist(configurations: items)
            
            WidgetCarLogoMediator.shared.saved(carLogoModel: model)

            return .just(model)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func edit(
        name: String,
        storageModelId: String,
        configuration: WidgetCarLogoConfiguration
    ) -> Single<WidgetCarLogoStorageModel> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }

            var items = storage.loadAllConfigurations()

            guard let index = items.firstIndex(where: { $0.id == storageModelId }) else {
                return .error(NSError(domain: "Not found", code: 404))
            }

            let edited = WidgetCarLogoStorageModel(
                id: storageModelId,
                name: name,
                configuration: configuration
            )
            
            items[index] = edited
            storage.persist(configurations: items)
            
            WidgetCarLogoMediator.shared.edited(carLogoModel: edited)

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
            
            WidgetCarLogoMediator.shared.deleted(carLogoModelId: storageModelId)
            
            return .just(())
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func fetchConfigurations() -> Single<[WidgetCarLogoStorageModel]> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }
            
            let items = storage.loadAllConfigurations()
            
            return .just(items)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
}
