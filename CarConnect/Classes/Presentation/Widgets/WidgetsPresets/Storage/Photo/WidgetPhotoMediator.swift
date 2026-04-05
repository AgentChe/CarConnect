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
    
    private lazy var didSavedPhotoModelTrigger = PublishRelay<WidgetPhotoStorageModel>()
    private lazy var didEditedPhotoModelTrigger = PublishRelay<WidgetPhotoStorageModel>()
    private lazy var didDeletedPhotoModelIdTrigger = PublishRelay<String>()
    
    private lazy var didSavedAIPhotoMyCarModelTrigger = PublishRelay<WidgetAIPhotoMyCarStorageModel>()
    private lazy var didEditedAIPhotoMyCarModelTrigger = PublishRelay<WidgetAIPhotoMyCarStorageModel>()
    private lazy var didDeletedAIPhotoMyCarModelIdTrigger = PublishRelay<String>()
    
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
    
    func saved(photoModel: WidgetPhotoStorageModel) {
        didSavedPhotoModelTrigger.accept(photoModel)
    }
    
    func edited(photoModel: WidgetPhotoStorageModel) {
        didEditedPhotoModelTrigger.accept(photoModel)
    }
    
    func deleted(photoModelId: String) {
        didDeletedPhotoModelIdTrigger.accept(photoModelId)
    }
    
    func saved(aiPhotoMyCarModel: WidgetAIPhotoMyCarStorageModel) {
        didSavedAIPhotoMyCarModelTrigger.accept(aiPhotoMyCarModel)
    }
    
    func edited(aiPhotoMyCarModel: WidgetAIPhotoMyCarStorageModel) {
        didEditedAIPhotoMyCarModelTrigger.accept(aiPhotoMyCarModel)
    }
    
    func deleted(aiPhotoMyCarModelId: String) {
        didDeletedAIPhotoMyCarModelIdTrigger.accept(aiPhotoMyCarModelId)
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
    
    var didSavedPhotoModel: Signal<WidgetPhotoStorageModel> {
        didSavedPhotoModelTrigger.asSignal()
    }
    
    var didEditedPhotoModel: Signal<WidgetPhotoStorageModel> {
        didEditedPhotoModelTrigger.asSignal()
    }
    
    var didDeletedPhotoModelId: Signal<String> {
        didDeletedPhotoModelIdTrigger.asSignal()
    }
    
    var didSavedAIPhotoMyCarModel: Signal<WidgetAIPhotoMyCarStorageModel> {
        didSavedAIPhotoMyCarModelTrigger.asSignal()
    }
    
    var didEditedAIPhotoMyCarModel: Signal<WidgetAIPhotoMyCarStorageModel> {
        didEditedAIPhotoMyCarModelTrigger.asSignal()
    }
    
    var didDeletedAIPhotoMyCarModelId: Signal<String> {
        didDeletedAIPhotoMyCarModelIdTrigger.asSignal()
    }
}
