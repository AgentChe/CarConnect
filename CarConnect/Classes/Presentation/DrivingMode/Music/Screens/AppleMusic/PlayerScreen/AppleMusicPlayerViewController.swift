//
//  AppleMusicPlayerViewController.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 24.03.2026.
//

import UIKit
import MusicKit

final class AppleMusicPlayerViewController: UIViewController {
    private lazy var mainView = AppleMusicPlayerView()
    private let viewModel: AppleMusicPlayerViewModel
    
    init(source: AppleMusicPlayerViewModel.Source) {
        viewModel = AppleMusicPlayerViewModel(source: source)
        
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
        
        
        mainView.backButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
        
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
        
        viewModel.start()
    }
    
    
    @objc func pop(_ button: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
