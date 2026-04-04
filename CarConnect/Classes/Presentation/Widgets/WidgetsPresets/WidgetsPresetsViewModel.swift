//
//  WidgetsPresetsViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.02.2026.
//

import RxSwift
import RxCocoa

final class WidgetsPresetsViewModel {
    enum Action {
        case openWidgetsHelper
        case openTextManuallyBuilder(String?, WidgetTextManuallyConfiguration)
        case openTextQuoteBuilder(String?, WidgetTextQuote, WidgetTextQuoteConfiguration)
        case openCalendarBuilder(String?, WidgetCalendarConfiguration)
        case openWeather(String?, WidgetWeatherConfiguration)
        case openClock(String?, WidgetClockConfiguration)
        case openClockAIPreview(String?, WidgetClockAIPreviewConfiguration)
        case openCarLogo(String?, WidgetCarLogoConfiguration)
        case openAIPhoto(String?, WidgetAIPhotoConfiguration?)
        case openPhotoWihText(String?, WidgetPhotoWithTextConfiguration)
        case openPhoto(String?, WidgetPhotoConfiguration?)
    }
    
    private lazy var textService = WidgetTextService()
    private lazy var calendarService = WidgetCalendarService()
    private lazy var weatherService = WidgetWeatherService()
    private lazy var clockService = WidgetClockService()
    private lazy var carLogoService = WidgetCarLogoService()
    private lazy var photoService = WidgetPhotoService()
    
    private lazy var vehicleManager = VehicleManager()
    
    private lazy var weatherFetcher = WeatherFetcher()
}

// MARK: Public
extension WidgetsPresetsViewModel {
    struct Input {
        let didTapHelper: Signal<Void>
        let didTapOpenHelperFromCollection: Signal<Void>
        let didSelectTabItem: Signal<WidgetsPresetsTabView.TabItem>
        let didSelectPresetsType: Signal<WidgetsPresetsType>
        let didSelectElement: Signal<WidgetsPresetsTemplatesCollectionElement>
        let didTapGoToCatalog: Signal<Void>
    }
    
    struct Output {
        let action: Driver<Action>
        let selectedTabItem: Driver<WidgetsPresetsTabView.TabItem>
        let selectedPresetsType: Driver<WidgetsPresetsType>
        let collectionElements: Driver<[WidgetsPresetsTemplatesCollectionElement]>
        let emptyHidden: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        let widgetPreviews = makeWidgetPreviews()
        let logos = makeLogos()
        let selectedTabItem = makeSelectedTabItem(
            didSelectTabItem: input.didSelectTabItem,
            didTapGoToCatalog: input.didTapGoToCatalog
        )
        let selectedPresetsType = input.didSelectPresetsType
            .startWith(.calendar)
            .asDriver(onErrorDriveWith: .never())
            .distinctUntilChanged()
        let collectionElements = makeCollectionElements(
            selectedTabItem: selectedTabItem,
            selectedPresetsType: selectedPresetsType,
            helperCellWasDisplayed: makeHelperCellWasDisplayed(didTapOpenHelperFromCollection: input.didTapOpenHelperFromCollection),
            weatherData: weatherFetcher.weatherData,
            widgetPreviews: widgetPreviews,
            logos: logos
        )
        
        return Output(
            action: makeAction(
                didTapHelper: input.didTapHelper,
                didTapOpenHelperFromCollection: input.didTapOpenHelperFromCollection,
                didSelectElement: input.didSelectElement
            ),
            selectedTabItem: selectedTabItem,
            selectedPresetsType: selectedPresetsType,
            collectionElements: collectionElements,
            emptyHidden: makeEmptyHidden(
                selectedTabItem: selectedTabItem,
                elements: collectionElements
            )
        )
    }
}

// MARK: Private
private extension WidgetsPresetsViewModel {
    enum Constants {
        static let helperCellWasDisplayed = "helpder_cell_was_displayed" 
    }
    
    func makeSelectedTabItem(
        didSelectTabItem: Signal<WidgetsPresetsTabView.TabItem>,
        didTapGoToCatalog: Signal<Void>
    ) -> Driver<WidgetsPresetsTabView.TabItem> {
        let selectTab = didSelectTabItem
            .startWith(.widgets)
            .asDriver(onErrorDriveWith: .never())
        
        let tapCatalogButton = didTapGoToCatalog
            .map { WidgetsPresetsTabView.TabItem.widgets }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(selectTab, tapCatalogButton)
            .distinctUntilChanged()
    }
    
