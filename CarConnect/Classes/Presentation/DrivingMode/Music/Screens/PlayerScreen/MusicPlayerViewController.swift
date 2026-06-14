//
//  MusicPlayerViewController.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 24.03.2026.
//

import UIKit
import MusicKit
import RxSwift
import RxCocoa

final class MusicPlayerViewController: UIViewController {
    private lazy var mainView = MusicPlayerView()
    private let viewModel: MusicPlayerViewModel
    private let router: PlayerSourceSelection
    
    private var disposeBag = DisposeBag()
    
    init(source: PlayMusicSource, router: PlayerSourceSelection) {
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
        
        if (navigationController?.viewControllers.count ?? 1) == 1 {
            let button = mainView.setup(type: .dropdown)
            button.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        } else {
            let button = mainView.setup(type: .back)
            button.addTarget(self, action: #selector(pop), for: .touchUpInside)
        }
        
        let output = viewModel.configure(input: .init())
        
        
        output.trackInfo
            .drive(Binder(mainView.trackInfo) { base, model in
                base.setup(title: model?.title, subtitle: model?.subtitle, image: model?.artwork)
            })
            .disposed(by: disposeBag)
        
        
        output.playbackInfo
            .drive(Binder(mainView) { base, model in
                base.trackProgress.setup(
                    current: model?.currentTime ?? 0,
                    duration: model?.duration ?? 0
                )
                
                base.controlsView.setup(
                    isPlaying: model?.isPlaying == true,
                    repeatMode: model?.repeatMode ?? .all,
                    shuffleMode: model?.shuffleMode ?? .off
                )
            })
            .disposed(by: disposeBag)
        
        output.message
            .emit(to: Binder(mainView) { base, message in
                guard let message else { return }
                base.showMessage(message)
            })
            .disposed(by: disposeBag)
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
        
        router.openMusicSource(current: musicSource, animated: false)
    }
}
