//
//  WidgetPhotoViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 04.04.2026.
//

import RxSwift
import RxCocoa

final class WidgetPhotoViewModel {
    enum Action {
        case openHelper
        case openPreview
        case close
        case requestRemoveConfirmation
        case enterName(String)
    }
    
    private let storageModelId: Driver<String?>
    private let initialConfiguration: Driver<WidgetPhotoConfiguration?>
    
    private lazy var service = WidgetPhotoService()
    
    init(storageModelId: String?, configuration: WidgetPhotoConfiguration?) {
        self.storageModelId = BehaviorRelay(value: storageModelId).asDriver()
        self.initialConfiguration = BehaviorRelay(value: configuration).asDriver()
    }
}

// MARK: Public
extension WidgetPhotoViewModel {
    struct Input {
        let didTapHelper: Signal<Void>
        let didTapOpenPreview: Signal<Void>
        let didTapSave: Signal<Void>
        let didTapRemove: Signal<Void>
        let didRemoveConfirmed: Signal<Void>
        let didEnterName: Signal<String>
        let didAddPhoto: Signal<WidgetPhoto>
        let didSelectPhoto: Signal<WidgetPhoto>
        let didTapResetPhoto: Signal<Void>
    }
    
    struct Output {
        let action: Driver<Action>
        let photos: Driver<[WidgetPhoto]>
        let selectedPhoto: Driver<WidgetPhoto?>
        let initialPhoto: Driver<WidgetPhoto?>
    }
    
    func configure(input: Input) -> Output {
        let storageModel = makeStorageModel(id: storageModelId)
        let selectedPhoto = makeSelectedPhoto(
            initialConfiguration: initialConfiguration,
            didAddPhoto: input.didAddPhoto,
            didSelectPhoto: input.didSelectPhoto,
            didTapResetPhoto: input.didTapResetPhoto
        )
        
        return Output(
            action: makeAction(
                didTapHelper: input.didTapHelper,
                didTapOpenPreview: input.didTapOpenPreview,
                didTapSave: input.didTapSave,
                didTapRemove: input.didTapRemove,
                didRemoveConfirmed: input.didRemoveConfirmed,
                storageModelId: storageModelId,
                didEnterName: input.didEnterName,
                storageModel: storageModel,
                selectedPhoto: selectedPhoto
            ),
            photos: makePhotos(
                initialConfiguration: initialConfiguration,
                didAddPhoto: input.didAddPhoto
            ),
            selectedPhoto: selectedPhoto,
            initialPhoto: initialConfiguration.map { $0?.photo }
        )
    }
}

