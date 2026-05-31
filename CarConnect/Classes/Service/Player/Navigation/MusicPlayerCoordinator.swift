//
//  MusicPlayerCoordinator.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 24.05.2026.
//

import Foundation
import UIKit

protocol PlayerRouter: Routable {
    func openMusicSource(current: MusicSource, actionFrame: CGRect)
}

final class MusicPlayerCoordinator: CoordinatorBaseProtocol {
    var navigationController: UINavigationController?
    
    var childCoordinator: [CoordinatorProtocol] = []
    
    private var source: MusicSource?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        switch source {
        case .appleMusic:
            let coordinator = AppleMusicCoordinator(navigationController: navigationController)
            coordinator.souceSelectionDelegate = self
            childCoordinator = [coordinator]
            coordinator.start()
        case .spotify:
            let coordinator = SpotifyCoordinator(navigationController: navigationController)
            coordinator.souceSelectionDelegate = self
            childCoordinator = [coordinator]
            coordinator.start()
        case .radio:
            break
        case .none:
            let controller = MusicSourceMenuViewController(current: nil, actionFrame: nil)
            controller.delegate = self
            navigationController?.setViewControllers([controller], animated: true)
        }
    }
    
    
    
    func switchSource(source: MusicSource?) {
//        guard self.source != source else { return }
        self.source = source
        start()
    }
}

extension MusicPlayerCoordinator: MusicSourceSelectionDelegate {
    func selectedSource(_ source: MusicSource) {
        if navigationController?.presentedViewController != nil {
            navigationController?.dismiss(animated: false) { [weak self] in
                self?.switchSource(source: source)
            }
        } else {
            switchSource(source: source)
        }
        
    }
    
    func close() {
        navigationController?.dismiss(animated: false)
    }
}
