//
//  SceneDelegateMediator.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 30.05.2026.
//

import RxSwift
import RxCocoa

final class SceneDelegateMediator {
    static let shared = SceneDelegateMediator()
    
    private lazy var didOpenURLContextsTrigger = PublishRelay<Set<UIOpenURLContext>>()
    
    private init() {}
}

// MARK: Public
extension SceneDelegateMediator {
    func send(openURLContexts: Set<UIOpenURLContext>) {
        didOpenURLContextsTrigger.accept(openURLContexts)
    }
    
    var didOpenURLContexts: Signal<Set<UIOpenURLContext>> {
        didOpenURLContextsTrigger.asSignal()
    }
}
