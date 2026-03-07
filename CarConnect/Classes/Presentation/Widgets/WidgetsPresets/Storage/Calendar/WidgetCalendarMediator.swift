//
//  WidgetCalendarMediator.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 05.03.2026.
//

import RxSwift
import RxCocoa

final class WidgetCalendarMediator {
    static let shared = WidgetCalendarMediator()
    
    private lazy var didSavedCalendarModelTrigger = PublishRelay<WidgetCalendarStorageModel>()
    private lazy var didEditedCalendarModelTrigger = PublishRelay<WidgetCalendarStorageModel>()
    private lazy var didDeletedCalendarModelIdTrigger = PublishRelay<String>()
    
    private init() {}
}

// MARK: Public
extension WidgetCalendarMediator {
    func saved(calendarModel: WidgetCalendarStorageModel) {
        didSavedCalendarModelTrigger.accept(calendarModel)
    }
    
    func edited(calendarModel: WidgetCalendarStorageModel) {
        didEditedCalendarModelTrigger.accept(calendarModel)
    }
    
    func deleted(calendarModelId: String) {
        didDeletedCalendarModelIdTrigger.accept(calendarModelId)
    }
    
    var didSavedCalendarModel: Signal<WidgetCalendarStorageModel> {
        didSavedCalendarModelTrigger.asSignal()
    }
    
    var didEditedCalendarModel: Signal<WidgetCalendarStorageModel> {
        didEditedCalendarModelTrigger.asSignal()
    }
    
    var didDeletedCalendarModelId: Signal<String> {
        didDeletedCalendarModelIdTrigger.asSignal()
    }
}
