//
//  AppleMusicMainViewController.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 12.03.2026.
//

import UIKit
import RxSwift

final class AppleMusicMainViewController: UIViewController {
    private lazy var mainView = AppleMusicMainView()
    
    private lazy var viewModel = AppleMusicMainViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.collectionView.delegate = self
        
        viewModel.onUpdate = { [weak self] in
            guard let self else { return }
            mainView.collectionView.apply(recentItems: viewModel.recentElements, categories: viewModel.libraryItems)
        }
        
        Task {
            let isAuthorizied = await viewModel.checkAuthorization()
            await MainActor.run {
                mainView.setupAuthState(isAuthorized: isAuthorizied)
            }
        }
        
        viewModel.loadInitial()
    }
}

extension AppleMusicMainViewController: AppleMusicMainCollectionViewDelegate {
    func didSelectRecentItem(_ item: AppleMusicLibraryItem) {
        let controller: UIViewController
        switch item {
        case .recent(let item):
            switch item {
            case .playlist(let playlist):
                controller = AppleMusicTrackListViewController(source: .playlist(playlist))
            case .album(let album):
                controller = AppleMusicTrackListViewController(source: .album(album))
            case .artist(let artist):
                controller = AppleMusicArtistLibraryViewController(artist: artist)
            case .track(let track):
                controller = AppleMusicPlayerViewController(startItem: track, trackList: nil, parentCollectionID: nil)
            }
            navigationController?.pushViewController(controller, animated: true)
        case .category(let category):
            let controller = AppleMusicLibraryViewController(category: category)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func loadNext() {
        viewModel.loadNextPage()
    }
}

// MARK: Public
extension AppleMusicMainViewController {
    static func make() -> UIViewController {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.titleTextAttributes = [
            .font: Fonts.Inter.bold(size: 24.landscapeVScale),
            .foregroundColor: Appearance.color_FFFFFF
        ]
        let controller = UINavigationController(rootViewController: AppleMusicMainViewController())
        controller.navigationBar.standardAppearance = appearance
        controller.navigationBar.scrollEdgeAppearance = appearance
        return controller
    }
}
