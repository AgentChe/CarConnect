//
//  WidgetPhotoMediator.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.04.2026.
//

import RxSwift
import RxCocoa

final class WidgetPhotoMediator {
    static let shared = WidgetPhotoMediator()
    
    private lazy var didSavedAIPhotoModelTrigger = PublishRelay<WidgetAIPhotoStorageModel>()
    private lazy var didEditedAIPhotoModelTrigger = PublishRelay<WidgetAIPhotoStorageModel>()
    private lazy var didDeletedAIPhotoModelIdTrigger = PublishRelay<String>()
    
    private lazy var didSavedPhotoWithTextModelTrigger = PublishRelay<WidgetPhotoWithTextStorageModel>()
    private lazy var didEditedPhotoWithTextModelTrigger = PublishRelay<WidgetPhotoWithTextStorageModel>()
    private lazy var didDeletedPhotoWithTextModelIdTrigger = PublishRelay<String>()
    
    private init() {}
}

// MARK: Public
extension WidgetPhotoMediator {
    func saved(aiPhotoModel: WidgetAIPhotoStorageModel) {
        didSavedAIPhotoModelTrigger.accept(aiPhotoModel)
    }
    
    func edited(aiPhotoModel: WidgetAIPhotoStorageModel) {
        didEditedAIPhotoModelTrigger.accept(aiPhotoModel)
    }
    
    func deleted(aiPhotoModelId: String) {
        didDeletedAIPhotoModelIdTrigger.accept(aiPhotoModelId)
    }
    
    func saved(photoWithTextModel: WidgetPhotoWithTextStorageModel) {
        didSavedPhotoWithTextModelTrigger.accept(photoWithTextModel)
    }
    
    func edited(photoWithTextModel: WidgetPhotoWithTextStorageModel) {
        didEditedPhotoWithTextModelTrigger.accept(photoWithTextModel)
    }
    
    func deleted(photoWithTextModelId: String) {
        didDeletedPhotoWithTextModelIdTrigger.accept(photoWithTextModelId)
    }
    
    var didSavedAIPhotoModel: Signal<WidgetAIPhotoStorageModel> {
        didSavedAIPhotoModelTrigger.asSignal()
    }
    
    var didEditedAIPhotoModel: Signal<WidgetAIPhotoStorageModel> {
        didEditedAIPhotoModelTrigger.asSignal()
    }
    
    var didDeletedAIPhotoModelId: Signal<String> {
        didDeletedAIPhotoModelIdTrigger.asSignal()
    }
    
    var didSavedPhotoWithTextModel: Signal<WidgetPhotoWithTextStorageModel> {
        didSavedPhotoWithTextModelTrigger.asSignal()
    }
    
    var didEditedPhotoWithTextModel: Signal<WidgetPhotoWithTextStorageModel> {
        didEditedPhotoWithTextModelTrigger.asSignal()
    }
    
    var didDeletedPhotoWithTextModelId: Signal<String> {
        didDeletedPhotoWithTextModelIdTrigger.asSignal()
    }
}
