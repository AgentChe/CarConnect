//
//  WidgetPhotoCarouselViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 05.04.2026.
//

import RxSwift
import RxCocoa

final class WidgetPhotoCarouselViewModel {
    enum Action {
        case openHelper
        case openPreview
        case close
        case requestRemoveConfirmation
        case enterName(String)
    }
    
    private let storageModelId: Driver<String?>
    private let initialConfiguration: Driver<WidgetPhotoCarouselConfiguration>
    
    private lazy var service = WidgetPhotoService()
    
    init(storageModelId: String?, configuration: WidgetPhotoCarouselConfiguration) {
        self.storageModelId = BehaviorRelay(value: storageModelId).asDriver()
        self.initialConfiguration = BehaviorRelay(value: configuration).asDriver()
    }
}

// MARK: Public
extension WidgetPhotoCarouselViewModel {
    struct Input {
        let didTapHelper: Signal<Void>
        let didTapOpenPreview: Signal<Void>
        let didTapSave: Signal<Void>
        let didTapRemove: Signal<Void>
        let didRemoveConfirmed: Signal<Void>
        let didEnterName: Signal<String>
        let didAddPhoto1: Signal<WidgetPhoto>
        let didSelectPhoto1: Signal<WidgetPhoto>
        let didTapResetPhoto1: Signal<Void>
        let didAddPhoto2: Signal<WidgetPhoto>
        let didSelectPhoto2: Signal<WidgetPhoto>
        let didTapResetPhoto2: Signal<Void>
        let didAddPhoto3: Signal<WidgetPhoto>
        let didSelectPhoto3: Signal<WidgetPhoto>
        let didTapResetPhoto3: Signal<Void>
    }
    
    struct Output {
        let action: Driver<Action>
        let configuration: Driver<WidgetPhotoCarouselConfiguration>
        let defaultConfiguration: Driver<WidgetPhotoCarouselConfiguration>
        let photos1: Driver<[WidgetPhoto]>
        let photos2: Driver<[WidgetPhoto]>
        let photos3: Driver<[WidgetPhoto]>
    }
    
    func configure(input: Input) -> Output {
        let storageModel = makeStorageModel(id: storageModelId)
        let selectedPhoto1 = makeSelectedPhoto(
            initial: initialConfiguration.map { $0.photo1 },
            didAddPhoto: input.didAddPhoto1,
            didSelectPhoto: input.didSelectPhoto1,
            didTapResetPhoto: input.didTapResetPhoto1
        )
        let selectedPhoto2 = makeSelectedPhoto(
            initial: initialConfiguration.map { $0.photo2 },
            didAddPhoto: input.didAddPhoto2,
            didSelectPhoto: input.didSelectPhoto2,
            didTapResetPhoto: input.didTapResetPhoto2
        )
        let selectedPhoto3 = makeSelectedPhoto(
            initial: initialConfiguration.map { $0.photo3 },
            didAddPhoto: input.didAddPhoto3,
            didSelectPhoto: input.didSelectPhoto3,
            didTapResetPhoto: input.didTapResetPhoto3
        )
        let configuration = makeConfiguration(
            initialConfiguration: initialConfiguration,
            selectedPhoto1: selectedPhoto1,
            selectedPhoto2: selectedPhoto2,
            selectedPhoto3: selectedPhoto3
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
                configuration: configuration
            ),
            configuration: configuration,
            defaultConfiguration: Driver.deferred { .just(WidgetPhotoCarouselConfiguration.default()) },
            photos1: makePhotos(
                initial: initialConfiguration.map { $0.photo1 },
                didAddPhoto: input.didAddPhoto1
            ),
            photos2: makePhotos(
                initial: initialConfiguration.map { $0.photo2 },
                didAddPhoto: input.didAddPhoto2
            ),
            photos3: makePhotos(
                initial: initialConfiguration.map { $0.photo3 },
                didAddPhoto: input.didAddPhoto3
            )
        )
    }
}

// MARK: Private
extension WidgetPhotoCarouselViewModel {
    func makeEnableRestoreDefault(
        defaultConfiguration: Driver<WidgetPhotoCarouselConfiguration>,
        configuration: Driver<WidgetPhotoCarouselConfiguration>
    ) -> Driver<Bool> {
        Driver
            .combineLatest(defaultConfiguration, configuration)
            .map { defaultConfiguration, configuration -> Bool in
                let isEqualPhoto1 = defaultConfiguration.photo1 == configuration.photo1
                let isEqualPhoto2 = defaultConfiguration.photo2 == configuration.photo2
                let isEqualPhoto3 = defaultConfiguration.photo3 == configuration.photo3
                return !(isEqualPhoto1 && isEqualPhoto2 && isEqualPhoto3)
            }
    }
    
