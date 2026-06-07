//
//  PhoneTabView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.06.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class PhoneTabView: UIView {
    lazy var contactsButton = makeItemButton(item: .contacts)
    lazy var keypadButton = makeItemButton(item: .keypad)
    
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
extension PhoneTabView {
    func setup(selected item: PhoneTabItemView.Item) {
        contactsButton.setup(selected: item == .contacts)
        keypadButton.setup(selected: item == .keypad)
    }
    
    var didTap: Signal<PhoneTabItemView.Item> {
        Signal
            .merge(
                contactsButton.rx.tap
                    .compactMap { [weak self] in self?.contactsButton.item }
                    .asSignal(onErrorJustReturn: .contacts),
                keypadButton.rx.tap
                    .compactMap { [weak self] in self?.keypadButton.item }
                    .asSignal(onErrorJustReturn: .keypad),
            )
    }
}

// MARK: Private
private extension PhoneTabView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension PhoneTabView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            contactsButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            contactsButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            contactsButton.topAnchor.constraint(equalTo: topAnchor),
            contactsButton.heightAnchor.constraint(equalToConstant: 112.landscapeHScale)
        ])
        
        NSLayoutConstraint.activate([
            keypadButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            keypadButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            keypadButton.topAnchor.constraint(equalTo: contactsButton.bottomAnchor),
            keypadButton.heightAnchor.constraint(equalToConstant: 112.landscapeHScale)
        ])
    }
}

// MARK: Lazy initialization
private extension PhoneTabView {
    func makeItemButton(item: PhoneTabItemView.Item) -> PhoneTabItemView {
        let view = PhoneTabItemView(item: item)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
