//
//  WidgetTextManuallyViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.03.2026.
//

import RxSwift
import RxCocoa

final class WidgetTextManuallyViewModel {
    enum Action {
        case openHelper
        case openPreview
        case close
        case requestRemoveConfirmation
        case enterName(String)
    }
    
    private let storageModelId: Driver<String?>
    private let initialConfiguration: Driver<WidgetTextManuallyConfiguration>
    
    private lazy var service = WidgetTextService()
    
    init(storageModelId: String?, configuration: WidgetTextManuallyConfiguration) {
        self.storageModelId = BehaviorRelay(value: storageModelId).asDriver()
        self.initialConfiguration = BehaviorRelay(value: configuration).asDriver()
    }
}

// MARK: Public
extension WidgetTextManuallyViewModel {
    struct Input {
        let didTapHelper: Signal<Void>
        let didTapResetFont: Signal<Void>
        let didSelectFont: Signal<WidgetsFonts>
        let didTapResetFontColor: Signal<Void>
        let didSelectFontColor: Signal<UIColor>
        let didTapRestoreDefault: Signal<Void>
        let didTapOpenPreview: Signal<Void>
        let didTapSave: Signal<Void>
        let didTapRemove: Signal<Void>
        let didRemoveConfirmed: Signal<Void>
        let didChangeText: Signal<String>
        let didTapResetBackground: Signal<Void>
        let didSelectBackground: Signal<WidgetBackground>
        let didEnterName: Signal<String>
    }
    
    struct Output {
        let defaultConfiguration: Driver<WidgetTextManuallyConfiguration>
        let configuration: Driver<WidgetTextManuallyConfiguration>
        let enableRestoreDefault: Driver<Bool>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        let storageModel = makeStorageModel(id: storageModelId)
        let defaultConfiguration = makeDefaultConfiguration()
        let configuration = makeConfiguration(
            initialConfiguration: initialConfiguration,
            defaultConfiguration: defaultConfiguration,
            didTapResetFont: input.didTapResetFont,
            didSelectFont: input.didSelectFont,
            didTapResetFontColor: input.didTapResetFontColor,
            didSelectFontColor: input.didSelectFontColor,
            didTapRestoreDefault: input.didTapRestoreDefault,
            didChangeText: input.didChangeText,
            didTapResetBackground: input.didTapResetBackground,
            didSelectBackground: input.didSelectBackground
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
            )
        )
    }
}

// MARK: Private
extension WidgetTextManuallyViewModel {
    func makeEnableRestoreDefault(
        defaultConfiguration: Driver<WidgetTextManuallyConfiguration>,
        configuration: Driver<WidgetTextManuallyConfiguration>
    ) -> Driver<Bool> {
        Driver
            .combineLatest(defaultConfiguration, configuration)
            .map { defaultConfiguration, configuration -> Bool in
                let isEqualBackground = defaultConfiguration.background.isEqual(another: configuration.background)
                let isEqualFont = defaultConfiguration.font == configuration.font
                let isEqualFontColor = defaultConfiguration.textColor.isEqualTo(configuration.textColor)
                return !(isEqualBackground && isEqualFont && isEqualFontColor)
            }
    }
    