// MARK: Private
extension WidgetPhotoViewModel {
    func makeAction(
        didTapHelper: Signal<Void>,
        didTapOpenPreview: Signal<Void>,
        didTapSave: Signal<Void>,
        didTapRemove: Signal<Void>,
        didRemoveConfirmed: Signal<Void>,
        storageModelId: Driver<String?>,
        didEnterName: Signal<String>,
        storageModel: Driver<WidgetPhotoStorageModel?>,
        selectedPhoto: Driver<WidgetPhoto?>
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
        
        let requestRemoveConfirmation = didTapRemove
            .asDriver(onErrorDriveWith: .never())
            .map { Action.requestRemoveConfirmation }
        
        let saveAndClose = didEnterName
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(storageModelId) { ($0, $1) }
            .withLatestFrom(selectedPhoto) { ($0.0, $0.1, $1) }
            .flatMapLatest { name, id, photo -> Signal<(String?, String, WidgetPhotoConfiguration)> in
                guard let photo else { return .never() }
                
                switch photo {
                case .photoAssetId(let assetId):
                    return Observable<(String?, String, WidgetPhotoConfiguration)>
                        .create { observer in
                            let requestId = PhotoAssetImageLoader.shared.loadImage(assetId: assetId) { image in
                                guard let image, let fileName = SharedImageFileStore.shared.save(image: image, format: .jpeg(quality: 0.9)) else {
                                    observer.onCompleted()
                                    return
                                }
                                
                                let updated = WidgetPhotoConfiguration(
                                    photo: WidgetPhoto.fileName(fileName)
                                )
                                
                                observer.onNext((id, name, updated))
                                observer.onCompleted()
                            }
                            
                            return Disposables.create {
                                PhotoAssetImageLoader.shared.cancel(requestId)
                            }
                        }
                        .asSignal(onErrorSignalWith: .never())
                default:
                    return .just((id, name, WidgetPhotoConfiguration(photo: photo)))
                }
            }
            .flatMapLatest { id, name, configuration -> Driver<Action> in
                let model: Single<WidgetPhotoStorageModel> = { [weak self] in
                    guard let self else { return .never() }
                    
                    if let id {
                        return service.editPhoto(
                            name: name,
                            storageModelId: id,
                            configuration: configuration
                        )
                    } else {
                        return service
                            .savePhoto(name: name, configuration: configuration)
                    }
                }()
                
                return model
                    .asDriver(onErrorDriveWith: .never())
                    .map { _ in Action.close }
            }
        
        let removeAndClose = didRemoveConfirmed
            .withLatestFrom(storageModelId)
            .compactMap { $0 }
            .flatMapLatest { [weak self] id -> Driver<Action> in
                guard let self else { return .never() }
                
                return service
                    .deletePhoto(storageModelId: id)
                    .map { Action.close }
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(openHelper, openPreview, enterName, requestRemoveConfirmation, saveAndClose, removeAndClose)
    }
    
    func makeStorageModel(id: Driver<String?>) -> Driver<WidgetPhotoStorageModel?> {
        id
            .flatMapLatest { [weak self] id -> Driver<WidgetPhotoStorageModel?> in
                guard let self, let id else {
                    return .just(nil)
                }
                
                return service
                    .fetchPhotoConfigurations()
                    .map { configs -> WidgetPhotoStorageModel? in
                        configs.first(where: { $0.id == id })
                    }
                    .asDriver(onErrorJustReturn: nil)
            }
    }
    
    func makeSelectedPhoto(
        initialConfiguration: Driver<WidgetPhotoConfiguration?>,
        didAddPhoto: Signal<WidgetPhoto>,
        didSelectPhoto: Signal<WidgetPhoto>,
        didTapResetPhoto: Signal<Void>,
    ) -> Driver<WidgetPhoto?> {
        Driver<WidgetPhoto?>
            .merge(
                initialConfiguration
                    .map { $0?.photo },
                
                didTapResetPhoto
                    .asDriver(onErrorDriveWith: .never())
                    .withLatestFrom(initialConfiguration)
                    .map { $0?.photo }
                    .asDriver(onErrorDriveWith: .never()),
                
                didAddPhoto
                    .map { photo -> WidgetPhoto? in photo }
                    .asDriver(onErrorDriveWith: .never()),
                
                didSelectPhoto
                    .map { photo -> WidgetPhoto? in photo }
                    .asDriver(onErrorDriveWith: .never())
            )
    }
    
    func makePhotos(
        initialConfiguration: Driver<WidgetPhotoConfiguration?>,
        didAddPhoto: Signal<WidgetPhoto>
    ) -> Driver<[WidgetPhoto]> {
        enum Action {
            case initial([WidgetPhoto])
            case add(WidgetPhoto)
        }
        
        let action = Driver
            .merge(
                initialConfiguration
                    .map { Action.initial([$0?.photo].compactMap { $0 }) },
                
                didAddPhoto
                    .map { Action.add($0) }
                    .asDriver(onErrorDriveWith: .never())
            )
        
        return action
            .scan([]) { photos, action -> [WidgetPhoto] in
                switch action {
                case .initial(let photos):
                    return photos
                case .add(let photo):
                    return photos + [photo]
                }
            }
    }
}
