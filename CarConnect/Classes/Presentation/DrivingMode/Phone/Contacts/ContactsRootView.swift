//
//  ContactsRootView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.06.2026.
//

import UIKit

final class ContactsRootView: UIView {
    enum State {
        case list
        case unlock
    }
    
    lazy var listView = ContactsListView()
    lazy var unlockView = UnlockContactsView()
    
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
extension ContactsRootView {
    func setup(state: State) {
        subviews.forEach { $0.removeFromSuperview() }
        
        let contentView: UIView = {
            switch state {
            case .list:
                return listView
            case .unlock:
                return unlockView
            }
        }()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        switch state {
        case .list:
            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
                contentView.topAnchor.constraint(equalTo: topAnchor),
                contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        case .unlock:
            NSLayoutConstraint.activate([
                contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
                contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
                contentView.widthAnchor.constraint(equalToConstant: 408.landscapeHScale),
                contentView.heightAnchor.constraint(equalToConstant: 191.landscapeHScale)
            ])
        }
    }
}

// MARK: Private
private extension ContactsRootView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension ContactsRootView {
    func makeConstraints() {
        
    }
}

// MARK: Lazy initialization
private extension ContactsRootView {
    
}
