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
    private let router: AppleMusicPlayerRouter
    
    init(category: AppleMusicLibraryCategory, router: AppleMusicPlayerRouter) {
        viewModel = .init(category: category)
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delgate = self
        
        mainView.navigationView.setTitle(viewModel.category.title)
        mainView.navigationView.backButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
        
        viewModel.onUpdate = { [weak self] in
            guard let self else { return }
            mainView.updateData(items: viewModel.items, category: viewModel.category)
            mainView.updateState(isLoading: viewModel.isLoading, isEmpty: viewModel.items.isEmpty)
        }
        
        Task { await viewModel.loadInitialData() }
    }
    
    @objc func pop(_ button: UIButton) {
        router.pop()
    }
}

extension AppleMusicLibraryViewController: AppleMusicLibraryTableDelegate {
    func didSelectItem(_ item: AppleMusicCollectionType) {
        switch item {
        case .playlist(let playlist):
            router.openTrackList(source: .playlist(playlist))
        case .album(let album):
            router.openTrackList(source: .album(album))
        case .artist(let artist):
            router.openArtistLibrary(artist: artist)
        case .track(let track, _):
            let tracks: [Track] = viewModel.items
                .compactMap { model in
                    guard case let .track(track, _) = item else { return nil }
                    return track
                }
            router.openPlayer(source: .appleMusic(startItem: track, trackList: .init(tracks), parentCollectionID: nil))
        }
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
