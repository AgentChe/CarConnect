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
    
    var didSavedAIPhotoModel: Signal<WidgetAIPhotoStorageModel> {
        didSavedAIPhotoModelTrigger.asSignal()
    }
    
    var didEditedAIPhotoModel: Signal<WidgetAIPhotoStorageModel> {
        didEditedAIPhotoModelTrigger.asSignal()
    }
    
    var didDeletedAIPhotoModelId: Signal<String> {
        didDeletedAIPhotoModelIdTrigger.asSignal()
    }
}
