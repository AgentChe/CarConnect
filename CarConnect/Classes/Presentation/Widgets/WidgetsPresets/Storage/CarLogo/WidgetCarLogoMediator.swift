//
//  WidgetCarLogoMediator.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 02.04.2026.
//

import RxSwift
import RxCocoa

final class WidgetCarLogoMediator {
    static let shared = WidgetCarLogoMediator()
    
    private lazy var didSavedCarLogoModelTrigger = PublishRelay<WidgetCarLogoStorageModel>()
    private lazy var didEditedCarLogoModelTrigger = PublishRelay<WidgetCarLogoStorageModel>()
    private lazy var didDeletedCarLogoModelIdTrigger = PublishRelay<String>()
    
    private init() {}
}

// MARK: Public
extension WidgetCarLogoMediator {
    func saved(carLogoModel: WidgetCarLogoStorageModel) {
        didSavedCarLogoModelTrigger.accept(carLogoModel)
    }
    
    func edited(carLogoModel: WidgetCarLogoStorageModel) {
        didEditedCarLogoModelTrigger.accept(carLogoModel)
    }
    
    func deleted(carLogoModelId: String) {
        didDeletedCarLogoModelIdTrigger.accept(carLogoModelId)
    }
    
    var didSavedCarLogoModel: Signal<WidgetCarLogoStorageModel> {
        didSavedCarLogoModelTrigger.asSignal()
    }
    
    var didEditedCarLogoModel: Signal<WidgetCarLogoStorageModel> {
        didEditedCarLogoModelTrigger.asSignal()
    }
    
    var didDeletedCarLogoModelId: Signal<String> {
        didDeletedCarLogoModelIdTrigger.asSignal()
    }
}
