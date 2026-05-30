//
//  NavigatorSession.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 30.05.2026.
//

import RxSwift
import RxCocoa
import GoogleNavigation

final class NavigatorSession {
    enum State {
        case idle
        case navigation
    }

    static let shared = NavigatorSession()

    private(set) var session: GMSNavigationSession?

    private lazy var stateRelay = BehaviorRelay<State>(value: .idle)

    private init() {}
}

// MARK: Public
extension NavigatorSession {
    var state: Driver<State> {
        stateRelay.asDriver()
    }

    func makeSessionIfNeeded() -> GMSNavigationSession? {
        if let session {
            return session
        }

        let session = GMSNavigationServices.createNavigationSession()
        self.session = session
        return session
    }

    func didStartNavigation() {
        stateRelay.accept(.navigation)
    }

    func didStopNavigation() {
        session?.isStarted = false

        stateRelay.accept(.idle)
    }
}
