//
//  WidgetAIPhotoMyCarViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 05.04.2026.
//

import RxSwift
import RxCocoa

final class WidgetAIPhotoMyCarViewModel {
    enum Action {
        case openHelper
        case openPreview
        case close
        case requestRemoveConfirmation
        case enterName(String)
    }
    
    private let storageModelId: Driver<String?>
    private let initialConfiguration: Driver<WidgetAIPhotoMyCarConfiguration>
    
    private lazy var service = WidgetPhotoService()
    
    init(storageModelId: String?, configuration: WidgetAIPhotoMyCarConfiguration) {
        self.storageModelId = BehaviorRelay(value: storageModelId).asDriver()
        self.initialConfiguration = BehaviorRelay(value: configuration).asDriver()
    }
}

// MARK: Public
extension WidgetAIPhotoMyCarViewModel {
    struct Input {
        let didTapHelper: Signal<Void>
        let didTapOpenPreview: Signal<Void>
        let didTapSave: Signal<Void>
        let didTapRemove: Signal<Void>
        let didRemoveConfirmed: Signal<Void>
        let didEnterName: Signal<String>
    }
    
    struct Output {
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        let storageModel = makeStorageModel(id: storageModelId)
        
        return Output(
            action: makeAction(
                didTapHelper: input.didTapHelper,
                didTapOpenPreview: input.didTapOpenPreview,
                didTapSave: input.didTapSave,
                configuration: initialConfiguration,
                didTapRemove: input.didTapRemove,
                didRemoveConfirmed: input.didRemoveConfirmed,
                storageModelId: storageModelId,
                didEnterName: input.didEnterName,
                storageModel: storageModel
            )
        )
    }
}

// MARK: Private
extension WidgetAIPhotoMyCarViewModel {
    func makeAction(
        didTapHelper: Signal<Void>,
        didTapOpenPreview: Signal<Void>,
        didTapSave: Signal<Void>,
        configuration: Driver<WidgetAIPhotoMyCarConfiguration>,
        didTapRemove: Signal<Void>,
        didRemoveConfirmed: Signal<Void>,
        storageModelId: Driver<String?>,
        didEnterName: Signal<String>,
        storageModel: Driver<WidgetAIPhotoMyCarStorageModel?>
    ) -> Driver<Action> {
        let openHelper = didTapHelper
            .map { Action.openHelper }
            .asDriver(onErrorDriveWith: .never())
        
        let openPreview = didTapOpenPreview
            .map { Action.openPreview }
            .asDriver(onErrorDriveWith: .never())
        
        let enterName = didTapSave
            .withLatestFrom(storageModel)
            .map { Action.enterName($0?.name ?? "Photo") }
            .asDriver(onErrorDriveWith: .never())
        
        let saveAndClose = didEnterName
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(storageModelId) { ($0, $1) }
            .withLatestFrom(configuration) { ($0.0, $0.1, $1) }
            .flatMapLatest { name, id, configuration -> Signal<(String?, String, WidgetAIPhotoMyCarConfiguration)> in
                Observable<(String?, String, WidgetAIPhotoMyCarConfiguration)>
                    .create { observer in
                        guard SharedImageFileStore.shared.save(url: configuration.url) != nil else {
                            observer.onCompleted()
                            return Disposables.create()
                        }
                        
                        observer.onNext((id, name, configuration))
                        observer.onCompleted()
                        
                        return Disposables.create()
                    }
                    .asSignal(onErrorSignalWith: .never())
            }
            .flatMapLatest { id, name, configuration -> Driver<Action> in
                let model: Single<WidgetAIPhotoMyCarStorageModel> = { [weak self] in
                    guard let self else { return .never() }
                    
                    if let id {
                        return service.editAIPhotoMyCar(
                            name: name,
                            storageModelId: id,
                            configuration: configuration
                        )
                    } else {
                        return service
                            .saveAIPhotoMyCar(name: name, configuration: configuration)
                    }
                }()
                
                return model
                    .asDriver(onErrorDriveWith: .never())
                    .map { _ in Action.close }
            }
        
        let requestRemoveConfirmation = didTapRemove
            .asDriver(onErrorDriveWith: .never())
            .map { Action.requestRemoveConfirmation }
        
        let removeAndClose = didRemoveConfirmed
            .withLatestFrom(storageModelId)
            .compactMap { $0 }
            .flatMapLatest { [weak self] id -> Driver<Action> in
                guard let self else { return .never() }
                
                return service
                    .deleteAIPhotoMyCar(storageModelId: id)
                    .map { Action.close }
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(openHelper, openPreview, enterName, saveAndClose, requestRemoveConfirmation, removeAndClose)
    }
    
    func makeStorageModel(id: Driver<String?>) -> Driver<WidgetAIPhotoMyCarStorageModel?> {
        id
            .flatMapLatest { [weak self] id -> Driver<WidgetAIPhotoMyCarStorageModel?> in
                guard let self, let id else {
                    return .just(nil)
                }
                
                return service
                    .fetchAIPhotoMyCarConfigurations()
                    .map { configs -> WidgetAIPhotoMyCarStorageModel? in
                        configs.first(where: { $0.id == id })
                    }
                    .asDriver(onErrorJustReturn: nil)
            }
    }
}
