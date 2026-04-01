//
//  WidgetClockService.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 25.03.2026.
//

import RxSwift

protocol WidgetClockServiceProtocol {
    func save(name: String, configuration: WidgetClockConfiguration) -> Single<WidgetClockStorageModel>
    func edit(
        name: String,
        storageModelId: String,
        configuration: WidgetClockConfiguration
    ) -> Single<WidgetClockStorageModel>
    func delete(storageModelId: String) -> Single<Void>
    func fetchConfigurations() -> Single<[WidgetClockStorageModel]>
    
    func save(name: String, configurationAIPreview: WidgetClockAIPreviewConfiguration) -> Single<WidgetClockAIPreviewStorageModel>
    func edit(
        name: String,
        storageAIPreviewModelId: String,
        configuration: WidgetClockAIPreviewConfiguration
    ) -> Single<WidgetClockAIPreviewStorageModel>
    func delete(aiPreviewStorageModelId: String) -> Single<Void>
    func fetchAIPreviewConfigurations() -> Single<[WidgetClockAIPreviewStorageModel]>
}

final class WidgetClockService {
    private lazy var storage = WidgetClockStorage.shared
    
    private lazy var queue = DispatchQueue(label: "mobile.carconnect.widgetClockService", qos: .utility)
}

// MARK: WidgetClockServiceProtocol
extension WidgetClockService: WidgetClockServiceProtocol {
    func save(name: String, configuration: WidgetClockConfiguration) -> Single<WidgetClockStorageModel> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }
            
            var items = storage.loadAllConfigurations()

            let model = WidgetClockStorageModel(
                id: UUID().uuidString,
                name: name,
                configuration: configuration
            )

            items.append(model)
            storage.persist(configurations: items)
            
            WidgetClockMediator.shared.saved(clockModel: model)

            return .just(model)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func edit(
        name: String,
        storageModelId: String,
        configuration: WidgetClockConfiguration
    ) -> Single<WidgetClockStorageModel> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }

            var items = storage.loadAllConfigurations()

            guard let index = items.firstIndex(where: { $0.id == storageModelId }) else {
                return .error(NSError(domain: "Not found", code: 404))
            }

            let edited = WidgetClockStorageModel(
                id: storageModelId,
                name: name,
                configuration: configuration
            )
            
            items[index] = edited
            storage.persist(configurations: items)
            
            WidgetClockMediator.shared.edited(clockModel: edited)

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
            
            WidgetClockMediator.shared.deleted(clockModelId: storageModelId)
            
            return .just(())
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func fetchConfigurations() -> Single<[WidgetClockStorageModel]> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }
            
            let items = storage.loadAllConfigurations()
            
            return .just(items)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func save(name: String, configurationAIPreview: WidgetClockAIPreviewConfiguration) -> Single<WidgetClockAIPreviewStorageModel> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }
            
            var items = storage.loadAllAIPreviewConfigurations()

            let model = WidgetClockAIPreviewStorageModel(
                id: UUID().uuidString,
                name: name,
                configuration: configurationAIPreview
            )

            items.append(model)
            storage.persist(aiPreviewConfigurations: items)
            
            WidgetClockMediator.shared.saved(clockAIPreviewModel: model)

            return .just(model)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func edit(
        name: String,
        storageAIPreviewModelId: String,
        configuration: WidgetClockAIPreviewConfiguration
    ) -> Single<WidgetClockAIPreviewStorageModel> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }

            var items = storage.loadAllAIPreviewConfigurations()

            guard let index = items.firstIndex(where: { $0.id == storageAIPreviewModelId }) else {
                return .error(NSError(domain: "Not found", code: 404))
            }

            let edited = WidgetClockAIPreviewStorageModel(
                id: storageAIPreviewModelId,
                name: name,
                configuration: configuration
            )
            
            items[index] = edited
            storage.persist(aiPreviewConfigurations: items)
            
            WidgetClockMediator.shared.edited(clockAIPreviewModel: edited)

            return .just(edited)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func delete(aiPreviewStorageModelId: String) -> Single<Void> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }

            var items = storage.loadAllAIPreviewConfigurations()
            items.removeAll { $0.id == aiPreviewStorageModelId }

            storage.persist(aiPreviewConfigurations: items)
            
            WidgetClockMediator.shared.deleted(clockAIPreviewModelId: aiPreviewStorageModelId)
            
            return .just(())
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func fetchAIPreviewConfigurations() -> Single<[WidgetClockAIPreviewStorageModel]> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }
            
            let items = storage.loadAllAIPreviewConfigurations()
            
            return .just(items)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
}
