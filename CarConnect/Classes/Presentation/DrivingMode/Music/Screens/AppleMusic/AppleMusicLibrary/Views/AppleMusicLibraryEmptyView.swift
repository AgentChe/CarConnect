//
//  AppleMusicLibraryEmptyView.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 29.03.2026.
//

import UIKit

final class AppleMusicLibraryEmptyView: UIView {
    private lazy var labelsStackView = makeLabelsStackView()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var subtitleLable = makeSubtitleLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AppleMusicLibraryEmptyView {
    func setup(for category: AppleMusicLibraryCategory) {
        titleLabel.attributedText = category.emptyTitle.attributed(with: .title)
    }
}

// MARK: Private
private extension AppleMusicLibraryEmptyView {
    func initialize() {
        backgroundColor = .clear
    }
}

// MARK: Make constraints
private extension AppleMusicLibraryEmptyView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: topAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelsStackView.widthAnchor.constraint(equalToConstant: 376.landscapeHScale)
        ])
    }
}

// MARK: Lazy initialization
private extension AppleMusicLibraryEmptyView {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 1
        return view
    }
    
    func makeSubtitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.regular(size: 18.landscapeVScale))
            .lineHeight(24.landscapeVScale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "AppleMusic.EmptyLibrary.Subtitle".localized.attributed(with: attrs)
        return view
    }
    
    func makeLabelsStackView() -> UIStackView {
        let view = UIStackView(arrangedSubviews: [titleLabel, subtitleLable])
        view.spacing = 8.landscapeVScale
        view.axis = .vertical
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

private extension TextAttributes {
    static let title = TextAttributes()
        .textColor(Appearance.color_FFFFFF)
        .font(Fonts.Inter.bold(size: 24.landscapeVScale))
        .lineHeight(32.landscapeVScale)
        .textAlignment(.center)
}
