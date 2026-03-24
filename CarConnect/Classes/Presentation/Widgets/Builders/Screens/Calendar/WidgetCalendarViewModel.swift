//
//  WidgetCalendarViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 08.03.2026.
//

import RxSwift
import RxCocoa

final class WidgetCalendarViewModel {
    enum Action {
        case openHelper
        case openPreview
        case close
        case requestRemoveConfirmation
        case enterName(String)
    }
    
    private let storageModelId: Driver<String?>
    private let initialConfiguration: Driver<WidgetCalendarConfiguration>
    
    private lazy var service = WidgetCalendarService()
    
    init(storageModelId: String?, configuration: WidgetCalendarConfiguration) {
        self.storageModelId = BehaviorRelay(value: storageModelId).asDriver()
        self.initialConfiguration = BehaviorRelay(value: configuration).asDriver()
    }
}

// MARK: Public
extension WidgetCalendarViewModel {
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
        let didTapResetBackground: Signal<Void>
        let didSelectBackground: Signal<WidgetBackground>
        let didEnterName: Signal<String>
    }
    
    struct Output {
        let defaultConfiguration: Driver<WidgetCalendarConfiguration>
        let configuration: Driver<WidgetCalendarConfiguration>
        let enableRestoreDefault: Driver<Bool>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        let storageModel = makeStorageModel(id: storageModelId)
        let defaultConfiguration = makeDefaultConfiguration(initialConfiguration: initialConfiguration)
        let configuration = makeConfiguration(
            initialConfiguration: initialConfiguration,
            defaultConfiguration: defaultConfiguration,
            didTapResetFont: input.didTapResetFont,
            didSelectFont: input.didSelectFont,
            didTapResetFontColor: input.didTapResetFontColor,
            didSelectFontColor: input.didSelectFontColor,
            didTapRestoreDefault: input.didTapRestoreDefault,
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
extension WidgetCalendarViewModel {
    func makeEnableRestoreDefault(
        defaultConfiguration: Driver<WidgetCalendarConfiguration>,
        configuration: Driver<WidgetCalendarConfiguration>
    ) -> Driver<Bool> {
        Driver
            .combineLatest(defaultConfiguration, configuration)
            .map { defaultConfiguration, configuration -> Bool in
                let isEqualBackground = defaultConfiguration.background.isEqual(another: configuration.background)
                let isEqualFont = defaultConfiguration.font == configuration.font
                let isEqualFontColor = defaultConfiguration.fontColor.isEqualTo(configuration.fontColor)
                return !(isEqualBackground && isEqualFont && isEqualFontColor)
            }
    }
    
    func makeConfiguration(
        initialConfiguration: Driver<WidgetCalendarConfiguration>,
        defaultConfiguration: Driver<WidgetCalendarConfiguration>,
        didTapResetFont: Signal<Void>,
        didSelectFont: Signal<WidgetsFonts>,
        didTapResetFontColor: Signal<Void>,
        didSelectFontColor: Signal<UIColor>,
        didTapRestoreDefault: Signal<Void>,
        didTapResetBackground: Signal<Void>,
        didSelectBackground: Signal<WidgetBackground>
    ) -> Driver<WidgetCalendarConfiguration> {
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
                    .map { $0.fontColor },
                
                Signal
                    .merge(
                        didTapResetFontColor,
                        didTapRestoreDefault
                    )
                    .withLatestFrom(defaultConfiguration)
                    .map { $0.fontColor }
                    .asDriver(onErrorDriveWith: .never()),
                
                didSelectFontColor
                    .asDriver(onErrorDriveWith: .never())
            )
        
        let style = initialConfiguration.map { $0.style }
        
        let changedConfiguration = Driver
            .combineLatest(style, background, font, fontColor)
            .map { style, background, font, fontColor -> WidgetCalendarConfiguration in
                WidgetCalendarConfiguration(
                    style: style,
                    background: background,
                    fontColor: fontColor,
                    font: font
                )
            }
        
        return Driver
            .merge(initialConfiguration, changedConfiguration)
    }
    
    func makeDefaultConfiguration(initialConfiguration: Driver<WidgetCalendarConfiguration>) -> Driver<WidgetCalendarConfiguration> {
        initialConfiguration
            .map { WidgetCalendarConfiguration.default(for: $0.style) }
    }
    
    func makeAction(
        didTapHelper: Signal<Void>,
        didTapOpenPreview: Signal<Void>,
        didTapSave: Signal<Void>,
        configuration: Driver<WidgetCalendarConfiguration>,
        didTapRemove: Signal<Void>,
        didRemoveConfirmed: Signal<Void>,
        storageModelId: Driver<String?>,
        didEnterName: Signal<String>,
        storageModel: Driver<WidgetCalendarStorageModel?>
    ) -> Driver<Action> {
        let openHelper = didTapHelper
            .map { Action.openHelper }
            .asDriver(onErrorDriveWith: .never())
        
        let openPreview = didTapOpenPreview
            .map { Action.openPreview }
            .asDriver(onErrorDriveWith: .never())
        
        let enterName = didTapSave
            .withLatestFrom(storageModel)
            .map { Action.enterName($0?.name ?? "Calendar") }
            .asDriver(onErrorDriveWith: .never())
        
        let saveAndClose = didEnterName
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(storageModelId) { ($0, $1) }
            .withLatestFrom(configuration) { ($0.0, $0.1, $1) }
            .flatMapLatest { name, id, configuration -> Signal<(String?, String, WidgetCalendarConfiguration)> in
                switch configuration.background {
                case .photoAssetId(let assetId):
                    return Observable<(String?, String, WidgetCalendarConfiguration)>
                        .create { observer in
                            let requestId = PhotoAssetImageLoader.shared.loadImage(assetId: assetId) { image in
                                guard let image, let fileName = SharedImageFileStore.shared.save(image: image, format: .jpeg(quality: 0.9)) else {
                                    observer.onCompleted()
                                    return
                                }
                                
                                let updated = WidgetCalendarConfiguration(
                                    style: configuration.style,
                                    background: .fileName(fileName),
                                    fontColor: configuration.fontColor,
                                    font: configuration.font
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
                let model: Single<WidgetCalendarStorageModel> = { [weak self] in
                    guard let self else { return .never() }
                    
                    if let id {
                        return service.edit(
                            name: name,
                            storageModelId: id,
                            configuration: configuration
                        )
                    } else {
                        return service
                            .save(name: name, configuration: configuration)
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
                    .delete(storageModelId: id)
                    .map { Action.close }
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(openHelper, openPreview, enterName, saveAndClose, requestRemoveConfirmation, removeAndClose)
    }
    
    func makeStorageModel(id: Driver<String?>) -> Driver<WidgetCalendarStorageModel?> {
        id
            .flatMapLatest { [weak self] id -> Driver<WidgetCalendarStorageModel?> in
                guard let self, let id else {
                    return .just(nil)
                }
                
                return service
                    .fetchConfigurations()
                    .map { configs -> WidgetCalendarStorageModel? in
                        configs.first(where: { $0.id == id })
                    }
                    .asDriver(onErrorJustReturn: nil)
            }
    }
}
