//
//  AppleMusicTrackListViewController.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 31.03.2026.
//

import UIKit
import MusicKit

final class AppleMusicTrackListViewController: UIViewController {
    private lazy var mainView = AppleMusicTrackListView()
    private let viewModel: AppleMusicTrackListViewModel
    private let router: AppleMusicPlayerRouter
    
    init(source: AppleMusicTrackListSource, router: AppleMusicPlayerRouter) {
        self.router = router
        viewModel = AppleMusicTrackListViewModel(source: source)
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
        
        mainView.navigationView.setTitle(viewModel.title)
        mainView.navigationView.backButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
        
        viewModel.onUpdate = { [weak self] in
            guard let self else { return }
            mainView.updateData(items: viewModel.items)
            mainView.setLoadingState(isLoading: viewModel.isLoading)
        }
        
        Task { await viewModel.fetchTracks() }
    }
    
    @objc func pop(_ button: UIButton) {
        router.pop()
    }
}

extension AppleMusicTrackListViewController: AppleMusicTrackListTableDelegate {
    func didSelectItem(_ item: Track) {
        router.openPlayer(source: .appleMusic(startItem: item, trackList: viewModel.trackCollection, parentCollectionID: viewModel.collectionID))
    }
    
    func visiblePath(indexPath: IndexPath) {
        let count = viewModel.items.count
        guard count > 0, indexPath.row >= count - 5 else { return }
        
        Task { await viewModel.loadNext() }
    }
}
