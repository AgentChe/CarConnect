//
//  AppleMusicMainSectionHeaderView.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 25.03.2026.
//

import UIKit

final class AppleMusicMainSectionHeaderView: UICollectionReusableView {
    static let reuseID = "AppleMusicMainSectionHeaderView"
    
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

extension AppleMusicMainSectionHeaderView {
    func setup(_ type: AppleMusicLibrarySection) {
        titleLabel.attributedText = type.title.attributed(with: .title)
    }
}

// MARK: Private
private extension AppleMusicMainSectionHeaderView {
    func initialize() {
        backgroundColor = .clear
    }
}

// MARK: Make constraints
private extension AppleMusicMainSectionHeaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension AppleMusicMainSectionHeaderView {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
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
