//
//  AppleMusicMainCategoryItemCell.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 25.03.2026.
//

import UIKit

final class AppleMusicMainCategoryItemCell: UICollectionViewCell {
    static let reuseID = "AppleMusicMainCategoryItemCell"
    
    private lazy var containerView = makeContainer()
    private lazy var imageView = makeImageView()
    private lazy var titleLabel = makeTitleLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AppleMusicMainCategoryItemCell {
    func setup(category: AppleMusicLibraryCategory) {
        imageView.image = UIImage(named: category.iconName)
        titleLabel.attributedText = category.title.attributed(with: .title)
    }
}

// MARK: Private
private extension AppleMusicMainCategoryItemCell {
    func initialize() {
        contentView.backgroundColor = .clear
    }
}

// MARK: Make constraints
private extension AppleMusicMainCategoryItemCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 13.landscapeVScale),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.landscapeHScale),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -13.landscapeVScale),
            imageView.heightAnchor.constraint(equalToConstant: 32.landscapeVScale),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12.landscapeHScale),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12.landscapeHScale)
        ])
    }
}

// MARK: Lazy initialization
private extension AppleMusicMainCategoryItemCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.color_FFFFFF.withAlphaComponent(0.16)
        view.layer.cornerRadius = 10.landscapeHScale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.tintColor = Appearance.color_FFFFFF
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
}

private extension TextAttributes {
    static let title = TextAttributes()
        .font(Fonts.Inter.bold(size: 24.landscapeVScale))
        .lineHeight(34.landscapeVScale)
        .textColor(Appearance.color_FFFFFF)
        .textAlignment(.left)
}
