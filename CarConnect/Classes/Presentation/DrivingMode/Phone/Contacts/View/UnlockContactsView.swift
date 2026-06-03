//
//  UnlockContactsView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.06.2026.
//

import UIKit

final class UnlockContactsView: UIView {
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
private extension UnlockContactsView {
    func initialize() {
        backgroundColor = Appearance.color_0D0E11.withAlphaComponent(0.7)
        layer.cornerRadius = 10.landscapeHScale
    }
}

// MARK: Make constraints
private extension UnlockContactsView {
    func makeConstraints() {
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
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.landscapeVScale)
        ])

        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 54.landscapeHScale),
            actionButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -54.landscapeHScale),
            actionButton.heightAnchor.constraint(equalToConstant: 60.landscapeVScale),
            actionButton.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 24.landscapeVScale),
            actionButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension UnlockContactsView {
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
        view.attributedText = "Phone.UnlockContacts.Title".localized.attributed(with: attrs)
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
        view.attributedText = "Phone.UnlockContacts.SubTitle".localized.attributed(with: attrs)
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
        view.setAttributedTitle("Phone.UnlockContacts.Action".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
