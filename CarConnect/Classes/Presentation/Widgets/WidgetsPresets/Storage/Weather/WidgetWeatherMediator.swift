//
//  WidgetWeatherMediator.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 18.03.2026.
//

import RxSwift
import RxCocoa

final class WidgetWeatherMediator {
    static let shared = WidgetWeatherMediator()
    
    private lazy var didSavedWeatherModelTrigger = PublishRelay<WidgetWeatherStorageModel>()
    private lazy var didEditedWeatherModelTrigger = PublishRelay<WidgetWeatherStorageModel>()
    private lazy var didDeletedWeatherModelIdTrigger = PublishRelay<String>()
    
    private init() {}
}

// MARK: Public
extension WidgetWeatherMediator {
    func saved(weatherModel: WidgetWeatherStorageModel) {
        didSavedWeatherModelTrigger.accept(weatherModel)
    }
    
    func edited(weatherModel: WidgetWeatherStorageModel) {
        didEditedWeatherModelTrigger.accept(weatherModel)
    }
    
    func deleted(weatherModelId: String) {
        didDeletedWeatherModelIdTrigger.accept(weatherModelId)
    }
    
    var didSavedWeatherModel: Signal<WidgetWeatherStorageModel> {
        didSavedWeatherModelTrigger.asSignal()
    }
    
    var didEditedWeatherModel: Signal<WidgetWeatherStorageModel> {
        didEditedWeatherModelTrigger.asSignal()
    }
    
    var didDeletedWeatherModelId: Signal<String> {
        didDeletedWeatherModelIdTrigger.asSignal()
    }
}
