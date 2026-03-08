//
//  WidgetTextQuoteViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 23.02.2026.
//

import RxSwift
import RxCocoa

final class WidgetTextQuoteViewModel {
    enum Action {
        case openHelper
        case openPreview
        case close
        case requestRemoveConfirmation
        case enterName(String)
    }
    
    private let storageModelId: Driver<String?>
    private let initialQuote: Driver<WidgetTextQuote>
    private let initialConfiguration: Driver<WidgetTextQuoteConfiguration>
    
    private lazy var service = WidgetTextService()
    
    init(storageModelId: String?, quote: WidgetTextQuote, configuration: WidgetTextQuoteConfiguration) {
        self.storageModelId = BehaviorRelay(value: storageModelId).asDriver()
        self.initialQuote = BehaviorRelay(value: quote).asDriver()
        self.initialConfiguration = BehaviorRelay(value: configuration).asDriver()
    }
}

// MARK: Public
extension WidgetTextQuoteViewModel {
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
        let didChangeQuote: Signal<WidgetTextQuote>
        let didEnterName: Signal<String>
    }
    
    struct Output {
        let defaultConfiguration: Driver<WidgetTextQuoteConfiguration>
        let configuration: Driver<WidgetTextQuoteConfiguration>
        let enableRestoreDefault: Driver<Bool>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        let storageModel = makeStorageModel(id: storageModelId)
        let defaultConfiguration = makeDefaultConfiguration(quote: initialQuote)
        let configuration = makeConfiguration(
            initialConfiguration: initialConfiguration,
            defaultConfiguration: defaultConfiguration,
            didTapResetFont: input.didTapResetFont,
            didSelectFont: input.didSelectFont,
            didTapResetFontColor: input.didTapResetFontColor,
            didSelectFontColor: input.didSelectFontColor,
            didTapRestoreDefault: input.didTapRestoreDefault
        )
        let quote = makeQuote(
            initialQuote: initialQuote,
            didChangeQuote: input.didChangeQuote
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
                quote: quote,
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
private extension WidgetTextQuoteViewModel {
    func makeQuote(
        initialQuote: Driver<WidgetTextQuote>,
        didChangeQuote: Signal<WidgetTextQuote>
    ) -> Driver<WidgetTextQuote> {
        Driver
            .merge(
                initialQuote,
                didChangeQuote.asDriver(onErrorDriveWith: .never())
            )
    }
    
    func makeEnableRestoreDefault(
        defaultConfiguration: Driver<WidgetTextQuoteConfiguration>,
        configuration: Driver<WidgetTextQuoteConfiguration>
    ) -> Driver<Bool> {
        Driver
            .combineLatest(defaultConfiguration, configuration)
            .map { defaultConfiguration, configuration -> Bool in
                let isEqualFont = defaultConfiguration.font == configuration.font
                let isEqualFontColor = defaultConfiguration.textColor.isEqualTo(configuration.textColor)
                return !(isEqualFont && isEqualFontColor)
            }
    }
    
    func makeConfiguration(
        initialConfiguration: Driver<WidgetTextQuoteConfiguration>,
        defaultConfiguration: Driver<WidgetTextQuoteConfiguration>,
        didTapResetFont: Signal<Void>,
        didSelectFont: Signal<WidgetsFonts>,
        didTapResetFontColor: Signal<Void>,
        didSelectFontColor: Signal<UIColor>,
        didTapRestoreDefault: Signal<Void>
    ) -> Driver<WidgetTextQuoteConfiguration> {
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
            .combineLatest(font, fontColor)
            .map { font, fontColor -> WidgetTextQuoteConfiguration in
                WidgetTextQuoteConfiguration(
                    font: font,
                    textColor: fontColor
                )
            }
        
        return Driver
            .merge(initialConfiguration, changedConfiguration)
    }
    
    func makeDefaultConfiguration(quote: Driver<WidgetTextQuote>) -> Driver<WidgetTextQuoteConfiguration> {
        quote
            .map { quote -> WidgetTextQuoteConfiguration in
                switch quote {
                case .ambitionDrive:
                    return WidgetTextQuoteConfiguration.ambitionDriveDefault()
                case .mindsetGrowth:
                    return WidgetTextQuoteConfiguration.mindsetGrowthDefault()
                case .leadershipImpact:
                    return WidgetTextQuoteConfiguration.leadershipImpactDefault()
                case .lifeMeaning:
                    return WidgetTextQuoteConfiguration.lifeMeaningDefault()
                }
            }
    }
    
    func makeAction(
        didTapHelper: Signal<Void>,
        didTapOpenPreview: Signal<Void>,
        didTapSave: Signal<Void>,
        quote: Driver<WidgetTextQuote>,
        configuration: Driver<WidgetTextQuoteConfiguration>,
        didTapRemove: Signal<Void>,
        didRemoveConfirmed: Signal<Void>,
        storageModelId: Driver<String?>,
        didEnterName: Signal<String>,
        storageModel: Driver<WidgetTextQuoteStorageModel?>
    ) -> Driver<Action> {
        let openHelper = didTapHelper
            .map { Action.openHelper }
            .asDriver(onErrorDriveWith: .never())
        
        let openPreview = didTapOpenPreview
            .map { Action.openPreview }
            .asDriver(onErrorDriveWith: .never())
        
        let enterName = didTapSave
            .withLatestFrom(storageModel)
            .map { Action.enterName($0?.name ?? "Text Quote") }
            .asDriver(onErrorDriveWith: .never())
        
        let saveAndClose = didEnterName
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(storageModelId) { ($0, $1) }
            .withLatestFrom(quote) { ($0.0, $0.1, $1) }
            .withLatestFrom(configuration) { ($0.0, $0.1, $0.2, $1) }
            .flatMapLatest { name, id, quote, configuration -> Driver<Action> in
                let model: Single<WidgetTextQuoteStorageModel> = { [weak self] in
                    guard let self else { return .never() }
                    
                    if let id {
                        return service
                            .edit(
                                name: name,
                                quoteStorageModelId: id,
                                quote: quote,
                                configuration: configuration
                            )
                    } else {
                        return service
                            .save(
                                name: name,
                                quote: quote,
                                configuration: configuration
                            )
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
                    .delete(quoteStorageModelId: id)
                    .map { Action.close }
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(openHelper, openPreview, enterName, saveAndClose, requestRemoveConfirmation, removeAndClose)
    }
    
    func makeStorageModel(id: Driver<String?>) -> Driver<WidgetTextQuoteStorageModel?> {
        id
            .flatMapLatest { [weak self] id -> Driver<WidgetTextQuoteStorageModel?> in
                guard let self, let id else {
                    return .just(nil)
                }
                
                return service
                    .fetchQuotes()
                    .map { quotes -> WidgetTextQuoteStorageModel? in
                        quotes.first(where: { $0.id == id })
                    }
                    .asDriver(onErrorJustReturn: nil)
            }
    }
}
