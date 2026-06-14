//
//  SpotifyCoordinator.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 30.05.2026.
//

import Foundation
import UIKit

final class SpotifyCoordinator: CoordinatorBaseProtocol {
    weak var navigationController: UINavigationController?
    var childCoordinator: [CoordinatorProtocol] = []
    weak var souceSelectionDelegate: MusicSourceSelectionDelegate?
    
    private let spotifyConnectionService: SpotifyConnectionService
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        spotifyConnectionService = .shared
    }
    
    func start() {
        let isAuthorized = spotifyConnectionService.checkSpotifyAvailability()
        if isAuthorized {
            let controller = MusicPlayerViewController(source: .spotify, router: self)
            navigationController?.setViewControllers([controller], animated: true)
        } else {
            let controller = AuthorizationRequiredViewController(source: .spotify)
            controller.delegate = self
            navigationController?.setViewControllers([controller], animated: true)
        }
    }
}

extension SpotifyCoordinator: PlayerSourceSelection {
    func openMusicSource(current: MusicSource, animated: Bool) {
        let controller = MusicSourceMenuViewController(current: current)
        controller.delegate = souceSelectionDelegate
        controller.modalPresentationStyle = .currentContext
        navigationController?.present(controller, animated: animated)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func dismiss(animated: Bool) {
        navigationController?.dismiss(animated: animated)
    }
}

extension SpotifyCoordinator: AuthorizationRequiredViewControllerDelegate {
    func didTapButton() {
        Task { @MainActor in
            let spotifyInstalled = await spotifyConnectionService.autorize()
            if spotifyInstalled {
               start()
            }
        }
    }
}
