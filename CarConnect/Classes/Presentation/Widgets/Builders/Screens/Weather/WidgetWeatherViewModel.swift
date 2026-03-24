//
//  WidgetWeatherViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 21.03.2026.
//

import RxSwift
import RxCocoa

final class WidgetWeatherViewModel {
    enum Action {
        case openHelper
        case openPreview
        case close
        case requestRemoveConfirmation
        case enterName(String)
    }
    
    private let storageModelId: Driver<String?>
    private let initialConfiguration: Driver<WidgetWeatherConfiguration>
    
    private lazy var service = WidgetWeatherService()
    
    private var weatherFetcher: WeatherFetcher?
    
    init(storageModelId: String?, configuration: WidgetWeatherConfiguration) {
        self.storageModelId = BehaviorRelay(value: storageModelId).asDriver()
        self.initialConfiguration = BehaviorRelay(value: configuration).asDriver()
    }
}

// MARK: Public
extension WidgetWeatherViewModel {
    struct Input {
        let didTapHelper: Signal<Void>
        let didSelectConfigurationTabItem: Signal<WidgetBuilderConfigurationTabItemButton.Item>
        let didTapResetFont: Signal<Void>
        let didSelectFont: Signal<WidgetsFonts>
        let didTapResetFontColor: Signal<Void>
        let didSelectFontColor: Signal<UIColor>
        let didEnableChangedTwentyFourHour: Signal<Bool>
        let didSelectLocation: Signal<Location>
        let didSelectTemperatureType: Signal<TemperatureType>
        let didTapRestoreDefault: Signal<Void>
        let didTapOpenPreview: Signal<Void>
        let didTapSave: Signal<Void>
        let didTapRemove: Signal<Void>
        let didRemoveConfirmed: Signal<Void>
        let didEnterName: Signal<String>
    }
    
    struct Output {
        let defaultConfiguration: Driver<WidgetWeatherConfiguration>
        let configuration: Driver<WidgetWeatherConfiguration>
        let enableRestoreDefault: Driver<Bool>
        let action: Driver<Action>
        let configurationTabItem: Driver<WidgetBuilderConfigurationTabItemButton.Item>
        let weatherData: Driver<WeatherData>
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
            didSelectLocation: input.didSelectLocation,
            didSelectTemperatureType: input.didSelectTemperatureType,
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
            weatherData: makeWeatherData(
                initialConfiguration: initialConfiguration,
                didSelectLocation: input.didSelectLocation
            )
        )
    }
}

// MARK: Private
extension WidgetWeatherViewModel {
    func makeWeatherData(
        initialConfiguration: Driver<WidgetWeatherConfiguration>,
        didSelectLocation: Signal<Location>
    ) -> Driver<WeatherData> {
        let initial = initialConfiguration
            .flatMapLatest { [weak self] configuration -> Driver<WeatherData> in
                guard let self else { return .never() }
                
                let fetcher = configuration.location.isDefault ? WeatherFetcher() : WeatherFetcher(location: configuration.location)
                self.weatherFetcher = fetcher
                
                return fetcher.weatherData
                    .compactMap { $0 }
            }
        
        let changed = didSelectLocation
            .flatMapLatest { [weak self] location -> Driver<WeatherData> in
                guard let self else { return .never() }
                
                let fetcher = WeatherFetcher(location: location)
                self.weatherFetcher = fetcher
                
                return fetcher.weatherData
                    .compactMap { $0 }
            }
        
        return Driver
            .merge(initial, changed)
    }
    
    func makeConfigurationTabItem(didSelectConfigurationTabItem: Signal<WidgetBuilderConfigurationTabItemButton.Item>) -> Driver<WidgetBuilderConfigurationTabItemButton.Item> {
        didSelectConfigurationTabItem
            .asDriver(onErrorDriveWith: .never())
            .startWith(.visualEditor)
    }
    
