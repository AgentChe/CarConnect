//
//  MusicPlayerControlsView.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 24.03.2026.
//

import Foundation
import UIKit

protocol MusicPlayerControlsDelegate: AnyObject {
    func didTapNext()
    func didTapPrevios()
    func didTapPlayPause()
    func didTapShuffleMode()
    func didTapRepeatMode()
}

final class MusicPlayerControlsView: UIView {
    private lazy var container = makeContainer()
    private lazy var playButton = makeButton()
    private lazy var previousButton = makeButton()
    private lazy var nextButton = makeButton()
    private lazy var shuffleButton = makeButton()
    private lazy var repeatButton = makeButton()
    private lazy var repeatSelector = makeSelector()
    private lazy var shuffleSelector = makeSelector()
    
    weak var delegate: MusicPlayerControlsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MusicPlayerControlsView {
    func setup(isPlaying: Bool, repeatMode: RepeatMode, shuffleMode: ShuffleMode) {
        let playImage = isPlaying ? UIImage(named: "Player.Pause") : UIImage(named: "Player.Play")
        
        let repeatIsSelected = repeatMode == .none
        repeatButton.tintColor = Appearance.color_FFFFFF
        repeatSelector.isHidden = !repeatIsSelected
        
        let shuffleIsSelected = shuffleMode == .on
        shuffleButton.tintColor = Appearance.color_FFFFFF
        shuffleSelector.isHidden = !shuffleIsSelected
        
        playButton.setImage(playImage, for: .normal)
    }
}

private extension MusicPlayerControlsView {
    @objc func tapNext() {
        delegate?.didTapNext()
    }
    
    @objc func tapPrevios() {
        delegate?.didTapPrevios()
    }
    
    @objc func tapPlayPause() {
        delegate?.didTapPlayPause()
    }
    
    @objc func tapShuffleMode() {
        delegate?.didTapShuffleMode()
    }
    
    @objc func tapRepeatMode() {
        delegate?.didTapRepeatMode()
    }
}

// MARK: Private
private extension MusicPlayerControlsView {
    func initialize() {
        previousButton.backgroundColor = Appearance.color_FFFFFF.withAlphaComponent(0.16)
        previousButton.setImage(UIImage(named: "Player.Previous"), for: .normal)
        previousButton.tintColor = Appearance.color_FFFFFF
        previousButton.addTarget(self, action: #selector(tapPrevios), for: .touchUpInside)
        
        nextButton.backgroundColor = Appearance.color_FFFFFF.withAlphaComponent(0.16)
        nextButton.setImage(UIImage(named: "Player.Next"), for: .normal)
        nextButton.tintColor = Appearance.color_FFFFFF
        nextButton.addTarget(self, action: #selector(tapNext), for: .touchUpInside)
        
        playButton.backgroundColor = Appearance.color_FFFFFF
        playButton.tintColor = Appearance.color_080A0C
        playButton.addTarget(self, action: #selector(tapPlayPause), for: .touchUpInside)
        
        [previousButton, playButton, nextButton]
            .forEach {
                var config = UIButton.Configuration.plain()
                config.imagePadding = 20
                $0.layer.cornerRadius = 36.landscapeHScale
                container.addArrangedSubview($0)
            }
        
        shuffleButton.backgroundColor = .clear
        shuffleButton.setImage(UIImage(named: "Player.Shuffle"), for: .normal)
        shuffleButton.tintColor = Appearance.color_FFFFFF.withAlphaComponent(0.6)
        shuffleButton.addTarget(self, action: #selector(tapShuffleMode), for: .touchUpInside)
        
        repeatButton.backgroundColor = .clear
        repeatButton.setImage(UIImage(named: "Player.Repeat"), for: .normal)
        repeatButton.tintColor = Appearance.color_FFFFFF.withAlphaComponent(0.6)
        repeatButton.addTarget(self, action: #selector(tapRepeatMode), for: .touchUpInside)
        
        shuffleSelector.isHidden = true
        repeatSelector.isHidden = true
        
        addSubview(shuffleButton)
        addSubview(repeatButton)
    }
}
// MARK: Make constraints
private extension MusicPlayerControlsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            shuffleButton.heightAnchor.constraint(equalToConstant: 32.landscapeVScale),
            shuffleButton.widthAnchor.constraint(equalTo: shuffleButton.heightAnchor),
            shuffleButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            shuffleButton.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            shuffleSelector.heightAnchor.constraint(equalToConstant: 3.landscapeVScale),
            shuffleSelector.widthAnchor.constraint(equalTo: shuffleSelector.heightAnchor),
            shuffleSelector.topAnchor.constraint(equalTo: shuffleButton.bottomAnchor, constant: 8.landscapeVScale),
            shuffleSelector.centerXAnchor.constraint(equalTo: shuffleButton.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            repeatButton.heightAnchor.constraint(equalTo: shuffleButton.widthAnchor),
            repeatButton.widthAnchor.constraint(equalTo: shuffleButton.heightAnchor),
            repeatButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            repeatButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            repeatSelector.heightAnchor.constraint(equalToConstant: 3.landscapeVScale),
            repeatSelector.widthAnchor.constraint(equalTo: repeatSelector.heightAnchor),
            repeatSelector.topAnchor.constraint(equalTo: repeatButton.bottomAnchor, constant: 8.landscapeVScale),
            repeatSelector.centerXAnchor.constraint(equalTo: repeatButton.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: shuffleButton.trailingAnchor, constant: 48.landscapeHScale),
            container.trailingAnchor.constraint(equalTo: repeatButton.leadingAnchor, constant: -48.landscapeHScale),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 72.landscapeVScale),
            container.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            previousButton.heightAnchor.constraint(equalTo: container.heightAnchor),
            previousButton.widthAnchor.constraint(equalTo: previousButton.heightAnchor),
            nextButton.widthAnchor.constraint(equalTo: previousButton.widthAnchor),
            nextButton.heightAnchor.constraint(equalTo: previousButton.heightAnchor),
            playButton.widthAnchor.constraint(equalTo: previousButton.widthAnchor),
            playButton.heightAnchor.constraint(equalTo: previousButton.heightAnchor)
        ])
    }
}
// MARK: Lazy initialization
private extension MusicPlayerControlsView {
    func makeContainer() -> UIStackView {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 24.landscapeHScale
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSelector() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 3.landscapeVScale
        view.backgroundColor = Appearance.color_FFFFFF
        addSubview(view)
        return view
    }
}
