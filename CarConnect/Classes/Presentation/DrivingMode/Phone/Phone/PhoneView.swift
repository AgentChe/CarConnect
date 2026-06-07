//
//  PhoneView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.06.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class PhoneView: UIView {
    lazy var tabView = makeTabView()
    lazy var container = makeContainer()
    
    private lazy var contactsView = ContactsView()
    private lazy var keypadView = KeypadView()
    
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
extension PhoneView {
    func setup(selected item: PhoneTabItemView.Item) {
        tabView.setup(selected: item)
        
        container.subviews.forEach { $0.removeFromSuperview() }
        
        let contentView: UIView = {
            switch item {
            case .contacts:
                return contactsView
            case .keypad:
                return keypadView
            }
        }()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: container.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
    
    var didSelectContact: Signal<ContactsTableElement> {
        contactsView.didSelectContact
    }
}

// MARK: Private
private extension PhoneView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension PhoneView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tabView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabView.topAnchor.constraint(equalTo: topAnchor, constant: 20.landscapeVScale),
            tabView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.landscapeVScale),
            tabView.widthAnchor.constraint(equalToConstant: 140.landscapeHScale)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: tabView.trailingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor, constant: 20.landscapeVScale),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.landscapeVScale)
        ])
    }
}

// MARK: Lazy initialization
private extension PhoneView {
    func makeTabView() -> PhoneTabView {
        let view = PhoneTabView()
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
}
