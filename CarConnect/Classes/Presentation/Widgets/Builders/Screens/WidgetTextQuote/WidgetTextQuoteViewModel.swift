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
    }
    
    private let quote: Driver<WidgetTextQuote>
    private let initialConfiguration: Driver<WidgetTextQuoteConfiguration>
    
    private lazy var storage = WidgetTextStorage()
    
    init(quote: WidgetTextQuote, configuration: WidgetTextQuoteConfiguration) {
        self.quote = BehaviorRelay(value: quote).asDriver()
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
    }
    
    struct Output {
        let defaultConfiguration: Driver<WidgetTextQuoteConfiguration>
        let configuration: Driver<WidgetTextQuoteConfiguration>
        let enableRestoreDefault: Driver<Bool>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        let defaultConfiguration = makeDefaultConfiguration(quote: quote)
        let configuration = makeConfiguration(
            initialConfiguration: initialConfiguration,
            defaultConfiguration: defaultConfiguration,
            didTapResetFont: input.didTapResetFont,
            didSelectFont: input.didSelectFont,
            didTapResetFontColor: input.didTapResetFontColor,
            didSelectFontColor: input.didSelectFontColor,
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
                quote: quote,
                configuration: configuration
            )
        )
    }
}

// MARK: Private
private extension WidgetTextQuoteViewModel {
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
        configuration: Driver<WidgetTextQuoteConfiguration>
    ) -> Driver<Action> {
        let openHelper = didTapHelper
            .map { Action.openHelper }
            .asDriver(onErrorDriveWith: .never())
        
        let openPreview = didTapOpenPreview
            .map { Action.openPreview }
            .asDriver(onErrorDriveWith: .never())
        
        let saveAndClose = didTapSave
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(quote)
            .withLatestFrom(configuration) { ($0, $1) }
            .flatMapLatest { [weak self] quote, configuration -> Driver<Action> in
                guard let self else { return .never() }
                
                return storage
                    .save(quote: quote, configuration: configuration)
                    .asDriver(onErrorDriveWith: .never())
                    .map { _ in Action.close }
            }
        
        return Driver
            .merge(openHelper, openPreview, saveAndClose)
    }
}
