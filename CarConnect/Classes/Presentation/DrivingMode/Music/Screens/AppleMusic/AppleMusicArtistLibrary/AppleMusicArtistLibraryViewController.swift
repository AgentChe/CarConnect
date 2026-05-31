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
    private let router: AppleMusicPlayerRouter
    
    init(artist: Artist, router: AppleMusicPlayerRouter) {
        viewModel = .init(artist: artist)
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
        
        mainView.navigationView.setTitle(viewModel.title)
        mainView.navigationView.backButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
        
        viewModel.onUpdate = { [weak self] in
            guard let self else { return }
            mainView.updateData(items: viewModel.items)
        }
        
        Task { await viewModel.fetchAlbums() }
    }
    
    @objc func pop(_ button: UIButton) {
        router.pop()
    }
}

extension AppleMusicArtistLibraryViewController: AppleMusicArtistLibraryDelegate {
    func didSelectItem(_ item: Album) {
        router.openTrackList(source: .album(item))
    }
    
    func visiblePath(indexPath: IndexPath) {
        let count = viewModel.items.count
        guard count > 0, indexPath.row >= count - 5 else { return }
        
        Task { await viewModel.loadNext() }
    }
}
