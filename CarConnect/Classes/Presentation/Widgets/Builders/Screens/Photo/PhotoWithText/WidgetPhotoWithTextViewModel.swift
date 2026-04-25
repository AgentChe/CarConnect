//
//  WidgetPhotoWithTextViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 04.04.2026.
//

import RxSwift
import RxCocoa

final class WidgetPhotoWithTextViewModel {
    enum Action {
        case openHelper
        case openPreview
        case close
        case requestRemoveConfirmation
        case enterName(String)
    }
    
    private let storageModelId: Driver<String?>
    private let initialConfiguration: Driver<WidgetPhotoWithTextConfiguration>
    
    private lazy var service = WidgetPhotoService()
    
    init(storageModelId: String?, configuration: WidgetPhotoWithTextConfiguration) {
        self.storageModelId = BehaviorRelay(value: storageModelId).asDriver()
        self.initialConfiguration = BehaviorRelay(value: configuration).asDriver()
    }
}

// MARK: Public
extension WidgetPhotoWithTextViewModel {
    struct Input {
        let didTapHelper: Signal<Void>
        let didTapRestoreDefault: Signal<Void>
        let didTapOpenPreview: Signal<Void>
        let didTapSave: Signal<Void>
        let didTapRemove: Signal<Void>
        let didRemoveConfirmed: Signal<Void>
        let didEnterName: Signal<String>
        let didAddPhoto: Signal<WidgetPhoto>
        let didSelectPhoto: Signal<WidgetPhoto>
        let didTapResetPhoto: Signal<Void>
        let didEnterText: Signal<String>
        let didSelectFont: Signal<WidgetsFonts>
        let didTapResetFont: Signal<Void>
        let didSelectColor: Signal<UIColor>
        let didTapResetColor: Signal<Void>
    }
    
    struct Output {
        let defaultConfiguration: Driver<WidgetPhotoWithTextConfiguration>
        let configuration: Driver<WidgetPhotoWithTextConfiguration>
        let enableRestoreDefault: Driver<Bool>
        let action: Driver<Action>
        let photos: Driver<[WidgetPhoto]>
        let selectedPhoto: Driver<WidgetPhoto>
    }
    
    func configure(input: Input) -> Output {
        let storageModel = makeStorageModel(id: storageModelId)
        let defaultConfiguration = makeDefaultConfiguration()
        let configuration = makeConfiguration(
            initialConfiguration: initialConfiguration,
            defaultConfiguration: defaultConfiguration,
            didTapRestoreDefault: input.didTapRestoreDefault,
            didAddPhoto: input.didAddPhoto,
            didSelectPhoto: input.didSelectPhoto,
            didTapResetPhoto: input.didTapResetPhoto,
            didEnterText: input.didEnterText,
            didSelectFont: input.didSelectFont,
            didTapResetFont: input.didTapResetFont,
            didSelectColor: input.didSelectColor,
            didTapResetColor: input.didTapResetColor
        )
        
        return Output(
            defaultConfiguration: defaultConfiguration,
            configuration: configuration,
            enableRestoreDefault: makeEnableRestoreDefault(
                defaultConfiguration: defaultConfiguration,
                configuration: configuration
            ),
            action: makeAction(
                didTapHelper: input.didTapHelper,
                didTapOpenPreview: input.didTapOpenPreview,
                didTapSave: input.didTapSave,
                configuration: configuration,
                didTapRemove: input.didTapRemove,
                didRemoveConfirmed: input.didRemoveConfirmed,
                storageModelId: storageModelId,
                didEnterName: input.didEnterName,
                storageModel: storageModel
            ),
            photos: makePhotos(
                initialConfiguration: initialConfiguration,
                didAddPhoto: input.didAddPhoto
            ),
            selectedPhoto: makeSelectedPhoto(
                configuration: configuration,
                didSelectPhoto: input.didSelectPhoto
            )
        )
    }
}

// MARK: Private
extension WidgetPhotoWithTextViewModel {
    func makeEnableRestoreDefault(
        defaultConfiguration: Driver<WidgetPhotoWithTextConfiguration>,
        configuration: Driver<WidgetPhotoWithTextConfiguration>
    ) -> Driver<Bool> {
        Driver
            .combineLatest(defaultConfiguration, configuration)
            .map { defaultConfiguration, configuration -> Bool in
                let isEqualPhoto = defaultConfiguration.photo == configuration.photo
                let isEqualFont = defaultConfiguration.font == configuration.font
                let isEqualFontColor = defaultConfiguration.textColor.wrappedValue.isEqualTo(configuration.textColor.wrappedValue)
                return !(isEqualPhoto && isEqualFont && isEqualFontColor)
            }
    }
    
