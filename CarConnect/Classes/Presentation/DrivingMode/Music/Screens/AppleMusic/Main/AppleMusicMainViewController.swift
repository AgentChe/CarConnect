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
        let controller = MusicSourceMenuViewController(actionFrame: mainView.dropDownButton.frame)
        
        controller.modalPresentationStyle = .currentContext
        present(controller, animated: false)
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
        let controller: UIViewController
        switch item {
        case let .recent(item), let .searchResult(item):
            switch item {
            case .playlist(let playlist):
                controller = AppleMusicTrackListViewController(source: .playlist(playlist))
            case .album(let album):
                controller = AppleMusicTrackListViewController(source: .album(album))
            case .artist(let artist):
                controller = AppleMusicArtistLibraryViewController(artist: artist)
            case .track(let track, _):
                controller = MusicPlayerViewController(
                    source: .appleMusic(startItem: track, trackList: nil, parentCollectionID: nil)
                )
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
        let controller = AppleMusicMainViewController()
        controller.navigationController?.navigationBar.standardAppearance = appearance
        controller.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        return controller
    }
}
