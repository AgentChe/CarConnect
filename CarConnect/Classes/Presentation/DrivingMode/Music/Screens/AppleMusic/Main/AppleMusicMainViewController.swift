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
    private let router: AppleMusicPlayerRouter
    
    private lazy var disposeBag = DisposeBag()
    
    init(router: AppleMusicPlayerRouter) {
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
        mainView.collectionView.delegate = self
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        mainView.searchField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        mainView.searchField.delegate = self
        
        mainView.dropDownButton.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        
        viewModel.onUpdate = { [weak self] in
            guard let self else { return }
            mainView.collectionView.apply(items: viewModel.dataSource)
            mainView.searchResult(isEmpty: viewModel.isSearching && viewModel.dataSource.isEmpty)
            mainView.setLoadingState(isLoading: viewModel.isLoading)
        }
        
        viewModel.loadInitial()
    }
    
    @objc private func textChanged(_ textField: UITextField) {
        viewModel.search(term: textField.text ?? "", isEditing: true)
    }
    
    @objc private func openMenu(_ button: DropdownButtonView) {
        router.openMusicSource(current: .appleMusic, actionFrame: button.frame)
    }
}

extension AppleMusicMainViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewModel.search(term: textField.text ?? "", isEditing: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel.search(term: textField.text ?? "", isEditing: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AppleMusicMainViewController: AppleMusicMainCollectionViewDelegate {
    func didSelectRecentItem(_ item: AppleMusicLibraryItem) {
        switch item {
        case let .recent(item), let .searchResult(item):
            switch item {
            case .playlist(let playlist):
                router.openTrackList(source: .playlist(playlist))
            case .album(let album):
                router.openTrackList(source: .album(album))
            case .artist(let artist):
                router.openArtistLibrary(artist: artist)
            case .track(let track, _):
                router.openPlayer(source: .appleMusic(startItem: track, trackList: nil, parentCollectionID: nil))
            }
        case .category(let category):
            router.openMusicLibrary(category: category)
        }
    }
    
    func loadNext() {
        viewModel.loadNextPage()
    }
}
