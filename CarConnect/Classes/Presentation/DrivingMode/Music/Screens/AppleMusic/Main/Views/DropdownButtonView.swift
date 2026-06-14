//
//  DropdownButtonView.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 17.04.2026.
//

import UIKit

final class DropdownButtonView: UIButton {
    
    enum ButtonType {
        case image
        case text
    }
    
    private lazy var iconView = makeIconView()
    private lazy var arrowIcon = makeArrowIconView()
    private lazy var labelView = makeLabel()
    
    private let type: ButtonType
    
    init(type: ButtonType) {
        self.type = type
        super.init(frame: .zero)
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isExpanded: Bool = false {
        didSet {
            updateState()
        }
    }
    
    func setMusicSource(_ source: MusicSource) {
        switch type {
        case .image:
            iconView.image = UIImage(named: source.iconName)
        case .text:
            labelView.attributedText = source.title.attributed(with: .text)
        }
    }
}

// MARK: Private
private extension DropdownButtonView {
    func initialize() {
        backgroundColor = Appearance.color_FFFFFF.withAlphaComponent(0.1)
        layer.masksToBounds = true
        clipsToBounds = true
        layer.cornerRadius = 24.landscapeVScale
    }
    
    func updateState() {
        UIView.animate(withDuration: 0.2) {
            self.arrowIcon.transform = self.isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
        }
    }
}

// MARK: Make constraints
private extension DropdownButtonView {
    func makeConstraints() {
        switch type {
        case .image:
            imageLayout()
        case .text:
            textLayout()
        }
    }
    
    func textLayout() {
        NSLayoutConstraint.activate([
            labelView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.landscapeHScale),
            labelView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            arrowIcon.heightAnchor.constraint(equalToConstant: 24.landscapeVScale),
            arrowIcon.widthAnchor.constraint(equalTo: arrowIcon.heightAnchor),
            arrowIcon.centerYAnchor.constraint(equalTo: labelView.centerYAnchor),
            arrowIcon.leadingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: 4.landscapeHScale),
            arrowIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.landscapeHScale)
        ])
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 40.landscapeVScale)
        ])
    }
    
    func imageLayout() {
        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 32.landscapeVScale),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.landscapeHScale)
        ])
        
        NSLayoutConstraint.activate([
            arrowIcon.heightAnchor.constraint(equalToConstant: 24.landscapeVScale),
            arrowIcon.widthAnchor.constraint(equalTo: arrowIcon.heightAnchor),
            arrowIcon.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            arrowIcon.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 4.landscapeHScale),
            arrowIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.landscapeHScale)
        ])
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 48.landscapeVScale)
        ])
    }
}

// MARK: Lazy initialization
private extension DropdownButtonView {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeArrowIconView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Navigation.ArrowDown")
        view.contentMode = .scaleAspectFit
        view.tintColor = Appearance.color_FFFFFF
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

private extension TextAttributes {
    static let text = TextAttributes()
        .font(Fonts.Inter.medium(size: 16.landscapeVScale))
        .textColor(Appearance.color_FFFFFF)
        .textAlignment(.left)
}
