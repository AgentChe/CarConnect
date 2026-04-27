//
//  BackButton.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 19.04.2026.
//

import UIKit

class BackButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        let icon = UIImage(named: "Navigation.ArrowLeft")
        setImage(icon, for: .normal)
        
        tintColor = Appearance.color_FFFFFF
        backgroundColor = Appearance.color_FFFFFF.withAlphaComponent(0.1)
        layer.cornerRadius = 25.landscapeVScale
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 50.landscapeVScale),
            widthAnchor.constraint(equalTo: heightAnchor)
        ])
    }
}



final class NavigationView: UIView {
    lazy var backButton = makeBackButton()
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

// MARK: Public
extension NavigationView {
    func setTitle(_ title: String) {
        titleLabel.attributedText = title.attributed(with: .title)
    }
}

// MARK: Private
private extension NavigationView {
    func initialize() {
        backgroundColor = Appearance.color_080A0C
    }
}

// MARK: Make constraints
private extension NavigationView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: 19.landscapeVScale),
            backButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4.landscapeVScale),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 10.landscapeHScale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -108.landscapeHScale),
        ])
    }
}

// MARK: Lazy initialization
private extension NavigationView {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBackButton() -> UIButton {
        let view = BackButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

private extension TextAttributes {
    static let title = TextAttributes()
        .font(Fonts.Inter.bold(size: 24.landscapeVScale))
        .textAlignment(.center)
        .textColor(Appearance.color_FFFFFF)
}
