//
//  MusicPlayerViewController.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 24.03.2026.
//

import UIKit
import MusicKit

final class MusicPlayerViewController: UIViewController {
    private lazy var mainView = MusicPlayerView()
    private let viewModel: MusicPlayerViewModel
    private let router: PlayerRouter
    
    init(source: MusicPlayerViewModel.Source, router: PlayerRouter) {
        self.router = router
        viewModel = MusicPlayerViewModel(source: source)
        
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
        
        mainView.trackProgress.delegate = viewModel
        mainView.controlsView.delegate = viewModel
        
        if (navigationController?.viewControllers.count ?? 1) <= 1 {
            let button = mainView.setup(type: .dropdown)
            button.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        } else {
            let button = mainView.setup(type: .back)
            button.addTarget(self, action: #selector(pop), for: .touchUpInside)
        }
        
        viewModel.onUpdateTrack = { [weak self] model in
            guard let self else { return }
            
            mainView.trackInfo.setup(title: model.title, subtitle: model.subtitle, image: model.artwork)
        }
        
        viewModel.onUpdateState = { [weak self] model in
            guard let self else { return }
            
            mainView.trackProgress.setup(
                current: model.currentTime,
                duration: model.duration
            )
            
            mainView.controlsView.setup(
                isPlaying: model.isPlaying,
                repeatMode: model.repeatMode,
                shuffleMode: model.shuffleMode
            )
        }
        
        viewModel.showMessage = { [weak self] in
            self?.mainView.showMessage($0)
        }
        
        viewModel.start()
    }
    
    
    @objc func pop(_ button: UIButton) {
        router.pop()
    }
    
    @objc private func openMenu(_ button: DropdownButtonView) {
        let musicSource: MusicSource
        
        switch viewModel.source {
        case .appleMusic:
            musicSource = .appleMusic
        case .spotify:
            musicSource = .spotify
        }
        
        router.openMusicSource(current: musicSource, actionFrame: button.frame)
    }
}
