//
//  WidgetClockViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 26.03.2026.
//

import RxSwift
import RxCocoa

final class WidgetClockViewModel {
    enum Action {
        case openHelper
        case openPreview
        case close
        case requestRemoveConfirmation
        case enterName(String)
    }
    
    private let storageModelId: Driver<String?>
    private let initialConfiguration: Driver<WidgetClockConfiguration>
    
    private lazy var service = WidgetClockService()
    
    init(storageModelId: String?, configuration: WidgetClockConfiguration) {
        self.storageModelId = BehaviorRelay(value: storageModelId).asDriver()
        self.initialConfiguration = BehaviorRelay(value: configuration).asDriver()
    }
}

// MARK: Public
extension WidgetClockViewModel {
    struct Input {
        let didTapHelper: Signal<Void>
        let didSelectConfigurationTabItem: Signal<WidgetBuilderConfigurationTabItemButton.Item>
        let didTapResetBackground: Signal<Void>
        let didSelectBackground: Signal<WidgetBackground>
        let didTapResetFont: Signal<Void>
        let didSelectFont: Signal<WidgetsFonts>
        let didTapResetFontColor: Signal<Void>
        let didSelectFontColor: Signal<UIColor>
        let didEnableChangedTwentyFourHour: Signal<Bool>
        let didTapRestoreDefault: Signal<Void>
        let didTapOpenPreview: Signal<Void>
        let didTapSave: Signal<Void>
        let didTapRemove: Signal<Void>
        let didRemoveConfirmed: Signal<Void>
        let didEnterName: Signal<String>
    }
    
    struct Output {
        let defaultConfiguration: Driver<WidgetClockConfiguration>
        let configuration: Driver<WidgetClockConfiguration>
        let enableRestoreDefault: Driver<Bool>
        let action: Driver<Action>
        let configurationTabItem: Driver<WidgetBuilderConfigurationTabItemButton.Item>
    }
    
    func configure(input: Input) -> Output {
        let storageModel = makeStorageModel(id: storageModelId)
        let defaultConfiguration = makeDefaultConfiguration(initialConfiguration: initialConfiguration)
        let configuration = makeConfiguration(
            initialConfiguration: initialConfiguration,
            defaultConfiguration: defaultConfiguration,
            didTapResetBackground: input.didTapResetBackground,
            didSelectBackground: input.didSelectBackground,
            didTapResetFont: input.didTapResetFont,
            didSelectFont: input.didSelectFont,
            didTapResetFontColor: input.didTapResetFontColor,
            didSelectFontColor: input.didSelectFontColor,
            didEnableChangedTwentyFourHour: input.didEnableChangedTwentyFourHour,
            didTapRestoreDefault: input.didTapRestoreDefault
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
            configurationTabItem: makeConfigurationTabItem(didSelectConfigurationTabItem: input.didSelectConfigurationTabItem),
        )
    }
}

// MARK: Private
extension WidgetClockViewModel {
    func makeConfigurationTabItem(didSelectConfigurationTabItem: Signal<WidgetBuilderConfigurationTabItemButton.Item>) -> Driver<WidgetBuilderConfigurationTabItemButton.Item> {
        didSelectConfigurationTabItem
            .asDriver(onErrorDriveWith: .never())
            .startWith(.visualEditor)
    }
    
    func makeEnableRestoreDefault(
        defaultConfiguration: Driver<WidgetClockConfiguration>,
        configuration: Driver<WidgetClockConfiguration>
    ) -> Driver<Bool> {
        Driver
            .combineLatest(defaultConfiguration, configuration)
            .map { defaultConfiguration, configuration -> Bool in
                let isEqualBackground = defaultConfiguration.background.isEqual(another: configuration.background)
                let isEqualFont = defaultConfiguration.font == configuration.font
                let isEqualFontColor = defaultConfiguration.textColor.wrappedValue.isEqualTo(configuration.textColor.wrappedValue)
                let isEqualTimeFormat = defaultConfiguration.timeFormat == configuration.timeFormat
                return !(isEqualBackground && isEqualFont && isEqualFontColor && isEqualTimeFormat)
            }
    }
    