    func makeAction(
        didTapHelper: Signal<Void>,
        didTapOpenHelperFromCollection: Signal<Void>,
        didSelectElement: Signal<WidgetsPresetsTemplatesCollectionElement>
    ) -> Driver<Action> {
        let openWidgetsHelper = Signal
            .merge(didTapHelper, didTapOpenHelperFromCollection)
            .map { Action.openWidgetsHelper }
            .asDriver(onErrorDriveWith: .never())
        
        let openBuilder = didSelectElement
            .asDriver(onErrorDriveWith: .never())
            .compactMap { element -> Action? in
                switch element {
                case .openHelper:
                    return nil 
                case .textManually(let storageModelId, let config):
                    return .openTextManuallyBuilder(storageModelId, config)
                case .quoteAmbitionDrive(let storageModelId, let quote, let config):
                    return .openTextQuoteBuilder(storageModelId, .ambitionDrive(quote), config)
                case .quoteLeadershipImpact(let storageModelId, let quote, let config):
                    return .openTextQuoteBuilder(storageModelId, .leadershipImpact(quote), config)
                case .quoteLifeMeaning(let storageModelId, let quote, let config):
                    return .openTextQuoteBuilder(storageModelId, .lifeMeaning(quote), config)
                case .quoteMindsetGrowth(let storageModelId, let quote, let config):
                    return .openTextQuoteBuilder(storageModelId, .mindsetGrowth(quote), config)
                case .calendar(let storageModelId, let config):
                    return .openCalendarBuilder(storageModelId, config)
                case .weather(let storageModelId, let config, _):
                    return .openWeather(storageModelId, config)
                case .clock(let storageModelId, let config):
                    return .openClock(storageModelId, config)
                case .clockAIPreview(let storageModelId, let config):
                    return .openClockAIPreview(storageModelId, config)
                case .carLogo(let storageModelId, let config, _, _):
                    return .openCarLogo(storageModelId, config)
                case .aiPhoto(let storageModelId, let config):
                    return .openAIPhoto(storageModelId, config)
                case .photoWithText(let storageModelId, let config):
                    return .openPhotoWihText(storageModelId, config)
                case .photo(let storageModelId, let config):
                    return .openPhoto(storageModelId, config)
                }
            }
        
        return Driver
            .merge(openWidgetsHelper, openBuilder)
    }
    
    func makeHelperCellWasDisplayed(didTapOpenHelperFromCollection: Signal<Void>) -> Driver<Bool> {
        let initial = Single
            .deferred {
                let wasDisplayed = UserDefaults.standard.bool(forKey: Constants.helperCellWasDisplayed)
                return .just(wasDisplayed)
            }
            .asDriver(onErrorDriveWith: .never())
        
        let openAction = didTapOpenHelperFromCollection
            .flatMapLatest { void -> Signal<Bool> in
                Signal.deferred {
                    UserDefaults.standard.set(true, forKey: Constants.helperCellWasDisplayed)
                    
                    return .just(true)
                }
            }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(initial, openAction)
    }
    
    func makeEmptyHidden(
        selectedTabItem: Driver<WidgetsPresetsTabView.TabItem>,
        elements: Driver<[WidgetsPresetsTemplatesCollectionElement]>
    ) -> Driver<Bool> {
        Driver
            .combineLatest(selectedTabItem, elements)
            .map { selectedTabItem, elements -> Bool in
                switch selectedTabItem {
                case .widgets:
                    return true
                case .saved:
                    return !elements.isEmpty
                }
            }
            .startWith(true)
    }
    