    func makeConfiguration(
        initialConfiguration: Driver<WidgetPhotoCarouselConfiguration>,
        selectedPhoto1: Driver<WidgetPhoto>,
        selectedPhoto2: Driver<WidgetPhoto>,
        selectedPhoto3: Driver<WidgetPhoto>
    ) -> Driver<WidgetPhotoCarouselConfiguration> {
        let photo1 = Driver<WidgetPhoto>
            .merge(
                initialConfiguration
                    .map { $0.photo1 },
                
                selectedPhoto1
            )
        
        let photo2 = Driver<WidgetPhoto>
            .merge(
                initialConfiguration
                    .map { $0.photo2 },
                
                selectedPhoto2
            )
        
        let photo3 = Driver<WidgetPhoto>
            .merge(
                initialConfiguration
                    .map { $0.photo3 },
                
                selectedPhoto3
            )
        
        let changedConfiguration = Driver
            .combineLatest(photo1, photo2, photo3)
            .map { photo1, photo2, photo3 -> WidgetPhotoCarouselConfiguration in
                WidgetPhotoCarouselConfiguration(
                    photo1: photo1,
                    photo2: photo2,
                    photo3: photo3
                )
            }
        
        return Driver
            .merge(initialConfiguration, changedConfiguration)
    }
    
    func makeAction(
        didTapHelper: Signal<Void>,
        didTapOpenPreview: Signal<Void>,
        didTapSave: Signal<Void>,
        didTapRemove: Signal<Void>,
        didRemoveConfirmed: Signal<Void>,
        storageModelId: Driver<String?>,
        didEnterName: Signal<String>,
        storageModel: Driver<WidgetPhotoCarouselStorageModel?>,
        configuration: Driver<WidgetPhotoCarouselConfiguration>
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
            .withLatestFrom(configuration) { ($0.0, $0.1, $1) }
            .flatMapLatest { name, id, configuration -> Signal<(String?, String, WidgetPhotoCarouselConfiguration)> in
                func resolvePhoto(_ photo: WidgetPhoto) -> Signal<WidgetPhoto> {
                    switch photo {
                    case .photoAssetId(let assetId):
                        return Observable<WidgetPhoto>
                            .create { observer in
                                let requestId = PhotoAssetImageLoader.shared.loadImage(assetId: assetId) { image in
                                    guard
                                        let image,
                                        let fileName = SharedImageFileStore.shared.save(
                                            image: image,
                                            format: .jpeg(quality: 0.9)
                                        )
                                    else {
                                        observer.onCompleted()
                                        return
                                    }

                                    observer.onNext(.fileName(fileName))
                                    observer.onCompleted()
                                }

                                return Disposables.create {
                                    PhotoAssetImageLoader.shared.cancel(requestId)
                                }
                            }
                            .asSignal(onErrorSignalWith: .never())

                    default:
                        return .just(photo)
                    }
                }

                return Signal
                    .combineLatest(
                        resolvePhoto(configuration.photo1),
                        resolvePhoto(configuration.photo2),
                        resolvePhoto(configuration.photo3)
                    )
                    .map { photo1, photo2, photo3 in
                        let updatedConfiguration = WidgetPhotoCarouselConfiguration(
                            photo1: photo1,
                            photo2: photo2,
                            photo3: photo3
                        )

                        return (id, name, updatedConfiguration)
                    }
            }
            .flatMapLatest { id, name, configuration -> Driver<Action> in
                let model: Single<WidgetPhotoCarouselStorageModel> = { [weak self] in
                    guard let self else { return .never() }

                    if let id {
                        return service.editPhotoCarousel(
                            name: name,
                            storageModelId: id,
                            configuration: configuration
                        )
                    } else {
                        return service.savePhotoCarousel(
                            name: name,
                            configuration: configuration
                        )
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
                    .deletePhotoCarousel(storageModelId: id)
                    .map { Action.close }
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(openHelper, openPreview, enterName, requestRemoveConfirmation, saveAndClose, removeAndClose)
    }
    
    func makeStorageModel(id: Driver<String?>) -> Driver<WidgetPhotoCarouselStorageModel?> {
        id
            .flatMapLatest { [weak self] id -> Driver<WidgetPhotoCarouselStorageModel?> in
                guard let self, let id else {
                    return .just(nil)
                }
                
                return service
                    .fetchPhotoCarouselConfigurations()
                    .map { configs -> WidgetPhotoCarouselStorageModel? in
                        configs.first(where: { $0.id == id })
                    }
                    .asDriver(onErrorJustReturn: nil)
            }
    }
    
    func makeSelectedPhoto(
        initial: Driver<WidgetPhoto>,
        didAddPhoto: Signal<WidgetPhoto>,
        didSelectPhoto: Signal<WidgetPhoto>,
        didTapResetPhoto: Signal<Void>,
    ) -> Driver<WidgetPhoto> {
        Driver<WidgetPhoto>
            .merge(
                initial
                    .map { $0 },
                
                didTapResetPhoto
                    .asDriver(onErrorDriveWith: .never())
                    .withLatestFrom(initial)
                    .map { $0 }
                    .asDriver(onErrorDriveWith: .never()),
                
                didAddPhoto
                    .asDriver(onErrorDriveWith: .never()),
                
                didSelectPhoto
                    .asDriver(onErrorDriveWith: .never())
            )
    }
    
    func makePhotos(
        initial: Driver<WidgetPhoto>,
        didAddPhoto: Signal<WidgetPhoto>
    ) -> Driver<[WidgetPhoto]> {
        enum Action {
            case initial([WidgetPhoto])
            case add(WidgetPhoto)
        }
        
        let action = Driver
            .merge(
                initial
                    .map { Action.initial([$0]) },
                
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
