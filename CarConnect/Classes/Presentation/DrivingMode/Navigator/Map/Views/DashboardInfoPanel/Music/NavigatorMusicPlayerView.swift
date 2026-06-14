//
//  NavigatorMusicPlayerView.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 07.06.2026.
//

import Foundation
import UIKit

protocol NavigatorMusicControlDelegate: AnyObject {
    func didTapNext()
    func didTapPrevios()
    func didTapPlayPause()
    func didTapSourceButton()
}

final class NavigatorMusicPlayerView: UIView {
    private lazy var imageView = makeImageView()
    private lazy var dropDownButton = makeDropDownButton()
    private lazy var titleLabel = makeLabel()
    private lazy var subtitleLabel = makeLabel()
    private lazy var textStack = makeTextStack()
    private lazy var buttonsStack = makeButtonsStack()
    private lazy var playButton = makeControlButton()
    private lazy var nextButton = makeControlButton()
    private lazy var previousButton = makeControlButton()
    
    private var imageLoadTask: Task<Void, Never>?
    
    weak var delegate: NavigatorMusicControlDelegate?
    
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
private extension NavigatorMusicPlayerView {
    func initialize() {
        layer.cornerRadius = 10.landscapeHScale
        [previousButton, playButton, nextButton].forEach { button in
            buttonsStack.addArrangedSubview(button)
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: 48.landscapeVScale),
                button.widthAnchor.constraint(equalTo: button.heightAnchor)
            ])
            button.layer.cornerRadius = 48.landscapeVScale / 2
            button.clipsToBounds = true
        }
        
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(subtitleLabel)
        
        previousButton.setImage(UIImage(named: "Player.Previous"), for: .normal)
        previousButton.addTarget(self, action: #selector(tapPrevios), for: .touchUpInside)
        previousButton.tintColor = Appearance.color_FFFFFF
        
        nextButton.setImage(UIImage(named: "Player.Next"), for: .normal)
        nextButton.addTarget(self, action: #selector(tapNext), for: .touchUpInside)
        nextButton.tintColor = Appearance.color_FFFFFF
        
        playButton.addTarget(self, action: #selector(tapPlayPause), for: .touchUpInside)
        playButton.tintColor = Appearance.color_FFFFFF
        
        dropDownButton.addTarget(self, action: #selector(didTapSource), for: .touchUpInside)
    }
    
    @objc func tapNext() {
        delegate?.didTapNext()
    }
    
    @objc func tapPrevios() {
        delegate?.didTapPrevios()
    }
    
    @objc func tapPlayPause() {
        delegate?.didTapPlayPause()
    }
    
    @objc func didTapSource() {
        delegate?.didTapSourceButton()
    }
}

// MARK: Public
extension NavigatorMusicPlayerView {
    func setupState(model: PlaybackModel?) {
        let playImage = model?.isPlaying == true ? UIImage(named: "Player.Pause") : UIImage(named: "Player.Play")
        playButton.setImage(playImage, for: .normal)
    }
    
    func setupTrackInfo(model: TrackModel?, source: MusicSource) {
        if let model {
            titleLabel.attributedText = (model.title ?? "").attributed(with: .title)
            subtitleLabel.attributedText = model.subtitle?.attributed(with: .subtitle)
            subtitleLabel.isHidden = model.subtitle == nil
        } else {
            titleLabel.attributedText = "MiniPlayer.NotPlaying".localized.attributed(with: .title)
            subtitleLabel.isHidden = true
        }
        
        dropDownButton.setMusicSource(source)
        
        imageLoadTask?.cancel()
        imageView.image = UIImage(named: source.iconName)
        
        if let url = model?.artwork {
            imageLoadTask = Task { [weak self] in
                guard let (data, _) = try? await URLSession.shared.data(from: url),
                      !Task.isCancelled
                else { return }
                
                let image = UIImage(data: data) ?? UIImage(named: source.iconName)
                await MainActor.run {
                    self?.imageView.image = image
                }
            }
        } else {
            imageView.image = UIImage(named: source.iconName)
        }
    }
}

// MARK: Make constraints
private extension NavigatorMusicPlayerView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 52.landscapeVScale),
            imageView.widthAnchor.constraint(equalToConstant: 52.landscapeVScale),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.landscapeHScale),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 16.landscapeVScale)
        ])
        
        NSLayoutConstraint.activate([
            dropDownButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            dropDownButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.landscapeHScale)
        ])
        
        NSLayoutConstraint.activate([
            textStack.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            textStack.trailingAnchor.constraint(equalTo: dropDownButton.trailingAnchor),
            textStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            buttonsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.landscapeVScale),
            buttonsStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonsStack.topAnchor.constraint(lessThanOrEqualTo: textStack.bottomAnchor, constant: 12.landscapeVScale)
        ])
    }
}

// MARK: Lazy initialization
private extension NavigatorMusicPlayerView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 10.landscapeVScale
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDropDownButton() -> DropdownButtonView {
        let view = DropdownButtonView(type: .text)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 1
        return view
    }
    
    func makeTextStack() -> UIStackView {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 2.landscapeVScale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButtonsStack() -> UIStackView {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 28.landscapeHScale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeControlButton() -> UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

private extension TextAttributes {
    static let title = TextAttributes()
        .font(Fonts.Inter.bold(size: 24.landscapeVScale))
        .textColor(Appearance.color_FFFFFF)
        .textAlignment(.left)
    
    static let subtitle = TextAttributes()
        .font(Fonts.Inter.medium(size: 16.landscapeVScale))
        .textColor(Appearance.color_FFFFFF.withAlphaComponent(0.6))
        .textAlignment(.left)
}
