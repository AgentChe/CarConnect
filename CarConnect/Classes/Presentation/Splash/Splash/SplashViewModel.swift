//
//  SplashViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 21.02.2026.
//

import RxSwift
import RxCocoa

final class SplashViewModel {
    enum Action {
        case openMain
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var sessionManager = SessionManager()
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Public
extension SplashViewModel {
    struct Input {
        let didSDKConfigured: Signal<Void>
    }
    
    struct Output {
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        let login = login(didSDKConfigured: input.didSDKConfigured)
        
        return Output(
            action: makeAction(login: login)
        )
    }
}

// MARK: Private
private extension SplashViewModel {
    func makeAction(login: Signal<Void>) -> Driver<Action> {
        login
            .map { Action.openMain }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func login(didSDKConfigured: Signal<Void>) -> Signal<Void> {
        didSDKConfigured
            .flatMapLatest { [weak self] void -> Signal<Void> in
                guard let self else { return .never() }
                
                func source() -> Single<Void> {
                    let anonymousId = sessionManager.anonymousId
                    let internalId = sessionManager.internalId
                    
                    let result = (anonymousId == internalId) ? profileManager.create() : profileManager.binding()
                    return result
                        .map { result -> Void in
                            guard result.success else {
                                throw ContentError(.notContent)
                            }
                            
                            return Void()
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    tryAgain?(error) ?? .empty()
                }
                
                return observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .asSignal(onErrorSignalWith: .never())
            }
    }
}
