//
//  AppleMusicArtistLibraryViewController.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 09.04.2026.
//

import UIKit
import MusicKit

final class AppleMusicArtistLibraryViewController: UIViewController {
    private lazy var mainView = AppleMusicArtistLibraryView()
    
    private let viewModel: AppleMusicArtistLibraryModel
    
    init(artist: Artist) {
        viewModel = .init(artist: artist)
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
            mainView.updateData(items: Array(viewModel.albums))
        }
        
        Task { await viewModel.fetchAlbums() }
    }
}

extension AppleMusicArtistLibraryViewController: AppleMusicArtistLibraryDelegate {
    func didSelectItem(_ item: Album) {
        let controller = AppleMusicTrackListViewController(source: .album(item))
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func visiblePath(indexPath: IndexPath) {
        let count = viewModel.albums.count
        guard count > 0, indexPath.row >= count - 5 else { return }
        
        Task { await viewModel.loadNext() }
    }
}
