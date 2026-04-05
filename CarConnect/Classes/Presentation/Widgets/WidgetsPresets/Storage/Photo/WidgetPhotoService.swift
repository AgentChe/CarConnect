//
//  WidgetPhotoService.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.04.2026.
//

import RxSwift

protocol WidgetPhotoServiceProtocol {
    func saveAIPhoto(name: String, configuration: WidgetAIPhotoConfiguration) -> Single<WidgetAIPhotoStorageModel>
    func editAIPhoto(
        name: String,
        storageModelId: String,
        configuration: WidgetAIPhotoConfiguration
    ) -> Single<WidgetAIPhotoStorageModel>
    func deleteAIPhoto(storageModelId: String) -> Single<Void>
    func fetchAIPhotoConfigurations() -> Single<[WidgetAIPhotoStorageModel]>
    
    func savePhotoWithText(name: String, configuration: WidgetPhotoWithTextConfiguration) -> Single<WidgetPhotoWithTextStorageModel>
    func editPhotoWithText(
        name: String,
        storageModelId: String,
        configuration: WidgetPhotoWithTextConfiguration
    ) -> Single<WidgetPhotoWithTextStorageModel>
    func deletePhotoWithText(storageModelId: String) -> Single<Void>
    func fetchPhotoWithTextConfigurations() -> Single<[WidgetPhotoWithTextStorageModel]>
    
    func savePhoto(name: String, configuration: WidgetPhotoConfiguration) -> Single<WidgetPhotoStorageModel>
    func editPhoto(
        name: String,
        storageModelId: String,
        configuration: WidgetPhotoConfiguration
    ) -> Single<WidgetPhotoStorageModel>
    func deletePhoto(storageModelId: String) -> Single<Void>
    func fetchPhotoConfigurations() -> Single<[WidgetPhotoStorageModel]>
    
    func saveAIPhotoMyCar(name: String, configuration: WidgetAIPhotoMyCarConfiguration) -> Single<WidgetAIPhotoMyCarStorageModel>
    func editAIPhotoMyCar(
        name: String,
        storageModelId: String,
        configuration: WidgetAIPhotoMyCarConfiguration
    ) -> Single<WidgetAIPhotoMyCarStorageModel>
    func deleteAIPhotoMyCar(storageModelId: String) -> Single<Void>
    func fetchAIPhotoMyCarConfigurations() -> Single<[WidgetAIPhotoMyCarStorageModel]>
}

final class WidgetPhotoService {
    private lazy var storage = WidgetPhotoStorage.shared
    
    private lazy var queue = DispatchQueue(label: "mobile.carconnect.widgetPhotoService", qos: .utility)
}

