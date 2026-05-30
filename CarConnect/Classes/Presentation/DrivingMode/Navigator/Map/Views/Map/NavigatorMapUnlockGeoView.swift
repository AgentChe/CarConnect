//
//  NavigatorMapUnlockGeoView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.05.2026.
//

import UIKit

final class NavigatorMapUnlockGeoView: UIView {
    var didTapAction: (() -> Void)?
    
    lazy var backgroundView = makeBackgroundView()
    lazy var container = makeContainer()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var actionButton = makeActionButton()
    
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
private extension NavigatorMapUnlockGeoView {
    func initialize() {
        layer.cornerRadius = 10.landscapeHScale
    }
    
    @objc
    func actionTapped() {
        didTapAction?()
    }
}

// MARK: Make constraints
private extension NavigatorMapUnlockGeoView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.landscapeVScale)
        ])
        
        NSLayoutConstraint.activate([
            actionButton.widthAnchor.constraint(equalToConstant: 299.landscapeHScale),
            actionButton.heightAnchor.constraint(equalToConstant: 60.landscapeVScale),
            actionButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            actionButton.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 24.landscapeVScale),
            actionButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension NavigatorMapUnlockGeoView {
    func makeBackgroundView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 10.landscapeHScale
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Navigator.UnlockGeoBack")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.bold(size: 24.landscapeHScale))
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Navigator.UnlockGeo.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF.withAlphaComponent(0.8))
            .font(Fonts.Inter.regular(size: 18.landscapeHScale))
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Navigator.UnlockGeo.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeActionButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.bold(size: 20.landscapeHScale))
        
        let view = UIButton()
        view.backgroundColor = Appearance.color_4178F6
        view.layer.cornerRadius = 10.landscapeHScale
        view.setAttributedTitle("Navigator.UnlockGeo.Action".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        container.addSubview(view)
        return view
    }
}
