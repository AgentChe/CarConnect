//
//  WidgetClockAIPreviewViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 01.04.2026.
//

import RxSwift
import RxCocoa

final class WidgetClockAIPreviewViewModel {
    enum Action {
        case openHelper
        case openPreview
        case close
        case requestRemoveConfirmation
        case enterName(String)
    }
    
    private let storageModelId: Driver<String?>
    private let initialConfiguration: Driver<WidgetClockAIPreviewConfiguration>
    
    private lazy var service = WidgetClockService()
    
    init(storageModelId: String?, configuration: WidgetClockAIPreviewConfiguration) {
        self.storageModelId = BehaviorRelay(value: storageModelId).asDriver()
        self.initialConfiguration = BehaviorRelay(value: configuration).asDriver()
    }
}

// MARK: Public
extension WidgetClockAIPreviewViewModel {
    struct Input {
        let didTapHelper: Signal<Void>
        let didSelectConfigurationTabItem: Signal<WidgetBuilderConfigurationTabItemButton.Item>
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
        let defaultConfiguration: Driver<WidgetClockAIPreviewConfiguration>
        let configuration: Driver<WidgetClockAIPreviewConfiguration>
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
extension WidgetClockAIPreviewViewModel {
    func makeConfigurationTabItem(didSelectConfigurationTabItem: Signal<WidgetBuilderConfigurationTabItemButton.Item>) -> Driver<WidgetBuilderConfigurationTabItemButton.Item> {
        didSelectConfigurationTabItem
            .asDriver(onErrorDriveWith: .never())
            .startWith(.visualEditor)
    }
    
    func makeEnableRestoreDefault(
        defaultConfiguration: Driver<WidgetClockAIPreviewConfiguration>,
        configuration: Driver<WidgetClockAIPreviewConfiguration>
    ) -> Driver<Bool> {
        Driver
            .combineLatest(defaultConfiguration, configuration)
            .map { defaultConfiguration, configuration -> Bool in
                let isEqualFont = defaultConfiguration.font == configuration.font
                let isEqualFontColor = defaultConfiguration.textColor.wrappedValue.isEqualTo(configuration.textColor.wrappedValue)
                let isEqualTimeFormat = defaultConfiguration.timeFormat == configuration.timeFormat
                return !(isEqualFont && isEqualFontColor && isEqualTimeFormat)
            }
    }
    
    func makeConfiguration(
        initialConfiguration: Driver<WidgetClockAIPreviewConfiguration>,
        defaultConfiguration: Driver<WidgetClockAIPreviewConfiguration>,
        didTapResetFont: Signal<Void>,
        didSelectFont: Signal<WidgetsFonts>,
        didTapResetFontColor: Signal<Void>,
        didSelectFontColor: Signal<UIColor>,
        didEnableChangedTwentyFourHour: Signal<Bool>,
        didTapRestoreDefault: Signal<Void>
    ) -> Driver<WidgetClockAIPreviewConfiguration> {
        let url = initialConfiguration.map { $0.url }
        
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
            .combineLatest(url, font, fontColor, timeFormat)
            .map { url, font, fontColor, timeFormat -> WidgetClockAIPreviewConfiguration in
                WidgetClockAIPreviewConfiguration(
                    url: url,
                    font: font,
                    textColor: fontColor,
                    timeFormat: timeFormat
                )
            }
        
        return Driver
            .merge(initialConfiguration, changedConfiguration)
    }
    
    func makeDefaultConfiguration(initialConfiguration: Driver<WidgetClockAIPreviewConfiguration>) -> Driver<WidgetClockAIPreviewConfiguration> {
        initialConfiguration
            .map { WidgetClockAIPreviewConfiguration.default(url: $0.url) }
    }
    
    func makeAction(
        didTapHelper: Signal<Void>,
        didTapOpenPreview: Signal<Void>,
        didTapSave: Signal<Void>,
        configuration: Driver<WidgetClockAIPreviewConfiguration>,
        didTapRemove: Signal<Void>,
        didRemoveConfirmed: Signal<Void>,
        storageModelId: Driver<String?>,
        didEnterName: Signal<String>,
        storageModel: Driver<WidgetClockAIPreviewStorageModel?>
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
            .flatMapLatest { name, id, configuration -> Signal<(String?, String, WidgetClockAIPreviewConfiguration)> in
                Observable<(String?, String, WidgetClockAIPreviewConfiguration)>
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
                let model: Single<WidgetClockAIPreviewStorageModel> = { [weak self] in
                    guard let self else { return .never() }
                    
                    if let id {
                        return service.edit(
                            name: name,
                            storageAIPreviewModelId: id,
                            configuration: configuration
                        )
                    } else {
                        return service
                            .save(name: name, configurationAIPreview: configuration)
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
                    .delete(aiPreviewStorageModelId: id)
                    .map { Action.close }
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(openHelper, openPreview, enterName, saveAndClose, requestRemoveConfirmation, removeAndClose)
    }
    
    func makeStorageModel(id: Driver<String?>) -> Driver<WidgetClockAIPreviewStorageModel?> {
        id
            .flatMapLatest { [weak self] id -> Driver<WidgetClockAIPreviewStorageModel?> in
                guard let self, let id else {
                    return .just(nil)
                }
                
                return service
                    .fetchAIPreviewConfigurations()
                    .map { configs -> WidgetClockAIPreviewStorageModel? in
                        configs.first(where: { $0.id == id })
                    }
                    .asDriver(onErrorJustReturn: nil)
            }
    }
}