    func makeCollectionElements(
        selectedTabItem: Driver<WidgetsPresetsTabView.TabItem>,
        selectedPresetsType: Driver<WidgetsPresetsType>,
        helperCellWasDisplayed: Driver<Bool>,
        weatherData: Driver<WeatherData?>,
        widgetPreviews: Driver<[VehicleWidgetPreview]>,
        logos: Driver<VehicleSupportLogosResponse?>
    ) -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
        return Driver
            .combineLatest(selectedTabItem, selectedPresetsType, helperCellWasDisplayed, widgetPreviews, logos)
            .flatMapLatest { [weak self] tabItem, presetsType, helperCellWasDisplayed, widgetPreviews, logos -> Driver<[WidgetsPresetsTemplatesCollectionElement]> in
                guard let self else { return .just([]) }
                
                let saved = tabItem == .saved
                
                let elements: Driver<[WidgetsPresetsTemplatesCollectionElement]> = {
                    switch presetsType {
                    case .all:
                        let textElements = self.makeTextElements(isSaved: saved)
                        let calendarElements = self.makeCalendarElements(isSaved: saved)
                        let weatherElements = self.makeWeatherElements(weatherData: weatherData, isSaved: saved)
                        let clockElements = self.makeClockElements(isSaved: saved, widgetPreviews: widgetPreviews)
                        let carLogoElements = self.makeCarLogoElements(logos: logos, isSaved: saved)
                        let photoElements = self.makePhotoElements(isSaved: saved)
                        
                        return Driver
                            .combineLatest(
                                textElements,
                                calendarElements,
                                weatherElements,
                                clockElements,
                                carLogoElements,
                                photoElements
                            )
                            .map { texts, calendars, weathers, clocks, carLogos, photos -> [WidgetsPresetsTemplatesCollectionElement] in
                                let firstGroup = texts + calendars + weathers
                                let secondGroup = clocks + carLogos + photos
                                return firstGroup + secondGroup
                            }
                    case .calendar:
                        return self.makeCalendarElements(isSaved: saved)
                    case .clock:
                        return self.makeClockElements(isSaved: saved, widgetPreviews: widgetPreviews)
                    case .carLogo:
                        return self.makeCarLogoElements(logos: logos, isSaved: saved)
                    case .text:
                        return self.makeTextElements(isSaved: saved)
                    case .photo:
                        return self.makePhotoElements(isSaved: saved)
                    case .weather:
                        return self.makeWeatherElements(weatherData: weatherData, isSaved: saved)
                    }
                }()
                
                return elements
                    .map { elements -> [WidgetsPresetsTemplatesCollectionElement] in
                        guard saved, !elements.isEmpty, !helperCellWasDisplayed else { return elements }
                        
                        var result = elements
                        let insertIndex = elements.count == 1 ? 1 : 2
                        result.insert(.openHelper, at: min(insertIndex, elements.count))
                        
                        return result
                    }
            }
    }
    
    func makeWidgetPreviews() -> Driver<[VehicleWidgetPreview]> {
        vehicleManager
            .fetchWidgetPreviews()
            .asDriver(onErrorJustReturn: [])
            .startWith([])
    }
    
    func makeLogos() -> Driver<VehicleSupportLogosResponse?> {
        vehicleManager
            .fetchVehicleSupportLogos()
            .asDriver(onErrorJustReturn: nil)
            .startWith(nil)
    }
}

// MARK: make text elements
private extension WidgetsPresetsViewModel {
    func makeTextElements(isSaved: Bool) -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
        func savedManually() -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
            enum Action {
                case initial([WidgetTextManuallyStorageModel])
                case added(WidgetTextManuallyStorageModel)
                case edited(WidgetTextManuallyStorageModel)
                case deleted(String)
            }
            
