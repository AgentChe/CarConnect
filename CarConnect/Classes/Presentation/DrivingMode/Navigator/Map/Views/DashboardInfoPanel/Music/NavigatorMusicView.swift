//
//  NavigatorMusicView.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 13.06.2026.
//

import UIKit

class NavigatorMusicView: UIView {
    weak var controlDelegate: NavigatorMusicControlDelegate?
    weak var sourceDelegate: NavigatorMusicSelection?
    
    private var currentView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
        displayMusic(isAvailable: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NavigatorMusicView {
    func setupState(model: PlaybackModel?) {
        guard let playerView = currentView as? NavigatorMusicPlayerView else { return }
        playerView.setupState(model: model)
    }
    
    func setupTrackInfo(model: TrackModel?, source: MusicSource) {
        guard let playerView = currentView as? NavigatorMusicPlayerView else { return }
        playerView.setupTrackInfo(model: model, source: source)
    }
}

// MARK: Private
private extension NavigatorMusicView {
    func initialize() {
        layer.cornerRadius = 10.landscapeHScale
    }
}

extension NavigatorMusicView {
    func displayMusic(isAvailable: Bool) {
        
        subviews.forEach { $0.removeFromSuperview() }
        let view: UIView
        if isAvailable {
            let playerView = NavigatorMusicPlayerView()
            playerView.delegate = controlDelegate
            view = playerView
        } else {
            let musicSource = NavigatorMusicEmptyView()
            musicSource.delegate = sourceDelegate
            view = musicSource
        }
        currentView = view
        
        subviews.forEach { $0.removeFromSuperview() }
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
