//
//  AppleMusicPlaylistCell.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 04.04.2026.
//

import UIKit
import MusicKit
import RiveRuntime
import Kingfisher

final class AppleMusicCollectionCell: UICollectionViewCell {
    static let resuseID = "AppleMusicCollectionCell"
    
    private lazy var stackView = makeLabelStack()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var subtitleLabel = makeSubtitleLabel()
    private lazy var contentImage = makeImageView()
    private lazy var accesoryStackView = makeAccessoryStack()
    private lazy var moreImage = makeMoreImageView()
    private lazy var animationView = makeAnimationView()
    private lazy var animationViewModel = RiveViewModel(fileName: "nowplaying")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentImage.kf.cancelDownloadTask()
        contentImage.image = nil
        animationViewModel.reset()
    }
    
    func setup(for item: CollectionType) {
        switch item {
        case .playlist(let playlist):
            setup(title: playlist.name, subtitle: playlist.curatorName, isPlaying: false)
            setupArtwork(artwork: playlist.artwork, category: .playlists)
            setupAccessory(isPlaying: false, hasMore: true)
        case .album(let album):
            setup(title: album.title, subtitle: album.artistName, isPlaying: false)
            setupArtwork(artwork: album.artwork, category: .albums)
            setupAccessory(isPlaying: false, hasMore: true)
        case .artist(let artist):
            setup(title: artist.name, subtitle: nil, isPlaying: false)
            setupArtwork(artwork: artist.artwork, category: .artists)
            setupAccessory(isPlaying: false, hasMore: true)
        case .track(let track, let isPlaying):
            setup(title: track.title, subtitle: track.artistName, isPlaying: isPlaying)
            setupArtwork(artwork: track.artwork, category: .songs)
            setupAccessory(isPlaying: isPlaying, hasMore: false)
        }
    }
    
    func setup(playlist: Playlist) {
        setup(title: playlist.name, subtitle: playlist.curatorName, isPlaying: false)
        setupArtwork(artwork: playlist.artwork, category: .playlists)
        setupAccessory(isPlaying: false, hasMore: true)
    }
    
    func setup(artist: Artist) {
        setup(title: artist.name, subtitle: nil, isPlaying: false)
        setupArtwork(artwork: artist.artwork, category: .artists)
        setupAccessory(isPlaying: false, hasMore: true)
    }
    
    func setup(album: Album) {
        setup(title: album.title, subtitle: album.artistName, isPlaying: false)
        setupArtwork(artwork: album.artwork, category: .albums)
        setupAccessory(isPlaying: false, hasMore: true)
    }
    
    func setup(track: Track, isPlaying: Bool) {
        setup(title: track.title, subtitle: track.artistName, isPlaying: isPlaying)
        setupArtwork(artwork: track.artwork, category: .songs)
        setupAccessory(isPlaying: isPlaying, hasMore: false)
    }
}

// MARK: Private
private extension AppleMusicCollectionCell {
    func initialize() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    func setup(title: String, subtitle: String?, isPlaying: Bool) {
        titleLabel.attributedText = title.attributed(with: isPlaying ? .playingTitle : .title)
        if let subtitle, !subtitle.isEmpty {
            subtitleLabel.attributedText = subtitle.attributed(with: .subtitle)
        }
        
        subtitleLabel.isHidden = subtitle == nil || subtitle?.isEmpty == true
    }
    
    func setupArtwork(artwork: Artwork?, category: AppleMusicLibraryCategory) {
        guard let url = artwork?.url(width: 60, height: 60) else { return }
        
        contentImage.contentMode = .center
        contentImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: category.iconName),
            options: [.transition(.fade(0.2))]
        ) { [weak self] result in
            if case .success = result {
                self?.contentImage.contentMode = .scaleAspectFit
            }
        }
    }
    
    func setupAccessory(isPlaying: Bool, hasMore: Bool) {
        moreImage.isHidden = !hasMore
        animationView.isHidden = !isPlaying
        if isPlaying {
            animationViewModel.play()
        } else {
            animationViewModel.reset()
        }
    }
}

// MARK: Make constraints
private extension AppleMusicCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            contentImage.heightAnchor.constraint(equalToConstant: 60.landscapeVScale),
            contentImage.widthAnchor.constraint(equalToConstant: 60.landscapeHScale),
            contentImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6.landscapeVScale),
            contentImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6.landscapeVScale)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(greaterThanOrEqualTo: contentImage.topAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentImage.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentImage.trailingAnchor, constant: 12.landscapeHScale),
            stackView.centerYAnchor.constraint(equalTo: contentImage.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            accesoryStackView.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 12.landscapeHScale),
            accesoryStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            accesoryStackView.centerYAnchor.constraint(equalTo: contentImage.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalToConstant: 32.landscapeVScale),
            animationView.widthAnchor.constraint(equalToConstant: 32.landscapeHScale),
            moreImage.heightAnchor.constraint(equalToConstant: 32.landscapeVScale),
            moreImage.widthAnchor.constraint(equalToConstant: 32.landscapeHScale),
        ])
    }
}

// MARK: Lazy initialization
private extension AppleMusicCollectionCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(systemName: "music.note")
        view.tintColor = Appearance.color_FFFFFF.withAlphaComponent(0.6)
        view.backgroundColor = Appearance.color_FFFFFF.withAlphaComponent(0.1)
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 10.landscapeHScale
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 1
        return view
    }
    
    func makeSubtitleLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 1
        return view
    }
    
    func makeLabelStack() -> UIStackView {
        let view = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 5.landscapeVScale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        contentView.addSubview(view)
        return view
    }
    
    func makeAccessoryStack() -> UIStackView {
        let view = UIStackView(arrangedSubviews: [animationView, moreImage])
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeAnimationView() -> UIView {
        let view = animationViewModel.createRiveView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeMoreImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Library.More")
        view.tintColor = Appearance.color_FFFFFF.withAlphaComponent(0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

private extension TextAttributes {
    static let title = TextAttributes()
        .font(Fonts.Inter.bold(size: 24.landscapeVScale))
        .lineHeight(32.landscapeVScale)
        .textColor(Appearance.color_FFFFFF)
        .textAlignment(.left)
    
    static let playingTitle = TextAttributes()
        .font(Fonts.Inter.bold(size: 24.landscapeVScale))
        .lineHeight(32.landscapeVScale)
        .textColor(Appearance.color_6C99FF)
        .textAlignment(.left)
    
    static let subtitle = TextAttributes()
        .font(Fonts.Inter.medium(size: 16.landscapeVScale))
        .lineHeight(19.landscapeVScale)
        .textColor(Appearance.color_FFFFFF.withAlphaComponent(0.6))
        .textAlignment(.left)
}
