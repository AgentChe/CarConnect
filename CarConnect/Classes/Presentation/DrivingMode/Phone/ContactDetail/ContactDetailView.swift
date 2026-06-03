//
//  ContactDetailView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.06.2026.
//

import UIKit

final class ContactDetailView: UIView {
    var didSelectPhone: ((ContactsTableElement.Phone) -> Void)?

    lazy var backButton = makeBackButton()
    lazy var avatarView = makeAvatarView()
    lazy var nameLabel = makeNameLabel()
    lazy var phonesStackView = makePhonesStackView()

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
extension ContactDetailView {
    func setup(contact: ContactsTableElement) {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.bold(size: 24.landscapeHScale))
            .textAlignment(.left)
        nameLabel.attributedText = contact.name.attributed(with: attrs)

        phonesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        contact.phones.forEach { phone in
            let view = ContactDetailPhoneView()
            view.setup(phone: phone)
            view.didTap = { [weak self] in
                self?.didSelectPhone?(phone)
            }
            phonesStackView.addArrangedSubview(view)
        }
    }
}

// MARK: Private
private extension ContactDetailView {
    func initialize() {
        backgroundColor = Appearance.color_080A0C
    }
}

// MARK: Make constraints
private extension ContactDetailView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: 19.landscapeVScale),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.landscapeHScale)
        ])

        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalToConstant: 64.landscapeHScale),
            avatarView.heightAnchor.constraint(equalToConstant: 64.landscapeHScale),
            avatarView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 24.landscapeVScale),
            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.landscapeHScale)
        ])

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 20.landscapeHScale),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16.landscapeHScale),
            nameLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            phonesStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.landscapeHScale),
            phonesStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16.landscapeHScale),
            phonesStackView.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 32.landscapeVScale)
        ])
    }
}

// MARK: Lazy initialization
private extension ContactDetailView {
    func makeBackButton() -> UIButton {
        let view = BackButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }

    func makeAvatarView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "DrivingMode.Phone.Contact.Placeholder")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }

    func makeNameLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }

    func makePhonesStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 20.landscapeVScale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