    func makeConfiguration(
        initialConfiguration: Driver<WidgetPhotoWithTextConfiguration>,
        defaultConfiguration: Driver<WidgetPhotoWithTextConfiguration>,
        didTapRestoreDefault: Signal<Void>,
        didAddPhoto: Signal<WidgetPhoto>,
        didSelectPhoto: Signal<WidgetPhoto>,
        didTapResetPhoto: Signal<Void>,
        didEnterText: Signal<String>,
        didSelectFont: Signal<WidgetsFonts>,
        didTapResetFont: Signal<Void>,
        didSelectColor: Signal<UIColor>,
        didTapResetColor: Signal<Void>
    ) -> Driver<WidgetPhotoWithTextConfiguration> {
        let photo = Driver<WidgetPhoto>
            .merge(
                initialConfiguration
                    .map { $0.photo },
                
                Signal
                    .merge(
                        didTapResetPhoto,
                        didTapRestoreDefault
                    )
                    .withLatestFrom(defaultConfiguration)
                    .map { $0.photo }
                    .asDriver(onErrorDriveWith: .never()),
                
                didAddPhoto
                    .asDriver(onErrorDriveWith: .never()),
                
                didSelectPhoto
                    .asDriver(onErrorDriveWith: .never())
            )
        
        let text = didEnterText.asDriver(onErrorJustReturn: "")
        
        let font = Driver<WidgetsFonts>
            .merge(
                initialConfiguration
                    .map { $0.font },
                
                Signal
                    .merge(
                        didTapResetFont,
                        didTapRestoreDefault
                    )
                    .withLatestFrom(defaultConfiguration)
                    .map { $0.font }
                    .asDriver(onErrorDriveWith: .never()),
                
                didSelectFont
                    .asDriver(onErrorDriveWith: .never())
            )
        
        let textColor = Driver<CodableColor>
            .merge(
                initialConfiguration
                    .map { $0.textColor },
                
                Signal
                    .merge(
                        didTapResetColor,
                        didTapRestoreDefault
                    )
                    .withLatestFrom(defaultConfiguration)
                    .map { $0.textColor }
                    .asDriver(onErrorDriveWith: .never()),
                
                didSelectColor
                    .map { CodableColor(wrappedValue: $0) }
                    .asDriver(onErrorDriveWith: .never())
            )
        
        let changedConfiguration = Driver
            .combineLatest(photo, text, font, textColor)
            .map { photo, text, font, textColor -> WidgetPhotoWithTextConfiguration in
                WidgetPhotoWithTextConfiguration(
                    photo: photo,
                    text: text,
                    font: font,
                    textColor: textColor
                )
            }
        
        return Driver
            .merge(initialConfiguration, changedConfiguration)
    }
    
    func makeDefaultConfiguration() -> Driver<WidgetPhotoWithTextConfiguration> {
        .deferred { .just(WidgetPhotoWithTextConfiguration.default()) }
    }
    
    func makeAction(
        didTapHelper: Signal<Void>,
        didTapOpenPreview: Signal<Void>,
        didTapSave: Signal<Void>,
        configuration: Driver<WidgetPhotoWithTextConfiguration>,
        didTapRemove: Signal<Void>,
        didRemoveConfirmed: Signal<Void>,
        storageModelId: Driver<String?>,
        didEnterName: Signal<String>,
        storageModel: Driver<WidgetPhotoWithTextStorageModel?>
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
            .flatMapLatest { name, id, configuration -> Signal<(String?, String, WidgetPhotoWithTextConfiguration)> in
                switch configuration.photo {
                case .photoAssetId(let assetId):
                    return Observable<(String?, String, WidgetPhotoWithTextConfiguration)>
                        .create { observer in
                            let requestId = PhotoAssetImageLoader.shared.loadImage(assetId: assetId) { image in
                                guard let image, let fileName = SharedImageFileStore.shared.save(image: image, format: .jpeg(quality: 0.9)) else {
                                    observer.onCompleted()
                                    return
                                }
                                
                                let updated = WidgetPhotoWithTextConfiguration(
                                    photo: WidgetPhoto.fileName(fileName),
                                    text: configuration.text,
                                    font: configuration.font,
                                    textColor: configuration.textColor
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
                    return .just((id, name, configuration))
                }
            }
            .flatMapLatest { id, name, configuration -> Driver<Action> in
                let model: Single<WidgetPhotoWithTextStorageModel> = { [weak self] in
                    guard let self else { return .never() }
                    
                    if let id {
                        return service.editPhotoWithText(
                            name: name,
                            storageModelId: id,
                            configuration: configuration
                        )
                    } else {
                        return service
                            .savePhotoWithText(name: name, configuration: configuration)
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
                    .deletePhotoWithText(storageModelId: id)
                    .map { Action.close }
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(openHelper, openPreview, enterName, saveAndClose, requestRemoveConfirmation, removeAndClose)
    }
    
    func makeStorageModel(id: Driver<String?>) -> Driver<WidgetPhotoWithTextStorageModel?> {
        id
            .flatMapLatest { [weak self] id -> Driver<WidgetPhotoWithTextStorageModel?> in
                guard let self, let id else {
                    return .just(nil)
                }
                
                return service
                    .fetchPhotoWithTextConfigurations()
                    .map { configs -> WidgetPhotoWithTextStorageModel? in
                        configs.first(where: { $0.id == id })
                    }
                    .asDriver(onErrorJustReturn: nil)
            }
    }
    
    func makeSelectedPhoto(
        configuration: Driver<WidgetPhotoWithTextConfiguration>,
        didSelectPhoto: Signal<WidgetPhoto>
    ) -> Driver<WidgetPhoto> {
        Driver
            .merge(
                configuration.map { $0.photo }.distinctUntilChanged(),
                didSelectPhoto.asDriver(onErrorDriveWith: .never())
            )
    }
    
    func makePhotos(
        initialConfiguration: Driver<WidgetPhotoWithTextConfiguration>,
        didAddPhoto: Signal<WidgetPhoto>
    ) -> Driver<[WidgetPhoto]> {
        enum Action {
            case initial([WidgetPhoto])
            case add(WidgetPhoto)
        }
        
        let action = Driver
            .merge(
                initialConfiguration
                    .map { Action.initial([$0.photo]) },
                
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
