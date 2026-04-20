//
//  AppleMusicLibraryViewController.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 28.03.2026.
//

import UIKit
import MusicKit

final class AppleMusicLibraryViewController: UIViewController {
    private lazy var mainView = AppleMusicLibraryView()
    
    private let viewModel: AppleMusicLibraryViewModel
    
    init(category: AppleMusicLibraryCategory) {
        viewModel = .init(category: category)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delgate = self
        
        mainView.navigationView.setTitle(viewModel.category.title)
        mainView.navigationView.backButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
        
        viewModel.onUpdate = { [weak self] in
            guard let self else { return }
            mainView.updateData(items: viewModel.items, category: viewModel.category)
            mainView.updateLoadingState(isLoading: viewModel.isLoading, isEmpty: viewModel.items.isEmpty)
        }
        
        Task { await viewModel.loadInitialData() }
    }
    
    @objc func pop(_ button: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension AppleMusicLibraryViewController: AppleMusicLibraryTableDelegate {
    func didSelectItem(_ item: CollectionType) {
        let controller: UIViewController
        switch item {
        case .playlist(let playlist):
            controller = AppleMusicTrackListViewController(source: .playlist(playlist))
        case .album(let album):
            controller = AppleMusicTrackListViewController(source: .album(album))
        case .artist(let artist):
            controller = AppleMusicArtistLibraryViewController(artist: artist)
        case .track(let track, _):
            let tracks: [Track] = viewModel.items
                .compactMap { model in
                    guard case let .track(track, _) = item else { return nil }
                    return track
                }
            
            controller = AppleMusicPlayerViewController(startItem: track, trackList: .init(tracks), parentCollectionID: nil)
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func visiblePath(indexPath: IndexPath) {
        let count = viewModel.items.count
        guard count > 0, indexPath.row >= count - 5 else { return }
        
        Task { await viewModel.loadNextPage() }
    }
}

private extension TextAttributes {
    static let title = TextAttributes()
        .textColor(Appearance.color_FFFFFF)
        .font(Fonts.Inter.bold(size: 24.landscapeVScale))
        .lineHeight(32.landscapeVScale)
        .textAlignment(.center)
}
