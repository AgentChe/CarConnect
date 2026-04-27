//
//  DropdownButtonView.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 17.04.2026.
//

import UIKit

final class DropdownButtonView: UIButton {
    private lazy var iconView = makeIconView()
    private lazy var arrowIcon = makeArrowIconView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        iconView.image = UIImage(named: source.iconName)
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
