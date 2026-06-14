//
//  MusicPlayerView.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 24.03.2026.
//

import UIKit

final class MusicPlayerView: UIView {
    
    enum LeftActionType {
        case back
        case dropdown
    }
    
    lazy var trackInfo = makeTrackInfo()
    lazy var trackProgress = makeTrackProgress()
    lazy var controlsView = makePlayerControls()
    
    private var leftButtonAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MusicPlayerView {
    func setup(type: LeftActionType) -> UIButton {
        let button: UIButton
        switch type {
        case .back:
            button = makeBackButton()
        case .dropdown:
            button = makeDropdownButton()
        }
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor, constant: 19.landscapeVScale),
            button.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            trackInfo.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 8.landscapeVScale),
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
        
        return button
    }
    
    func showMessage(_ message: String) {
        let messageView = makeMessageView(text: message)
        messageView.alpha = 0
        messageView.transform = .init(translationX: 0, y: -30)
        addSubview(messageView)
        NSLayoutConstraint.activate([
            messageView.topAnchor.constraint(equalTo: topAnchor, constant: 21.landscapeVScale),
            messageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            messageView.alpha = 1
            messageView.transform = .identity
        }
        
        UIView.animate(withDuration: 0.3, delay: 2.0, options: .curveEaseOut) {
            messageView.alpha = 0
            messageView.transform = .init(translationX: 0, y: -30)
        } completion: { _ in
            messageView.removeFromSuperview()
        }
    }
}

// MARK: Private
private extension MusicPlayerView {
    func initialize() {
        backgroundColor = Appearance.color_080A0C
    }
}

// MARK: Lazy initialization
private extension MusicPlayerView {
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
    
    func makeBackButton() -> UIButton {
        let view = BackButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeMessageView(text: String) -> SpotifyCapabilitiesMessageView {
        let view = SpotifyCapabilitiesMessageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setup(message: text)
        return view
    }
    
    func makeDropdownButton() -> DropdownButtonView {
        let view = DropdownButtonView(type: .image)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
