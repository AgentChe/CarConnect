//
//  AppleMusicPlayerView.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 24.03.2026.
//

import UIKit

final class AppleMusicPlayerView: UIView {
    lazy var trackInfo = makeTrackInfo()
    lazy var trackProgress = makeTrackProgress()
    lazy var controlsView = makePlayerControls()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension AppleMusicPlayerView {
    func initialize() {
        backgroundColor = Appearance.color_080A0C
    }
}

// MARK: Make constraints
private extension AppleMusicPlayerView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            trackInfo.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8.landscapeVScale),
            trackInfo.leadingAnchor.constraint(equalTo: leadingAnchor),
            trackInfo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50.landscapeHScale)
        ])
        
        NSLayoutConstraint.activate([
            trackProgress.topAnchor.constraint(equalTo: trackInfo.bottomAnchor, constant: 24.landscapeVScale),
            trackProgress.leadingAnchor.constraint(equalTo: leadingAnchor),
            trackProgress.trailingAnchor.constraint(equalTo: trackInfo.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            controlsView.topAnchor.constraint(equalTo: trackProgress.bottomAnchor, constant: 24.landscapeVScale),
            controlsView.leadingAnchor.constraint(equalTo: trackProgress.leadingAnchor),
            controlsView.trailingAnchor.constraint(equalTo: trackProgress.trailingAnchor),
        ])
    }
}

// MARK: Lazy initialization
private extension AppleMusicPlayerView {
    func makePlayerControls() -> MusicPlayerControlsView {
        let view = MusicPlayerControlsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTrackInfo() -> MusicPlayerTrackInfoView {
        let view = MusicPlayerTrackInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTrackProgress() -> MusicPlayerProgressView {
        let view = MusicPlayerProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