    func makeConfiguration(
        initialConfiguration: Driver<WidgetClockConfiguration>,
        defaultConfiguration: Driver<WidgetClockConfiguration>,
        didTapResetBackground: Signal<Void>,
        didSelectBackground: Signal<WidgetBackground>,
        didTapResetFont: Signal<Void>,
        didSelectFont: Signal<WidgetsFonts>,
        didTapResetFontColor: Signal<Void>,
        didSelectFontColor: Signal<UIColor>,
        didEnableChangedTwentyFourHour: Signal<Bool>,
        didTapRestoreDefault: Signal<Void>
    ) -> Driver<WidgetClockConfiguration> {
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
        
        let fontColor = Driver<CodableColor>
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
                    .map { CodableColor(wrappedValue: $0) }
                    .asDriver(onErrorDriveWith: .never())
            )
        
        let style = initialConfiguration.map { $0.style }
        
        let timeFormat = Driver<TimeFormat>
            .merge(
                initialConfiguration
                    .flatMapLatest { configuration -> Driver<TimeFormat> in
                        didEnableChangedTwentyFourHour
                            .map { $0 ? .twentyFourHour : .twelveHour }
                            .asDriver(onErrorDriveWith: .never())
                            .startWith(configuration.timeFormat)
                    },
                
                didTapRestoreDefault
                    .withLatestFrom(defaultConfiguration)
                    .map { $0.timeFormat }
                    .asDriver(onErrorDriveWith: .never())
            )
        
        let changedConfiguration = Driver
            .combineLatest(background, style, font, fontColor, timeFormat)
            .map { background, style, font, fontColor, timeFormat -> WidgetClockConfiguration in
                WidgetClockConfiguration(
                    style: style,
                    background: background,
                    font: font,
                    textColor: fontColor,
                    timeFormat: timeFormat
                )
            }
        
        return Driver
            .merge(initialConfiguration, changedConfiguration)
    }
    
    func makeDefaultConfiguration(initialConfiguration: Driver<WidgetClockConfiguration>) -> Driver<WidgetClockConfiguration> {
        initialConfiguration
            .map { WidgetClockConfiguration.default(for: $0.style) }
    }
    
    func makeAction(
        didTapHelper: Signal<Void>,
        didTapOpenPreview: Signal<Void>,
        didTapSave: Signal<Void>,
        configuration: Driver<WidgetClockConfiguration>,
        didTapRemove: Signal<Void>,
        didRemoveConfirmed: Signal<Void>,
        storageModelId: Driver<String?>,
        didEnterName: Signal<String>,
        storageModel: Driver<WidgetClockStorageModel?>
    ) -> Driver<Action> {
        let openHelper = didTapHelper
            .map { Action.openHelper }
            .asDriver(onErrorDriveWith: .never())
        
        let openPreview = didTapOpenPreview
            .map { Action.openPreview }
            .asDriver(onErrorDriveWith: .never())
        
        let enterName = didTapSave
            .withLatestFrom(storageModel)
            .map { Action.enterName($0?.name ?? "Clock") }
            .asDriver(onErrorDriveWith: .never())
        
        let saveAndClose = didEnterName
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(storageModelId) { ($0, $1) }
            .withLatestFrom(configuration) { ($0.0, $0.1, $1) }
            .flatMapLatest { name, id, configuration -> Signal<(String?, String, WidgetClockConfiguration)> in
                switch configuration.background {
                case .photoAssetId(let assetId):
                    return Observable<(String?, String, WidgetClockConfiguration)>
                        .create { observer in
                            let requestId = PhotoAssetImageLoader.shared.loadImage(assetId: assetId) { image in
                                guard let image, let fileName = SharedImageFileStore.shared.save(image: image, format: .jpeg(quality: 0.9)) else {
                                    observer.onCompleted()
                                    return
                                }
                                
                                let updated = WidgetClockConfiguration(
                                    style: configuration.style,
                                    background: .fileName(fileName),
                                    font: configuration.font,
                                    textColor: configuration.textColor,
                                    timeFormat: configuration.timeFormat
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
                let model: Single<WidgetClockStorageModel> = { [weak self] in
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
    
    func makeStorageModel(id: Driver<String?>) -> Driver<WidgetClockStorageModel?> {
        id
            .flatMapLatest { [weak self] id -> Driver<WidgetClockStorageModel?> in
                guard let self, let id else {
                    return .just(nil)
                }
                
                return service
                    .fetchConfigurations()
                    .map { configs -> WidgetClockStorageModel? in
                        configs.first(where: { $0.id == id })
                    }
                    .asDriver(onErrorJustReturn: nil)
            }
    }
}