    func makeEnableRestoreDefault(
        defaultConfiguration: Driver<WidgetWeatherConfiguration>,
        configuration: Driver<WidgetWeatherConfiguration>
    ) -> Driver<Bool> {
        Driver
            .combineLatest(defaultConfiguration, configuration)
            .map { defaultConfiguration, configuration -> Bool in
                let isEqualFont = defaultConfiguration.font == configuration.font
                let isEqualFontColor = defaultConfiguration.textColor.isEqualTo(configuration.textColor)
                let isEqualTimeFormat = defaultConfiguration.timeFormat == configuration.timeFormat
                let isEqualTemperatureType = defaultConfiguration.temperatureType == configuration.temperatureType
                return !(isEqualFont && isEqualFontColor && isEqualTimeFormat && isEqualTemperatureType)
            }
    }
    
    func makeConfiguration(
        initialConfiguration: Driver<WidgetWeatherConfiguration>,
        defaultConfiguration: Driver<WidgetWeatherConfiguration>,
        didTapResetFont: Signal<Void>,
        didSelectFont: Signal<WidgetsFonts>,
        didTapResetFontColor: Signal<Void>,
        didSelectFontColor: Signal<UIColor>,
        didEnableChangedTwentyFourHour: Signal<Bool>,
        didSelectLocation: Signal<Location>,
        didSelectTemperatureType: Signal<TemperatureType>,
        didTapRestoreDefault: Signal<Void>
    ) -> Driver<WidgetWeatherConfiguration> {
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
        
        let location = Driver<Location>
            .merge(
                initialConfiguration.map { $0.location },
                
                didSelectLocation
                    .asDriver(onErrorDriveWith: .never())
            )
        
        let temperatureType = Driver<TemperatureType>
            .merge(
                initialConfiguration.map { $0.temperatureType },
                
                didSelectTemperatureType
                    .asDriver(onErrorDriveWith: .never()),
                
                didTapRestoreDefault
                    .withLatestFrom(defaultConfiguration)
                    .map { $0.temperatureType }
                    .asDriver(onErrorDriveWith: .never())
            )
        
        let changedConfiguration = Driver
            .combineLatest(style, font, fontColor, timeFormat, location, temperatureType)
            .map { style, font, fontColor, timeFormat, location, temperatureType -> WidgetWeatherConfiguration in
                WidgetWeatherConfiguration(
                    style: style,
                    font: font,
                    textColor: fontColor,
                    timeFormat: timeFormat,
                    location: location,
                    temperatureType: temperatureType
                )
            }
        
        return Driver
            .merge(initialConfiguration, changedConfiguration)
    }
    
    func makeDefaultConfiguration(initialConfiguration: Driver<WidgetWeatherConfiguration>) -> Driver<WidgetWeatherConfiguration> {
        initialConfiguration
            .map { WidgetWeatherConfiguration.default(for: $0.style) }
    }
    
    func makeAction(
        didTapHelper: Signal<Void>,
        didTapOpenPreview: Signal<Void>,
        didTapSave: Signal<Void>,
        configuration: Driver<WidgetWeatherConfiguration>,
        didTapRemove: Signal<Void>,
        didRemoveConfirmed: Signal<Void>,
        storageModelId: Driver<String?>,
        didEnterName: Signal<String>,
        storageModel: Driver<WidgetWeatherStorageModel?>
    ) -> Driver<Action> {
        let openHelper = didTapHelper
            .map { Action.openHelper }
            .asDriver(onErrorDriveWith: .never())
        
        let openPreview = didTapOpenPreview
            .map { Action.openPreview }
            .asDriver(onErrorDriveWith: .never())
        
        let enterName = didTapSave
            .withLatestFrom(storageModel)
            .map { Action.enterName($0?.name ?? "Weather") }
            .asDriver(onErrorDriveWith: .never())
        
        let saveAndClose = didEnterName
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(storageModelId) { ($0, $1) }
            .withLatestFrom(configuration) { ($0.0, $0.1, $1) }
            .flatMapLatest { name, id, configuration -> Driver<Action> in
                let model: Single<WidgetWeatherStorageModel> = { [weak self] in
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
    
    func makeStorageModel(id: Driver<String?>) -> Driver<WidgetWeatherStorageModel?> {
        id
            .flatMapLatest { [weak self] id -> Driver<WidgetWeatherStorageModel?> in
                guard let self, let id else {
                    return .just(nil)
                }
                
                return service
                    .fetchConfigurations()
                    .map { configs -> WidgetWeatherStorageModel? in
                        configs.first(where: { $0.id == id })
                    }
                    .asDriver(onErrorJustReturn: nil)
            }
    }
}
