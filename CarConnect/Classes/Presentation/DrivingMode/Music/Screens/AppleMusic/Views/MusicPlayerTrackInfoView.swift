//
//  MusicPlayerTrackInfoView.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 22.03.2026.
//

import UIKit
import Foundation

class MusicPlayerTrackInfoView: UIView {
    private lazy var imageView = makeImageView()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var subtitleLabel = makeSubtitleLabel()
    
    private var imageLoadTask: Task<Void, Never>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MusicPlayerTrackInfoView {
    func setup(title: String?, subtitle: String?, image: URL?) {
        titleLabel.attributedText = title?.attributed(with: .playerTitle)
        subtitleLabel.attributedText = subtitle?.attributed(with: .playerSubtitle)
        let placeholder = UIImage(named: AppleMusicLibraryCategory.songs.iconName)
        imageLoadTask?.cancel()
        imageView.image = placeholder
        
        if let url = image {
            imageLoadTask = Task { [weak self] in
                guard let (data, _) = try? await URLSession.shared.data(from: url),
                      !Task.isCancelled
                else { return }
                
                let image = UIImage(data: data) ?? placeholder
                await MainActor.run {
                    self?.imageView.image = image
                }
            }
        } else {
            imageView.image = placeholder
        }
    }
}

// MARK: Private
private extension MusicPlayerTrackInfoView {
    func initialize() {
        backgroundColor = .clear
    }
}

// MARK: Make constraints
private extension MusicPlayerTrackInfoView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 112.landscapeVScale),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16.landscapeHScale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 12.landscapeVScale),
            subtitleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension MusicPlayerTrackInfoView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 10.landscapeHScale
        view.layer.masksToBounds = true
        view.tintColor = Appearance.color_FFFFFF.withAlphaComponent(0.6)
        view.backgroundColor = Appearance.color_FFFFFF.withAlphaComponent(0.1)
        view.layer.borderColor = Appearance.color_FFFFFF.withAlphaComponent(0.16).cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubtitleLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 1
        view.layer.opacity = 0.6
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

private extension TextAttributes {
    static let playerTitle = TextAttributes()
        .font(Fonts.Inter.bold(size: 32.landscapeVScale))
        .lineHeight(38.landscapeVScale)
        .textColor(Appearance.color_FFFFFF)
        .textAlignment(.left)
    
    static let playerSubtitle = TextAttributes()
        .font(Fonts.Inter.medium(size: 16.landscapeVScale))
        .lineHeight(19.landscapeVScale)
        .textColor(Appearance.color_FFFFFF)
        .textAlignment(.left)
}
