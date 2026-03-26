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
    
    var didSavedClockModel: Signal<WidgetClockStorageModel> {
        didSavedClockModelTrigger.asSignal()
    }
    
    var didEditedClockModel: Signal<WidgetClockStorageModel> {
        didEditedClockModelTrigger.asSignal()
    }
    
    var didDeletedClockModelId: Signal<String> {
        didDeletedClockModelIdTrigger.asSignal()
    }
}
