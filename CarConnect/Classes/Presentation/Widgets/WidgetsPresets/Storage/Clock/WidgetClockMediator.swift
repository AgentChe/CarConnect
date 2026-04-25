//
//  WidgetClockMediator.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 25.03.2026.
//

import RxSwift
import RxCocoa

final class WidgetClockMediator {
    static let shared = WidgetClockMediator()
    
    private lazy var didSavedClockModelTrigger = PublishRelay<WidgetClockStorageModel>()
    private lazy var didEditedClockModelTrigger = PublishRelay<WidgetClockStorageModel>()
    private lazy var didDeletedClockModelIdTrigger = PublishRelay<String>()
    
    private lazy var didSavedClockAIPreviewModelTrigger = PublishRelay<WidgetClockAIPreviewStorageModel>()
    private lazy var didEditedClockAIPreviewModelTrigger = PublishRelay<WidgetClockAIPreviewStorageModel>()
    private lazy var didDeletedClockAIPreviewModelIdTrigger = PublishRelay<String>()
    
    private init() {}
}

// MARK: Public
extension WidgetClockMediator {
    func saved(clockModel: WidgetClockStorageModel) {
        didSavedClockModelTrigger.accept(clockModel)
    }
    
    func edited(clockModel: WidgetClockStorageModel) {
        didEditedClockModelTrigger.accept(clockModel)
    }
    
    func deleted(clockModelId: String) {
        didDeletedClockModelIdTrigger.accept(clockModelId)
    }
    
    func saved(clockAIPreviewModel: WidgetClockAIPreviewStorageModel) {
        didSavedClockAIPreviewModelTrigger.accept(clockAIPreviewModel)
    }
    
    func edited(clockAIPreviewModel: WidgetClockAIPreviewStorageModel) {
        didEditedClockAIPreviewModelTrigger.accept(clockAIPreviewModel)
    }
    
    func deleted(clockAIPreviewModelId: String) {
        didDeletedClockAIPreviewModelIdTrigger.accept(clockAIPreviewModelId)
    }
    
    var didSavedClockModel: Signal<WidgetClockStorageModel> {
        didSavedClockModelTrigger.asSignal()
    }
    
    var didEditedClockModel: Signal<WidgetClockStorageModel> {
        didEditedClockModelTrigger.asSignal()
    }
    
    var didDeletedClockModelId: Signal<String> {
        didDeletedClockModelIdTrigger.asSignal()
    }
    
    var didSavedClockAIPreviewModel: Signal<WidgetClockAIPreviewStorageModel> {
        didSavedClockAIPreviewModelTrigger.asSignal()
    }
    
    var didEditedClockAIPreviewModel: Signal<WidgetClockAIPreviewStorageModel> {
        didEditedClockAIPreviewModelTrigger.asSignal()
    }
    
    var didDeletedClockAIPreviewModelId: Signal<String> {
        didDeletedClockAIPreviewModelIdTrigger.asSignal()
    }
}
