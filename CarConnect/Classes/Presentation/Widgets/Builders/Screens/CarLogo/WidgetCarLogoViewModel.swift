//
//  WidgetCarLogoViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 02.04.2026.
//

import RxSwift
import RxCocoa

final class WidgetCarLogoViewModel {
    enum Action {
        case openHelper
        case openPreview
        case close
        case requestRemoveConfirmation
        case enterName(String)
    }
    
    private let storageModelId: Driver<String?>
    private let initialConfiguration: Driver<WidgetCarLogoConfiguration>
    
    private lazy var service = WidgetCarLogoService()
    
    private lazy var vehicleManager = VehicleManager()
    
    init(storageModelId: String?, configuration: WidgetCarLogoConfiguration) {
        self.storageModelId = BehaviorRelay(value: storageModelId).asDriver()
        self.initialConfiguration = BehaviorRelay(value: configuration).asDriver()
    }
}

// MARK: Public
extension WidgetCarLogoViewModel {
    struct Input {
        let didTapHelper: Signal<Void>
        let didTapRestoreDefault: Signal<Void>
        let didTapOpenPreview: Signal<Void>
        let didTapSave: Signal<Void>
        let didTapRemove: Signal<Void>
        let didSelectBrand: Signal<WidgetCarLogoBrand>
        let didRemoveConfirmed: Signal<Void>
        let didTapResetBackground: Signal<Void>
        let didSelectBackground: Signal<WidgetBackground>
        let didEnterName: Signal<String>
    }
    
    struct Output {
        let defaultConfiguration: Driver<WidgetCarLogoConfiguration>
        let configuration: Driver<WidgetCarLogoConfiguration>
        let enableRestoreDefault: Driver<Bool>
        let action: Driver<Action>
        let brands: Driver<[WidgetCarLogoBrand]>
    }
    
    func configure(input: Input) -> Output {
        let storageModel = makeStorageModel(id: storageModelId)
        let defaultConfiguration = makeDefaultConfiguration(initialConfiguration: initialConfiguration)
        let configuration = makeConfiguration(
            initialConfiguration: initialConfiguration,
            defaultConfiguration: defaultConfiguration,
            didTapRestoreDefault: input.didTapRestoreDefault,
            didSelectBrand: input.didSelectBrand,
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
            ),
            brands: makeBrands()
        )
    }
}

// MARK: Private
extension WidgetCarLogoViewModel {
    func makeEnableRestoreDefault(
        defaultConfiguration: Driver<WidgetCarLogoConfiguration>,
        configuration: Driver<WidgetCarLogoConfiguration>
    ) -> Driver<Bool> {
        Driver
            .combineLatest(defaultConfiguration, configuration)
            .map { defaultConfiguration, configuration -> Bool in
                !defaultConfiguration.background.isEqual(another: configuration.background)
            }
    }
    
    func makeConfiguration(
        initialConfiguration: Driver<WidgetCarLogoConfiguration>,
        defaultConfiguration: Driver<WidgetCarLogoConfiguration>,
        didTapRestoreDefault: Signal<Void>,
        didSelectBrand: Signal<WidgetCarLogoBrand>,
        didTapResetBackground: Signal<Void>,
        didSelectBackground: Signal<WidgetBackground>
    ) -> Driver<WidgetCarLogoConfiguration> {
        let brand = Driver<WidgetCarLogoBrand>
            .merge(
                initialConfiguration
                    .map { $0.brand },
                
                didSelectBrand
                    .asDriver(onErrorDriveWith: .never())
            )
        
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
        
        let changedConfiguration = Driver
            .combineLatest(brand, background)
            .map { brand, background -> WidgetCarLogoConfiguration in
                WidgetCarLogoConfiguration(
                    brand: brand,
                    background: background
                )
            }
        
        return Driver
            .merge(initialConfiguration, changedConfiguration)
    }
    
    func makeDefaultConfiguration(initialConfiguration: Driver<WidgetCarLogoConfiguration>) -> Driver<WidgetCarLogoConfiguration> {
        initialConfiguration
            .map { WidgetCarLogoConfiguration.default(brand: $0.brand) }
    }
    
    func makeAction(
        didTapHelper: Signal<Void>,
        didTapOpenPreview: Signal<Void>,
        didTapSave: Signal<Void>,
        configuration: Driver<WidgetCarLogoConfiguration>,
        didTapRemove: Signal<Void>,
        didRemoveConfirmed: Signal<Void>,
        storageModelId: Driver<String?>,
        didEnterName: Signal<String>,
        storageModel: Driver<WidgetCarLogoStorageModel?>
    ) -> Driver<Action> {
        let openHelper = didTapHelper
            .map { Action.openHelper }
            .asDriver(onErrorDriveWith: .never())
        
        let openPreview = didTapOpenPreview
            .map { Action.openPreview }
            .asDriver(onErrorDriveWith: .never())
        
        let enterName = didTapSave
            .withLatestFrom(storageModel)
            .map { Action.enterName($0?.name ?? "Car Logo") }
            .asDriver(onErrorDriveWith: .never())
        
        let saveAndClose = didEnterName
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(storageModelId) { ($0, $1) }
            .withLatestFrom(configuration) { ($0.0, $0.1, $1) }
            .flatMapLatest { name, id, configuration -> Signal<(String?, String, WidgetCarLogoConfiguration)> in
                Observable<(String?, String, WidgetCarLogoConfiguration)>
                    .create { observer in
                        guard SharedImageFileStore.shared.save(url: configuration.brand.logo) != nil else {
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
                let model: Single<WidgetCarLogoStorageModel> = { [weak self] in
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
    
    func makeStorageModel(id: Driver<String?>) -> Driver<WidgetCarLogoStorageModel?> {
        id
            .flatMapLatest { [weak self] id -> Driver<WidgetCarLogoStorageModel?> in
                guard let self, let id else {
                    return .just(nil)
                }
                
                return service
                    .fetchConfigurations()
                    .map { configs -> WidgetCarLogoStorageModel? in
                        configs.first(where: { $0.id == id })
                    }
                    .asDriver(onErrorJustReturn: nil)
            }
    }
    
    func makeBrands() -> Driver<[WidgetCarLogoBrand]> {
        vehicleManager
            .fetchVehicleSupportLogos()
            .map { $0?.catalogBrands ?? [] }
            .map { brands -> [WidgetCarLogoBrand] in
                brands.map { WidgetCarLogoBrand(logo: $0.logo, model: $0.model) }
            }
            .asDriver(onErrorJustReturn: [])
    }
}
