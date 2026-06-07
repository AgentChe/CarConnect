//
//  KeypadView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.06.2026.
//

import UIKit

final class KeypadView: UIView {
    private lazy var numberLabel = makeNumberLabel()
    private lazy var backspaceButton = makeBackspaceButton()
    private lazy var gridView = makeGridView()
    private lazy var callButton = makeCallButton()

    private var number = "" {
        didSet {
            numberLabel.text = number
        }
    }

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
private extension KeypadView {
    func initialize() {
        backgroundColor = UIColor.clear
    }

    @objc
    func digitTapped(_ sender: KeypadButton) {
        number += sender.key
    }

    @objc
    func backspaceTapped() {
        guard !number.isEmpty else { return }

        number.removeLast()
    }

    @objc
    func callTapped() {
        guard !number.isEmpty else { return }

        let allowed = CharacterSet(charactersIn: "+0123456789*#")
        let sanitized = number.components(separatedBy: allowed.inverted).joined()

        guard
            !sanitized.isEmpty,
            let encoded = sanitized.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
            let url = URL(string: "tel://\(encoded)")
        else {
            return
        }

        UIApplication.shared.open(url)
    }
}

// MARK: Make constraints
private extension KeypadView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            gridView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.landscapeHScale),
            gridView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            backspaceButton.widthAnchor.constraint(equalToConstant: 40.landscapeVScale),
            backspaceButton.heightAnchor.constraint(equalToConstant: 40.landscapeVScale),
            backspaceButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.landscapeHScale),
            backspaceButton.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            numberLabel.leadingAnchor.constraint(equalTo: gridView.trailingAnchor, constant: 32.landscapeHScale),
            numberLabel.trailingAnchor.constraint(equalTo: backspaceButton.leadingAnchor, constant: -12.landscapeHScale),
            numberLabel.topAnchor.constraint(equalTo: gridView.topAnchor),
            numberLabel.heightAnchor.constraint(equalToConstant: 60.landscapeVScale)
        ])

        NSLayoutConstraint.activate([
            callButton.widthAnchor.constraint(equalToConstant: 72.landscapeVScale),
            callButton.heightAnchor.constraint(equalToConstant: 72.landscapeVScale),
            callButton.centerXAnchor.constraint(equalTo: numberLabel.centerXAnchor),
            callButton.bottomAnchor.constraint(equalTo: gridView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension KeypadView {
    func makeNumberLabel() -> UILabel {
        let view = UILabel()
        view.textColor = Appearance.color_FFFFFF
        view.font = Fonts.Inter.bold(size: 36.landscapeVScale)
        view.textAlignment = .right
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 28.0 / 36.0
        view.lineBreakMode = .byTruncatingHead
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }

    func makeBackspaceButton() -> UIButton {
        let configuration = UIImage.SymbolConfiguration(pointSize: 24.landscapeVScale, weight: .regular)

        let view = UIButton()
        view.tintColor = Appearance.color_FFFFFF
        view.setImage(UIImage(systemName: "delete.left", withConfiguration: configuration), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(backspaceTapped), for: .touchUpInside)
        addSubview(view)
        return view
    }

    func makeGridView() -> UIStackView {
        let keys = [
            ["1", "2", "3"],
            ["4", "5", "6"],
            ["7", "8", "9"],
            ["*", "0", "#"]
        ]

        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 12.landscapeVScale
        view.translatesAutoresizingMaskIntoConstraints = false

        keys.forEach { row in
            let rowView = UIStackView()
            rowView.axis = .horizontal
            rowView.alignment = .center
            rowView.spacing = 16.landscapeHScale

            row.forEach { key in
                let button = KeypadButton(key: key)
                button.addTarget(self, action: #selector(digitTapped(_:)), for: .touchUpInside)
                rowView.addArrangedSubview(button)
            }

            view.addArrangedSubview(rowView)
        }

        addSubview(view)
        return view
    }

    func makeCallButton() -> UIButton {
        let configuration = UIImage.SymbolConfiguration(pointSize: 30.landscapeVScale, weight: .medium)

        let view = UIButton()
        view.tintColor = Appearance.color_FFFFFF
        view.backgroundColor = Appearance.color_34C759
        view.layer.cornerRadius = 36.landscapeVScale
        view.setImage(UIImage(systemName: "phone.fill", withConfiguration: configuration), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(callTapped), for: .touchUpInside)
        addSubview(view)
        return view
    }
}
