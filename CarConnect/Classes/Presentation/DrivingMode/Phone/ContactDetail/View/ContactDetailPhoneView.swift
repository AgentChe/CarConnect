//
//  ContactDetailPhoneView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.06.2026.
//

import UIKit

final class ContactDetailPhoneView: UIView {
    var didTap: (() -> Void)?

    lazy var numberLabel = makeNumberLabel()
    lazy var captionLabel = makeCaptionLabel()

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
extension ContactDetailPhoneView {
    func setup(phone: ContactsTableElement.Phone) {
        let numberAttrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.bold(size: 24.landscapeHScale))
            .textAlignment(.left)
        numberLabel.attributedText = phone.number.attributed(with: numberAttrs)

        let captionAttrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF.withAlphaComponent(0.6))
            .font(Fonts.Inter.medium(size: 16.landscapeHScale))
            .textAlignment(.left)
        captionLabel.attributedText = phone.label.attributed(with: captionAttrs)
    }
}

// MARK: Private
private extension ContactDetailPhoneView {
    func initialize() {
        backgroundColor = UIColor.clear

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }

    @objc
    func tapped() {
        didTap?()
    }
}

// MARK: Make constraints
private extension ContactDetailPhoneView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            numberLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            numberLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            numberLabel.topAnchor.constraint(equalTo: topAnchor)
        ])

        NSLayoutConstraint.activate([
            captionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            captionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            captionLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 4.landscapeVScale),
            captionLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ContactDetailPhoneView {
    func makeNumberLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }

    func makeCaptionLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
