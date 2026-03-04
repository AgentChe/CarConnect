//
//  WidgetTextServiceMediator.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.02.2026.
//

import RxSwift
import RxCocoa

final class WidgetTextServiceMediator {
    static let shared = WidgetTextServiceMediator()
    
    private lazy var didSavedQuoteModelTrigger = PublishRelay<WidgetTextQuoteStorageModel>()
    private lazy var didEditedQuoteModelTrigger = PublishRelay<WidgetTextQuoteStorageModel>()
    private lazy var didDeletedQuoteModelIdTrigger = PublishRelay<String>()
    
    private lazy var didSavedManuallyConfigurationTrigger = PublishRelay<WidgetTextManuallyStorageModel>()
    private lazy var didEditedManuallyConfigurationTrigger = PublishRelay<WidgetTextManuallyStorageModel>()
    private lazy var didDeletedManuallyConfigurationIdTrigger = PublishRelay<String>()
    
    private init() {}
}

// MARK: Public
extension WidgetTextServiceMediator {
    func saved(quoteModel: WidgetTextQuoteStorageModel) {
        didSavedQuoteModelTrigger.accept(quoteModel)
    }
    
    func edited(quoteModel: WidgetTextQuoteStorageModel) {
        didEditedQuoteModelTrigger.accept(quoteModel)
    }
    
    func deleted(quoteModelId: String) {
        didDeletedQuoteModelIdTrigger.accept(quoteModelId)
    }
    
    func saved(manuallyConfigurationModel: WidgetTextManuallyStorageModel) {
        didSavedManuallyConfigurationTrigger.accept(manuallyConfigurationModel)
    }
    
    func edited(manuallyConfigurationModel: WidgetTextManuallyStorageModel) {
        didEditedManuallyConfigurationTrigger.accept(manuallyConfigurationModel)
    }
    
    func deleted(manuallyConfigurationModelId: String) {
        didDeletedManuallyConfigurationIdTrigger.accept(manuallyConfigurationModelId)
    }
    
    var didSavedQuoteModel: Signal<WidgetTextQuoteStorageModel> {
        didSavedQuoteModelTrigger.asSignal()
    }
    
    var didEditedQuoteModel: Signal<WidgetTextQuoteStorageModel> {
        didEditedQuoteModelTrigger.asSignal()
    }
    
    var didDeletedQuoteModelId: Signal<String> {
        didDeletedQuoteModelIdTrigger.asSignal()
    }
    
    var didSavedManuallyConfiguration: Signal<WidgetTextManuallyStorageModel> {
        didSavedManuallyConfigurationTrigger.asSignal()
    }
    
    var didEditedManuallyConfiguration: Signal<WidgetTextManuallyStorageModel> {
        didEditedManuallyConfigurationTrigger.asSignal()
    }
    
    var didDeletedManuallyConfigurationId: Signal<String> {
        didDeletedManuallyConfigurationIdTrigger.asSignal()
    }
}