// MARK: WidgetPhotoServiceProtocol
extension WidgetPhotoService: WidgetPhotoServiceProtocol {
    func saveAIPhoto(name: String, configuration: WidgetAIPhotoConfiguration) -> Single<WidgetAIPhotoStorageModel> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }
            
            var items = storage.loadAllAIPhotosConfigurations()

            let model = WidgetAIPhotoStorageModel(
                id: UUID().uuidString,
                name: name,
                configuration: configuration
            )

            items.append(model)
            storage.persist(aiPhotosConfigurations: items)
            
            WidgetPhotoMediator.shared.saved(aiPhotoModel: model)

            return .just(model)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func editAIPhoto(
        name: String,
        storageModelId: String,
        configuration: WidgetAIPhotoConfiguration
    ) -> Single<WidgetAIPhotoStorageModel> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }

            var items = storage.loadAllAIPhotosConfigurations()

            guard let index = items.firstIndex(where: { $0.id == storageModelId }) else {
                return .error(NSError(domain: "Not found", code: 404))
            }

            let edited = WidgetAIPhotoStorageModel(
                id: storageModelId,
                name: name,
                configuration: configuration
            )
            
            items[index] = edited
            storage.persist(aiPhotosConfigurations: items)
            
            WidgetPhotoMediator.shared.edited(aiPhotoModel: edited)

            return .just(edited)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func deleteAIPhoto(storageModelId: String) -> Single<Void> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }

            var items = storage.loadAllAIPhotosConfigurations()
            items.removeAll { $0.id == storageModelId }

            storage.persist(aiPhotosConfigurations: items)
            
            WidgetPhotoMediator.shared.deleted(aiPhotoModelId: storageModelId)
            
            return .just(())
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func fetchAIPhotoConfigurations() -> Single<[WidgetAIPhotoStorageModel]> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }
            
            let items = storage.loadAllAIPhotosConfigurations()
            
            return .just(items)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func savePhotoWithText(name: String, configuration: WidgetPhotoWithTextConfiguration) -> Single<WidgetPhotoWithTextStorageModel> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }
            
            var items = storage.loadAllPhotoWithTextConfigurations()

            let model = WidgetPhotoWithTextStorageModel(
                id: UUID().uuidString,
                name: name,
                configuration: configuration
            )

            items.append(model)
            storage.persist(photoWithTextConfigurations: items)
            
            WidgetPhotoMediator.shared.saved(photoWithTextModel: model)

            return .just(model)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func editPhotoWithText(
        name: String,
        storageModelId: String,
        configuration: WidgetPhotoWithTextConfiguration
    ) -> Single<WidgetPhotoWithTextStorageModel> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }

            var items = storage.loadAllPhotoWithTextConfigurations()

            guard let index = items.firstIndex(where: { $0.id == storageModelId }) else {
                return .error(NSError(domain: "Not found", code: 404))
            }

            let edited = WidgetPhotoWithTextStorageModel(
                id: storageModelId,
                name: name,
                configuration: configuration
            )
            
            items[index] = edited
            storage.persist(photoWithTextConfigurations: items)
            
            WidgetPhotoMediator.shared.edited(photoWithTextModel: edited)

            return .just(edited)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func deletePhotoWithText(storageModelId: String) -> Single<Void> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }

            var items = storage.loadAllPhotoWithTextConfigurations()
            items.removeAll { $0.id == storageModelId }

            storage.persist(photoWithTextConfigurations: items)
            
            WidgetPhotoMediator.shared.deleted(photoWithTextModelId: storageModelId)
            
            return .just(())
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func fetchPhotoWithTextConfigurations() -> Single<[WidgetPhotoWithTextStorageModel]> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }
            
            let items = storage.loadAllPhotoWithTextConfigurations()
            
            return .just(items)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func savePhoto(name: String, configuration: WidgetPhotoConfiguration) -> Single<WidgetPhotoStorageModel> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }
            
            var items = storage.loadAllPhotoConfigurations()

            let model = WidgetPhotoStorageModel(
                id: UUID().uuidString,
                name: name,
                configuration: configuration
            )

            items.append(model)
            storage.persist(photoConfigurations: items)
            
            WidgetPhotoMediator.shared.saved(photoModel: model)

            return .just(model)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func editPhoto(
        name: String,
        storageModelId: String,
        configuration: WidgetPhotoConfiguration
    ) -> Single<WidgetPhotoStorageModel> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }

            var items = storage.loadAllPhotoConfigurations()

            guard let index = items.firstIndex(where: { $0.id == storageModelId }) else {
                return .error(NSError(domain: "Not found", code: 404))
            }

            let edited = WidgetPhotoStorageModel(
                id: storageModelId,
                name: name,
                configuration: configuration
            )
            
            items[index] = edited
            storage.persist(photoConfigurations: items)
            
            WidgetPhotoMediator.shared.edited(photoModel: edited)

            return .just(edited)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func deletePhoto(storageModelId: String) -> Single<Void> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }

            var items = storage.loadAllPhotoConfigurations()
            items.removeAll { $0.id == storageModelId }

            storage.persist(photoConfigurations: items)
            
            WidgetPhotoMediator.shared.deleted(photoModelId: storageModelId)
            
            return .just(())
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func fetchPhotoConfigurations() -> Single<[WidgetPhotoStorageModel]> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }
            
            let items = storage.loadAllPhotoConfigurations()
            
            return .just(items)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func saveAIPhotoMyCar(name: String, configuration: WidgetAIPhotoMyCarConfiguration) -> Single<WidgetAIPhotoMyCarStorageModel> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }
            
            var items = storage.loadAllAIPhotoMyCarConfigurations()

            let model = WidgetAIPhotoMyCarStorageModel(
                id: UUID().uuidString,
                name: name,
                configuration: configuration
            )

            items.append(model)
            storage.persist(aiPhotoMyCarConfigurations: items)
            
            WidgetPhotoMediator.shared.saved(aiPhotoMyCarModel: model)

            return .just(model)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func editAIPhotoMyCar(
        name: String,
        storageModelId: String,
        configuration: WidgetAIPhotoMyCarConfiguration
    ) -> Single<WidgetAIPhotoMyCarStorageModel> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }

            var items = storage.loadAllAIPhotoMyCarConfigurations()

            guard let index = items.firstIndex(where: { $0.id == storageModelId }) else {
                return .error(NSError(domain: "Not found", code: 404))
            }

            let edited = WidgetAIPhotoMyCarStorageModel(
                id: storageModelId,
                name: name,
                configuration: configuration
            )
            
            items[index] = edited
            storage.persist(aiPhotoMyCarConfigurations: items)
            
            WidgetPhotoMediator.shared.edited(aiPhotoMyCarModel: edited)

            return .just(edited)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func deleteAIPhotoMyCar(storageModelId: String) -> Single<Void> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }

            var items = storage.loadAllAIPhotoMyCarConfigurations()
            items.removeAll { $0.id == storageModelId }

            storage.persist(aiPhotoMyCarConfigurations: items)
            
            WidgetPhotoMediator.shared.deleted(aiPhotoMyCarModelId: storageModelId)
            
            return .just(())
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func fetchAIPhotoMyCarConfigurations() -> Single<[WidgetAIPhotoMyCarStorageModel]> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }
            
            let items = storage.loadAllAIPhotoMyCarConfigurations()
            
            return .just(items)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
}
