//
//  MusicPlayerCoordinator.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 24.05.2026.
//

import Foundation
import UIKit

enum MusicPlayerRoute: Codable, Hashable {
    case player(MusicSource)
    case source(current: MusicSource?)
    
    var musicSource: MusicSource? {
        switch self {
        case .player(let musicSource):
            musicSource
        case .source(let musicSource):
            musicSource
        }
    }
}

protocol PlayerSourceSelection: Routable, AnyObject {
    func openMusicSource(current: MusicSource, animated: Bool)
}

final class MusicPlayerCoordinator: CoordinatorBaseProtocol {
    
    var navigationController: UINavigationController?
    
    var childCoordinator: [CoordinatorProtocol] = []
    
    private var source: MusicSource?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    private func start(source: MusicSource) {
        self.source = source
        
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
        }
    }
    
    func start(route: MusicPlayerRoute) {
        switch route {
        case .player(let musicSource):
            selectedSource(musicSource)
        case .source(let musicSource):
            let controller = MusicSourceMenuViewController(current: musicSource)
            controller.delegate = self
            navigationController?.setViewControllers([controller], animated: false)
        }
    }
}

extension MusicPlayerCoordinator: MusicSourceSelectionDelegate {
    func selectedSource(_ source: MusicSource) {
        MusicManager.shared.changeSource(to: source)
        
        if navigationController?.presentedViewController != nil {
            navigationController?.dismiss(animated: false) { [weak self] in
                self?.start(source: source)
            }
        } else {
            start(source: source)
        }
        
    }
    
    func close() {
        if navigationController?.presentedViewController != nil {
            navigationController?.dismiss(animated: false)
        } else {
            
        }
    }
}
