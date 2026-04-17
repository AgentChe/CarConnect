//
//  AppleMusicMainItemCell.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 25.03.2026.
//

import UIKit

final class AppleMusicMainItemCell: UICollectionViewCell {
    static let reuseID = "AppleMusicMainItemCell"
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadTask?.cancel()
    }
}

extension AppleMusicMainItemCell {
    func setup(item: AppleMusicLibraryRecentItem) {
        titleLabel.attributedText = item.title.attributed(with: .title)
        subtitleLabel.attributedText = item.type.title.attributed(with: .subtitle)
        
        guard let url = item.artworkURL else { return }

        imageLoadTask = Task { [weak self] in
            guard let (data, _) = try? await URLSession.shared.data(from: url),
                  !Task.isCancelled
            else { return }
            
            let image = UIImage(data: data) ?? UIImage(systemName: "music.note")
            await MainActor.run {
                self?.imageView.image = image
            }
        }
    }
}

// MARK: Private
private extension AppleMusicMainItemCell {
    func initialize() {
        
    }
}

// MARK: Make constraints
private extension AppleMusicMainItemCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 100.landscapeVScale),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8.landscapeVScale),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.landscapeVScale),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension AppleMusicMainItemCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(systemName: "music.note")
        view.tintColor = .tertiaryLabel
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 10.landscapeHScale
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.backgroundColor = Appearance.color_0D0E11
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeSubtitleLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

private extension TextAttributes {
    static let title = TextAttributes()
        .font(Fonts.Inter.medium(size: 16.landscapeVScale))
        .lineHeight(19.landscapeVScale)
        .textColor(Appearance.color_FFFFFF)
        .textAlignment(.left)
    
    static let subtitle = TextAttributes()
        .font(Fonts.Inter.medium(size: 16.landscapeVScale))
        .lineHeight(19.landscapeVScale)
        .textColor(Appearance.color_FFFFFF.withAlphaComponent(0.6))
        .textAlignment(.left)
}
