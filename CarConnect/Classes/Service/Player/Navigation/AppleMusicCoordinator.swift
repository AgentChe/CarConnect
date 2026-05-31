//
//  AppleMusicCoordinator.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 30.05.2026.
//

import Foundation
import UIKit
import MusicKit

protocol AppleMusicPlayerRouter: Routable {
    func openTrackList(source: AppleMusicTrackListSource)
    func openArtistLibrary(artist: Artist)
    func openPlayer(source: MusicPlayerViewModel.Source)
    func openMusicLibrary(category: AppleMusicLibraryCategory)
    func openMusicSource(current: MusicSource, actionFrame: CGRect)
}

final class AppleMusicCoordinator: CoordinatorBaseProtocol {
    weak var navigationController: UINavigationController?
    
    private let appleMusicService: AppleMusicService
    
    var childCoordinator: [CoordinatorProtocol] = []
    
    weak var souceSelectionDelegate: MusicSourceSelectionDelegate?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        appleMusicService = .init()
    }
    
    func start() {
        if appleMusicService.isAuthorized {
            let controller = AppleMusicMainViewController(router: self)
            navigationController?.setViewControllers([controller], animated: true)
        } else {
            let controller = AuthorizationRequiredViewController(source: .appleMusic)
            controller.delegate = self
            navigationController?.setViewControllers([controller], animated: true)
        }
    }
}

extension AppleMusicCoordinator: AuthorizationRequiredViewControllerDelegate {
    func didTapButton() {
        Task { @MainActor in
            let granted = await appleMusicService.requestAuthorization()
            if granted {
                start()
            }
        }
    }
}

extension AppleMusicCoordinator: AppleMusicPlayerRouter {
    func openTrackList(source: AppleMusicTrackListSource) {
        let controller = AppleMusicTrackListViewController(source: source, router: self)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func openArtistLibrary(artist: Artist) {
        let controller = AppleMusicArtistLibraryViewController(artist: artist, router: self)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func openPlayer(source: MusicPlayerViewModel.Source) {
        let controller = MusicPlayerViewController(source: source, router: self)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func openMusicLibrary(category: AppleMusicLibraryCategory) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.titleTextAttributes = [
            .font: Fonts.Inter.bold(size: 24.landscapeVScale),
            .foregroundColor: Appearance.color_FFFFFF
        ]
        
        let controller = AppleMusicLibraryViewController(category: category, router: self)
        controller.navigationController?.navigationBar.standardAppearance = appearance
        controller.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func openMusicSource(current: MusicSource, actionFrame: CGRect) {
        let controller = MusicSourceMenuViewController(current: current, actionFrame: actionFrame)
        controller.delegate = souceSelectionDelegate
        controller.modalPresentationStyle = .currentContext
        navigationController?.present(controller, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func dismiss() {
        navigationController?.dismiss(animated: true)
    }
}

extension AppleMusicCoordinator: PlayerRouter { }
