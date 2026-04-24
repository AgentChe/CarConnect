//
//  MusicSourceButton.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 24.04.2026.
//

import UIKit

class MusicSourceButton: UIButton {
    private lazy var iconView = makeIconView()
    private lazy var label = makeTitleLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension MusicSourceButton {
    func setup(source: MusicSource) {
        iconView.image = UIImage(named: source.iconName)
        label.attributedText = source.title.attributed(with: .title)
    }
}

// MARK: Private
private extension MusicSourceButton {
    func initialize() {
        backgroundColor = .clear
    }
}

// MARK: Make constraints
private extension MusicSourceButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 62.landscapeVScale),
            iconView.widthAnchor.constraint(equalToConstant: 62.landscapeVScale),
            iconView.topAnchor.constraint(equalTo: topAnchor),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 8.landscapeVScale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 150.landscapeHScale)
        ])
    }
}

// MARK: Lazy initialization
private extension MusicSourceButton {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 1
        addSubview(view)
        return view
    }
}

private extension TextAttributes {
    static let title = TextAttributes()
        .font(Fonts.Inter.bold(size: 24))
        .lineHeight(34)
        .textColor(Appearance.color_FFFFFF)
        .textAlignment(.center)
}
