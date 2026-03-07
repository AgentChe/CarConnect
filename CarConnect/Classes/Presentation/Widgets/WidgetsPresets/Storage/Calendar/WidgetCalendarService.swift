//
//  WidgetCalendarService.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 05.03.2026.
//

import RxSwift

protocol WidgetCalendarServiceProtocol {
    func save(configuration: WidgetCalendarCongifuration) -> Single<WidgetCalendarStorageModel>
    func edit(
        storageModelId: String,
        configuration: WidgetCalendarCongifuration
    ) -> Single<WidgetCalendarStorageModel>
    func delete(storageModelId: String) -> Single<Void>
    func fetchConfigurations() -> Single<[WidgetCalendarStorageModel]>
}

final class WidgetCalendarService {
    private lazy var storage = WidgetCalendarStorage.shared
    
    private lazy var queue = DispatchQueue(label: "mobile.carconnect.widgetCalendarService", qos: .utility)
}

// MARK: WidgetCalendarServiceProtocol
extension WidgetCalendarService: WidgetCalendarServiceProtocol {
    func save(configuration: WidgetCalendarCongifuration) -> Single<WidgetCalendarStorageModel> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }
            
            var items = storage.loadAllConfigurations()

            let model = WidgetCalendarStorageModel(
                id: UUID().uuidString,
                configuration: configuration
            )

            items.append(model)
            storage.persist(configurations: items)
            
            WidgetCalendarMediator.shared.saved(calendarModel: model)

            return .just(model)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func edit(
        storageModelId: String,
        configuration: WidgetCalendarCongifuration
    ) -> Single<WidgetCalendarStorageModel> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }

            var items = storage.loadAllConfigurations()

            guard let index = items.firstIndex(where: { $0.id == storageModelId }) else {
                return .error(NSError(domain: "Not found", code: 404))
            }

            let edited = WidgetCalendarStorageModel(
                id: storageModelId,
                configuration: configuration
            )
            
            items[index] = edited
            storage.persist(configurations: items)
            
            WidgetCalendarMediator.shared.edited(calendarModel: edited)

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
            
            WidgetCalendarMediator.shared.deleted(calendarModelId: storageModelId)
            
            return .just(())
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
    
    func fetchConfigurations() -> Single<[WidgetCalendarStorageModel]> {
        Single.deferred { [weak self] in
            guard let self else { return .error(ContentError.init(.notContent)) }
            
            let items = storage.loadAllConfigurations()
            
            return .just(items)
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: queue))
    }
}