            let initial = textService
                .fetchManuallyConfigurations()
                .map { Action.initial($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let added = WidgetTextServiceMediator.shared
                .didSavedManuallyConfiguration
                .map { Action.added($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let edited = WidgetTextServiceMediator.shared
                .didEditedManuallyConfiguration
                .map { Action.edited($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let deleted = WidgetTextServiceMediator.shared
                .didDeletedManuallyConfigurationId
                .map { Action.deleted($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let action = Driver
                .merge(initial, added, edited, deleted)
            
            let models = action
                .scan([]) { models, action -> [WidgetTextManuallyStorageModel] in
                    switch action {
                    case .initial(let models):
                        return models
                    case .added(let model):
                        var result = models
                        result.append(model)
                        return result
                    case .edited(let model):
                        var result = models
                        if let index = result.firstIndex(where: { $0.id == model.id }) {
                            result[index] = model
                        }
                        return result
                    case .deleted(let id):
                        var result = models
                        result.removeAll(where: { $0.id == id })
                        return result
                    }
                }
            
            return models
                .map { models -> [WidgetsPresetsTemplatesCollectionElement] in
                    models.map { .textManually($0.id, $0.configuration) }
                }
        }
        
        func savedQuotes() -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
            enum Action {
                case initial([WidgetTextQuoteStorageModel])
                case added(WidgetTextQuoteStorageModel)
                case edited(WidgetTextQuoteStorageModel)
                case deleted(String)
            }
            
            let initial = textService
                .fetchQuotes()
                .map { Action.initial($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let added = WidgetTextServiceMediator.shared
                .didSavedQuoteModel
                .map { Action.added($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let edited = WidgetTextServiceMediator.shared
                .didEditedQuoteModel
                .map { Action.edited($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let deleted = WidgetTextServiceMediator.shared
                .didDeletedQuoteModelId
                .map { Action.deleted($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let action = Driver
                .merge(initial, added, edited, deleted)
            
            let models = action
                .scan([]) { models, action -> [WidgetTextQuoteStorageModel] in
                    switch action {
                    case .initial(let models):
                        return models
                    case .added(let model):
                        var result = models
                        result.append(model)
                        return result
                    case .edited(let model):
                        var result = models
                        if let index = result.firstIndex(where: { $0.id == model.id }) {
                            result[index] = model
                        }
                        return result
                    case .deleted(let id):
                        var result = models
                        result.removeAll(where: { $0.id == id })
                        return result
                    }
                }
            
            return models
                .map { models -> [WidgetsPresetsTemplatesCollectionElement] in
                    models.map { model -> WidgetsPresetsTemplatesCollectionElement in
                        switch model.quote {
                        case .ambitionDrive(let quote):
                            return .quoteAmbitionDrive(model.id, quote, model.configuration)
                        case .mindsetGrowth(let quote):
                            return .quoteMindsetGrowth(model.id, quote, model.configuration)
                        case .leadershipImpact(let quote):
                            return .quoteLeadershipImpact(model.id, quote, model.configuration)
                        case .lifeMeaning(let quote):
                            return .quoteLifeMeaning(model.id, quote, model.configuration)
                        }
                    }
                }
        }
        
        func saved() -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
            Driver
                .combineLatest(
                    savedManually(), savedQuotes()
                )
                .map { manually, quotes -> [WidgetsPresetsTemplatesCollectionElement] in
                    manually + quotes
                }
        }
        
        func templates() -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
            Single
                .deferred {
                    let templates = [
                        WidgetsPresetsTemplatesCollectionElement.textManually(nil, WidgetTextManuallyConfiguration.default()),
                        {
                            guard let template = WidgetTextQuoteMindsetGrowth.templates().first else { return nil }
                            return .quoteMindsetGrowth(nil, template, WidgetTextQuoteConfiguration.mindsetGrowthDefault())
                        }(),
                        {
                            guard let template = WidgetTextQuoteAmbitionDrive.templates().first else { return nil }
                            return .quoteAmbitionDrive(nil, template, WidgetTextQuoteConfiguration.ambitionDriveDefault())
                        }(),
                        {
                            guard let template = WidgetTextQuoteLeadershipImpact.templates().first else { return nil }
                            return .quoteLeadershipImpact(nil, template, WidgetTextQuoteConfiguration.leadershipImpactDefault())
                        }(),
                        {
                            guard let template = WidgetTextQuoteLifeMeaning.templates().first else { return nil }
                            return .quoteLifeMeaning(nil, template, WidgetTextQuoteConfiguration.lifeMeaningDefault())
                        }()
                    ].compactMap { $0 }
                    
                    return .just(templates)
                }
                .asDriver(onErrorDriveWith: .never())
        }
        
        return isSaved ? saved() : templates()
    }
}

// MARK: make calendar elements
private extension WidgetsPresetsViewModel {
    func makeCalendarElements(isSaved: Bool) -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
        func saved() -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
            enum Action {
                case initial([WidgetCalendarStorageModel])
                case added(WidgetCalendarStorageModel)
                case edited(WidgetCalendarStorageModel)
                case deleted(String)
            }
            
            let initial = calendarService
                .fetchConfigurations()
                .map { Action.initial($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let added = WidgetCalendarMediator.shared
                .didSavedCalendarModel
                .map { Action.added($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let edited = WidgetCalendarMediator.shared
                .didEditedCalendarModel
                .map { Action.edited($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let deleted = WidgetCalendarMediator.shared
                .didDeletedCalendarModelId
                .map { Action.deleted($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let action = Driver
                .merge(initial, added, edited, deleted)
            
            let models = action
                .scan([]) { models, action -> [WidgetCalendarStorageModel] in
                    switch action {
                    case .initial(let models):
                        return models
                    case .added(let model):
                        var result = models
                        result.append(model)
                        return result
                    case .edited(let model):
                        var result = models
                        if let index = result.firstIndex(where: { $0.id == model.id }) {
                            result[index] = model
                        }
                        return result
                    case .deleted(let id):
                        var result = models
                        result.removeAll(where: { $0.id == id })
                        return result
                    }
                }
            
            return models
                .map { models -> [WidgetsPresetsTemplatesCollectionElement] in
                    models.map { .calendar($0.id, $0.configuration) }
                }
        }
        
        func templates() -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
            Single
                .deferred {
                    let templates = [
                        WidgetCalendarConfiguration.default(for: .monthGrid),
                        WidgetCalendarConfiguration.default(for: .weekdayAndDayNumberLarge),
                        WidgetCalendarConfiguration.default(for: .dayNumberWithMonthGrid),
                        WidgetCalendarConfiguration.default(for: .monthAbbrevAndDayNumberLarge),
                        WidgetCalendarConfiguration.default(for: .monthDayAndWeekdayText),
                        WidgetCalendarConfiguration.default(for: .stackedMonthDayWeekday)
                    ]
                    
                    let elements = templates.map { WidgetsPresetsTemplatesCollectionElement.calendar(nil, $0) }
                    
                    return .just(elements)
                }
                .asDriver(onErrorJustReturn: [])
        }
        
        return isSaved ? saved() : templates()
    }
}

// MARK: make weather elements
private extension WidgetsPresetsViewModel {
    func makeWeatherElements(weatherData: Driver<WeatherData?>, isSaved: Bool) -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
        let resolvedWeatherData = weatherData.compactMap { $0 }
        
        func saved() -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
            enum Action {
                case initial([WidgetWeatherStorageModel])
                case added(WidgetWeatherStorageModel)
                case edited(WidgetWeatherStorageModel)
                case deleted(String)
            }
            
            let initial = weatherService
                .fetchConfigurations()
                .map { Action.initial($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let added = WidgetWeatherMediator.shared
                .didSavedWeatherModel
                .map { Action.added($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let edited = WidgetWeatherMediator.shared
                .didEditedWeatherModel
                .map { Action.edited($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let deleted = WidgetWeatherMediator.shared
                .didDeletedWeatherModelId
                .map { Action.deleted($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let action = Driver
                .merge(initial, added, edited, deleted)
            
            let models = action
                .scan([]) { models, action -> [WidgetWeatherStorageModel] in
                    switch action {
                    case .initial(let models):
                        return models
                    case .added(let model):
                        var result = models
                        result.append(model)
                        return result
                    case .edited(let model):
                        var result = models
                        if let index = result.firstIndex(where: { $0.id == model.id }) {
                            result[index] = model
                        }
                        return result
                    case .deleted(let id):
                        var result = models
                        result.removeAll(where: { $0.id == id })
                        return result
                    }
                }
            
            return Driver
                .combineLatest(models, resolvedWeatherData)
                .map { models, weatherData -> [WidgetsPresetsTemplatesCollectionElement] in
                    models.map { .weather($0.id, $0.configuration, weatherData) }
                }
                .startWith([])
        }
        
        func templates() -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
            let templates = [
                WidgetWeatherConfiguration.default(for: .weatherIconTemperature),
                WidgetWeatherConfiguration.default(for: .currentWeatherSummary),
                WidgetWeatherConfiguration.default(for: .locationTemperature),
                WidgetWeatherConfiguration.default(for: .compactWeatherForecast),
                WidgetWeatherConfiguration.default(for: .todayTomorrowWeather),
                WidgetWeatherConfiguration.default(for: .weatherClock),
                WidgetWeatherConfiguration.default(for: .weatherConditionForecast),
                WidgetWeatherConfiguration.default(for: .digitalWeatherClock)
            ]
            
            return resolvedWeatherData
                .map { weatherData -> [WidgetsPresetsTemplatesCollectionElement] in
                    templates.map { WidgetsPresetsTemplatesCollectionElement.weather(nil, $0, weatherData) }
                }
                .startWith([])
        }
        
        return isSaved ? saved() : templates()
    }
}

// MARK: make clock elements
private extension WidgetsPresetsViewModel {
    func makeClockElements(isSaved: Bool, widgetPreviews: [VehicleWidgetPreview]) -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
        func savedClocks() -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
            enum Action {
                case initial([WidgetClockStorageModel])
                case added(WidgetClockStorageModel)
                case edited(WidgetClockStorageModel)
                case deleted(String)
            }
            
            let initial = clockService
                .fetchConfigurations()
                .map { Action.initial($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let added = WidgetClockMediator.shared
                .didSavedClockModel
                .map { Action.added($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let edited = WidgetClockMediator.shared
                .didEditedClockModel
                .map { Action.edited($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let deleted = WidgetClockMediator.shared
                .didDeletedClockModelId
                .map { Action.deleted($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let action = Driver
                .merge(initial, added, edited, deleted)
            
            let models = action
                .scan([]) { models, action -> [WidgetClockStorageModel] in
                    switch action {
                    case .initial(let models):
                        return models
                    case .added(let model):
                        var result = models
                        result.append(model)
                        return result
                    case .edited(let model):
                        var result = models
                        if let index = result.firstIndex(where: { $0.id == model.id }) {
                            result[index] = model
                        }
                        return result
                    case .deleted(let id):
                        var result = models
                        result.removeAll(where: { $0.id == id })
                        return result
                    }
                }
            
            return models
                .map { models -> [WidgetsPresetsTemplatesCollectionElement] in
                    models.map { .clock($0.id, $0.configuration) }
                }
        }
        
        func savedAIPreviews() -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
            enum Action {
                case initial([WidgetClockAIPreviewStorageModel])
                case added(WidgetClockAIPreviewStorageModel)
                case edited(WidgetClockAIPreviewStorageModel)
                case deleted(String)
            }
            
            let initial = clockService
                .fetchAIPreviewConfigurations()
                .map { Action.initial($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let added = WidgetClockMediator.shared
                .didSavedClockAIPreviewModel
                .map { Action.added($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let edited = WidgetClockMediator.shared
                .didEditedClockAIPreviewModel
                .map { Action.edited($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let deleted = WidgetClockMediator.shared
                .didDeletedClockAIPreviewModelId
                .map { Action.deleted($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let action = Driver
                .merge(initial, added, edited, deleted)
            
            let models = action
                .scan([]) { models, action -> [WidgetClockAIPreviewStorageModel] in
                    switch action {
                    case .initial(let models):
                        return models
                    case .added(let model):
                        var result = models
                        result.append(model)
                        return result
                    case .edited(let model):
                        var result = models
                        if let index = result.firstIndex(where: { $0.id == model.id }) {
                            result[index] = model
                        }
                        return result
                    case .deleted(let id):
                        var result = models
                        result.removeAll(where: { $0.id == id })
                        return result
                    }
                }
            
            return models
                .map { models -> [WidgetsPresetsTemplatesCollectionElement] in
                    models.map { .clockAIPreview($0.id, $0.configuration) }
                }
        }
        
        func saved() -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
            Driver
                .combineLatest(
                    savedAIPreviews(), savedClocks()
                )
                .map { aiPreviews, clocks -> [WidgetsPresetsTemplatesCollectionElement] in
                    aiPreviews + clocks
                }
        }
        
        func templates() -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
            Single
                .deferred {
                    let aiPreviews = widgetPreviews
                        .compactMap { preview -> WidgetsPresetsTemplatesCollectionElement? in
                            guard let url = preview.gallery.first else { return nil }
                            
                            let configuration = WidgetClockAIPreviewConfiguration.default(url: url)
                            return WidgetsPresetsTemplatesCollectionElement.clockAIPreview(nil, configuration)
                        }
                    
                    let templates = [
                        WidgetClockConfiguration.default(for: .digitalStacked),
                        WidgetClockConfiguration.default(for: .digitalMirror),
                        WidgetClockConfiguration.default(for: .digitalClassic),
                        WidgetClockConfiguration.default(for: .splitFlap),
                        WidgetClockConfiguration.default(for: .calendarClock),
                        WidgetClockConfiguration.default(for: .analogClock)
                    ]
                    
                    let elements = aiPreviews + templates.map { WidgetsPresetsTemplatesCollectionElement.clock(nil, $0) }
                    
                    return .just(elements)
                }
                .asDriver(onErrorJustReturn: [])
        }
        
        return isSaved ? saved() : templates()
    }
}

// MARK: make carLogo elements
private extension WidgetsPresetsViewModel {
    func makeCarLogoElements(logos: VehicleSupportLogosResponse?, isSaved: Bool) -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
        func saved() -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
            enum Action {
                case initial([WidgetCarLogoStorageModel])
                case added(WidgetCarLogoStorageModel)
                case edited(WidgetCarLogoStorageModel)
                case deleted(String)
            }
            
            let initial = carLogoService
                .fetchConfigurations()
                .map { Action.initial($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let added = WidgetCarLogoMediator.shared
                .didSavedCarLogoModel
                .map { Action.added($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let edited = WidgetCarLogoMediator.shared
                .didEditedCarLogoModel
                .map { Action.edited($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let deleted = WidgetCarLogoMediator.shared
                .didDeletedCarLogoModelId
                .map { Action.deleted($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let action = Driver
                .merge(initial, added, edited, deleted)
            
            let models = action
                .scan([]) { models, action -> [WidgetCarLogoStorageModel] in
                    switch action {
                    case .initial(let models):
                        return models
                    case .added(let model):
                        var result = models
                        result.append(model)
                        return result
                    case .edited(let model):
                        var result = models
                        if let index = result.firstIndex(where: { $0.id == model.id }) {
                            result[index] = model
                        }
                        return result
                    case .deleted(let id):
                        var result = models
                        result.removeAll(where: { $0.id == id })
                        return result
                    }
                }
            
            return models
                .map { models -> [WidgetsPresetsTemplatesCollectionElement] in
                    models.map { .carLogo($0.id, $0.configuration, false, nil) }
                }
        }
        
        func templates() -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
            Single
                .deferred {
                    guard let logos else { return .just([]) }
                    
                    let usersBrands = logos.userBrands.map { brand -> WidgetsPresetsTemplatesCollectionElement in
                        let mappedBrand = WidgetCarLogoBrand( logo: brand.logo, model: brand.model)
                        let configuration = WidgetCarLogoConfiguration.default(brand: mappedBrand)
                        return WidgetsPresetsTemplatesCollectionElement.carLogo(nil, configuration, true, nil)
                    }
                    
                    let catalogsCount = logos.catalogBrands.count
                    let catalogsBrands: [WidgetsPresetsTemplatesCollectionElement] = {
                        guard let brand = logos.catalogBrands.first else { return [] }
                        
                        let mappedBrand = WidgetCarLogoBrand( logo: brand.logo, model: brand.model)
                        let configuration = WidgetCarLogoConfiguration.default(brand: mappedBrand)
                        let element = WidgetsPresetsTemplatesCollectionElement.carLogo(nil, configuration, false, catalogsCount)
                        return [element]
                    }()
                       
                    let elements = usersBrands + catalogsBrands
                    
                    return .just(elements)
                }
                .asDriver(onErrorJustReturn: [])
        }
        
        return isSaved ? saved() : templates()
    }
}

// MARK: make photo elements
private extension WidgetsPresetsViewModel {
    func makePhotoElements(isSaved: Bool) -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
        func savedAIPhotos() -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
            enum Action {
                case initial([WidgetAIPhotoStorageModel])
                case added(WidgetAIPhotoStorageModel)
                case edited(WidgetAIPhotoStorageModel)
                case deleted(String)
            }
            
            let initial = photoService
                .fetchAIPhotoConfigurations()
                .map { Action.initial($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let added = WidgetPhotoMediator.shared
                .didSavedAIPhotoModel
                .map { Action.added($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let edited = WidgetPhotoMediator.shared
                .didEditedAIPhotoModel
                .map { Action.edited($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let deleted = WidgetPhotoMediator.shared
                .didDeletedAIPhotoModelId
                .map { Action.deleted($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let action = Driver
                .merge(initial, added, edited, deleted)
            
            let models = action
                .scan([]) { models, action -> [WidgetAIPhotoStorageModel] in
                    switch action {
                    case .initial(let models):
                        return models
                    case .added(let model):
                        var result = models
                        result.append(model)
                        return result
                    case .edited(let model):
                        var result = models
                        if let index = result.firstIndex(where: { $0.id == model.id }) {
                            result[index] = model
                        }
                        return result
                    case .deleted(let id):
                        var result = models
                        result.removeAll(where: { $0.id == id })
                        return result
                    }
                }
            
            return models
                .map { models -> [WidgetsPresetsTemplatesCollectionElement] in
                    models.map { .aiPhoto($0.id, $0.configuration) }
                }
        }
        
        func savedPhotosWithText() -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
            enum Action {
                case initial([WidgetPhotoWithTextStorageModel])
                case added(WidgetPhotoWithTextStorageModel)
                case edited(WidgetPhotoWithTextStorageModel)
                case deleted(String)
            }
            
            let initial = photoService
                .fetchPhotoWithTextConfigurations()
                .map { Action.initial($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let added = WidgetPhotoMediator.shared
                .didSavedPhotoWithTextModel
                .map { Action.added($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let edited = WidgetPhotoMediator.shared
                .didEditedPhotoWithTextModel
                .map { Action.edited($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let deleted = WidgetPhotoMediator.shared
                .didDeletedPhotoWithTextModelId
                .map { Action.deleted($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let action = Driver
                .merge(initial, added, edited, deleted)
            
            let models = action
                .scan([]) { models, action -> [WidgetPhotoWithTextStorageModel] in
                    switch action {
                    case .initial(let models):
                        return models
                    case .added(let model):
                        var result = models
                        result.append(model)
                        return result
                    case .edited(let model):
                        var result = models
                        if let index = result.firstIndex(where: { $0.id == model.id }) {
                            result[index] = model
                        }
                        return result
                    case .deleted(let id):
                        var result = models
                        result.removeAll(where: { $0.id == id })
                        return result
                    }
                }
            
            return models
                .map { models -> [WidgetsPresetsTemplatesCollectionElement] in
                    models.map { .photoWithText($0.id, $0.configuration) }
                }
        }
        
        func savedPhotos() -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
            enum Action {
                case initial([WidgetPhotoStorageModel])
                case added(WidgetPhotoStorageModel)
                case edited(WidgetPhotoStorageModel)
                case deleted(String)
            }
            
            let initial = photoService
                .fetchPhotoConfigurations()
                .map { Action.initial($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let added = WidgetPhotoMediator.shared
                .didSavedPhotoModel
                .map { Action.added($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let edited = WidgetPhotoMediator.shared
                .didEditedPhotoModel
                .map { Action.edited($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let deleted = WidgetPhotoMediator.shared
                .didDeletedPhotoModelId
                .map { Action.deleted($0) }
                .asDriver(onErrorDriveWith: .never())
            
            let action = Driver
                .merge(initial, added, edited, deleted)
            
            let models = action
                .scan([]) { models, action -> [WidgetPhotoStorageModel] in
                    switch action {
                    case .initial(let models):
                        return models
                    case .added(let model):
                        var result = models
                        result.append(model)
                        return result
                    case .edited(let model):
                        var result = models
                        if let index = result.firstIndex(where: { $0.id == model.id }) {
                            result[index] = model
                        }
                        return result
                    case .deleted(let id):
                        var result = models
                        result.removeAll(where: { $0.id == id })
                        return result
                    }
                }
            
            return models
                .map { models -> [WidgetsPresetsTemplatesCollectionElement] in
                    models.map { .photo($0.id, $0.configuration) }
                }
        }
        
        func saved() -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
            Driver
                .combineLatest(
                    savedAIPhotos(), savedPhotosWithText(), savedPhotos()
                )
                .map { ai, withText, photos -> [WidgetsPresetsTemplatesCollectionElement] in
                    ai + withText + photos
                }
        }
        
        func templates() -> Driver<[WidgetsPresetsTemplatesCollectionElement]> {
            Single
                .deferred {
                    let aiPhoto = WidgetsPresetsTemplatesCollectionElement.aiPhoto(nil, nil)
                    let uploadPhoto = WidgetsPresetsTemplatesCollectionElement.photo(nil, nil)
                    let photoWithText = WidgetsPresetsTemplatesCollectionElement.photoWithText(nil, WidgetPhotoWithTextConfiguration.default())
                    let defaultPhoto = WidgetsPresetsTemplatesCollectionElement.photo(nil, WidgetPhotoConfiguration.default())
                       
                    let elements = [aiPhoto, uploadPhoto, photoWithText, defaultPhoto]
                    
                    return .just(elements)
                }
                .asDriver(onErrorJustReturn: [])
        }
        
        return isSaved ? saved() : templates()
    }
}
