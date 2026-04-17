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
    
    init(source: TrackListSource) {
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
        navigationItem.title = viewModel.title
        
        viewModel.onUpdate = { [weak self] in
            guard let self else { return }
            mainView.updateData(items: viewModel.items)
        }
        
        Task { await viewModel.fetchTracks() }
        viewModel.observePlayingTrack()
    }
}

extension AppleMusicTrackListViewController: AppleMusicTrackListTableDelegate {
    func didSelectItem(_ item: Track) {
        let controller = AppleMusicPlayerViewController(startItem: item, trackList: viewModel.tracks, parentCollectionID: viewModel.collectionID)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func visiblePath(indexPath: IndexPath) {
        let count = viewModel.tracks.count
        guard count > 0, indexPath.row >= count - 5 else { return }
        
        Task { await viewModel.loadNext() }
    }
}