    func makeConfiguration(
        initialConfiguration: Driver<WidgetTextManuallyConfiguration>,
        defaultConfiguration: Driver<WidgetTextManuallyConfiguration>,
        didTapResetFont: Signal<Void>,
        didSelectFont: Signal<WidgetsFonts>,
        didTapResetFontColor: Signal<Void>,
        didSelectFontColor: Signal<UIColor>,
        didTapRestoreDefault: Signal<Void>,
        didChangeText: Signal<String>,
        didTapResetBackground: Signal<Void>,
        didSelectBackground: Signal<WidgetBackground>
    ) -> Driver<WidgetTextManuallyConfiguration> {
        let text = didChangeText.asDriver(onErrorDriveWith: .never())
        
        let background = Driver<WidgetBackground>
            .merge(
                initialConfiguration
                    .map { $0.background },
                
                Signal
                    .merge(
                        didTapResetBackground,
                        didTapRestoreDefault
                    )
                    .withLatestFrom(defaultConfiguration)
                    .map { $0.background }
                    .asDriver(onErrorDriveWith: .never()),
                
                didSelectBackground
                    .asDriver(onErrorDriveWith: .never())
            )
        
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
        
        let fontColor = Driver<UIColor>
            .merge(
                initialConfiguration
                    .map { $0.textColor },
                
                Signal
                    .merge(
                        didTapResetFontColor,
                        didTapRestoreDefault
                    )
                    .withLatestFrom(defaultConfiguration)
                    .map { $0.textColor }
                    .asDriver(onErrorDriveWith: .never()),
                
                didSelectFontColor
                    .asDriver(onErrorDriveWith: .never())
            )
        
        let changedConfiguration = Driver
            .combineLatest(background, text, font, fontColor)
            .map { background, text, font, fontColor -> WidgetTextManuallyConfiguration in
                WidgetTextManuallyConfiguration(
                    background: background,
                    text: text,
                    font: font,
                    textColor: fontColor
                )
            }
        
        return Driver
            .merge(initialConfiguration, changedConfiguration)
    }
    
    func makeDefaultConfiguration() -> Driver<WidgetTextManuallyConfiguration> {
        Driver.deferred {
            .just(WidgetTextManuallyConfiguration.default())
        }
    }
    
    func makeAction(
        didTapHelper: Signal<Void>,
        didTapOpenPreview: Signal<Void>,
        didTapSave: Signal<Void>,
        configuration: Driver<WidgetTextManuallyConfiguration>,
        didTapRemove: Signal<Void>,
        didRemoveConfirmed: Signal<Void>,
        storageModelId: Driver<String?>,
        didEnterName: Signal<String>,
        storageModel: Driver<WidgetTextManuallyStorageModel?>
    ) -> Driver<Action> {
        let openHelper = didTapHelper
            .map { Action.openHelper }
            .asDriver(onErrorDriveWith: .never())
        
        let openPreview = didTapOpenPreview
            .map { Action.openPreview }
            .asDriver(onErrorDriveWith: .never())
        
        let enterName = didTapSave
            .withLatestFrom(storageModel)
            .map { Action.enterName($0?.name ?? "Text manually") }
            .asDriver(onErrorDriveWith: .never())
        
        let saveAndClose = didEnterName
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(storageModelId) { ($0, $1) }
            .withLatestFrom(configuration) { ($0.0, $0.1, $1) }
            .flatMapLatest { name, id, configuration -> Signal<(String?, String, WidgetTextManuallyConfiguration)> in
                switch configuration.background {
                case .photoAssetId(let assetId):
                    return Observable<(String?, String, WidgetTextManuallyConfiguration)>
                        .create { observer in
                            let requestId = PhotoAssetImageLoader.shared.loadImage(assetId: assetId) { image in
                                guard let image, let fileName = SharedImageFileStore.shared.save(image: image, format: .jpeg(quality: 0.9)) else {
                                    observer.onCompleted()
                                    return
                                }
                                
                                let updated = WidgetTextManuallyConfiguration(
                                    background: .fileName(fileName),
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
                let model: Single<WidgetTextManuallyStorageModel> = { [weak self] in
                    guard let self else { return .never() }
                    
                    if let id {
                        return service.edit(
                            name: name,
                            manuallyConfigurationStorageModelId: id,
                            manuallyConfiguration: configuration
                        )
                    } else {
                        return service
                            .save(name: name, manuallyConfiguration: configuration)
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
                    .delete(manuallyConfigurationStorageModelId: id)
                    .map { Action.close }
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(openHelper, openPreview, enterName, saveAndClose, requestRemoveConfirmation, removeAndClose)
    }
    
    func makeStorageModel(id: Driver<String?>) -> Driver<WidgetTextManuallyStorageModel?> {
        id
            .flatMapLatest { [weak self] id -> Driver<WidgetTextManuallyStorageModel?> in
                guard let self, let id else {
                    return .just(nil)
                }
                
                return service
                    .fetchManuallyConfigurations()
                    .map { quotes -> WidgetTextManuallyStorageModel? in
                        quotes.first(where: { $0.id == id })
                    }
                    .asDriver(onErrorJustReturn: nil)
            }
    }
}
