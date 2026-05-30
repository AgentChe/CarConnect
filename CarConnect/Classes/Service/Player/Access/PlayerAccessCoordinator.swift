//
//  PlayerAccessCoordinator.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 24.05.2026.
//

import Foundation
import UIKit

protocol PlayerSourceDelegate: AnyObject {
    func showSourceController()
    func didSelectSource(_ newSource: MusicSource)
}

protocol PlayerCoordinator: AnyObject {
    var rootController: UIViewController { get }
    func start(source: MusicSource)
}

final class PlayerAccessCoordinator: PlayerCoordinator {
    var rootController: UIViewController { navigationController }
    
    private let navigationController = UINavigationController()
    private let accessService: PlayerSourceAccessService
    
    private init() {
        self.accessService = PlayerSourceAccessService()
    }
    
    func start(source: MusicSource) {
        switch source {
        case .appleMusic:
            accessService.checkAccessAppleMusic()
                ? setRoot(AppleMusicMainViewController.make(), animated: true)
                : showAuthorizationRequired(for: source)
        case .spotify:
            accessService.checkAccessSpotify()
                ? setRoot(MusicPlayerViewController(source: .spotify), animated: true)
                : showAuthorizationRequired(for: source)
        case .radio:
            break
        }
        
    }
    
    private func showAuthorizationRequired(for source: MusicSource) {
        let vc = AuthorizationRequiredViewController(source: source)
        vc.delegate = self
        setRoot(vc, animated: true)
    }
    
    private func setRoot(_ viewController: UIViewController, animated: Bool) {
        navigationController.setViewControllers([viewController], animated: animated)
    }
}

extension PlayerAccessCoordinator: AuthorizationRequiredViewControllerDelegate {
    func didTapButton(source: MusicSource) {
        Task { @MainActor in
            switch source {
            case .appleMusic:
                let granted = await accessService.requestAuthorizationAppleMusic()
                if granted {
                    setRoot(AppleMusicMainViewController.make(), animated: true)
                }
            case .spotify:
                let spotifyInstalled = await accessService.requestAuthorizationSpotify()
                if spotifyInstalled {
                    setRoot(MusicPlayerViewController(source: .spotify), animated: true)
                }
            case .radio:
                break
            }
        }
    }
}

extension PlayerAccessCoordinator {
    static func make() -> PlayerCoordinator {
        PlayerAccessCoordinator()
    }
}
