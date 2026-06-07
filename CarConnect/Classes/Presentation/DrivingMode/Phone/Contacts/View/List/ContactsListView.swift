//
//  ContactsListView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.06.2026.
//

import UIKit

final class ContactsListView: UIView {
    lazy var searchField = makeSearchField()
    lazy var tableView = makeTableView()
    
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
private extension ContactsListView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension ContactsListView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            searchField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.landscapeHScale),
            searchField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50.landscapeHScale),
            searchField.topAnchor.constraint(equalTo: topAnchor, constant: 16.landscapeVScale),
            searchField.heightAnchor.constraint(equalToConstant: 40.landscapeVScale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.landscapeHScale),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 2.landscapeVScale),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ContactsListView {
    func makeSearchField() -> SearchContactField {
        let view = SearchContactField()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> ContactsTableView {
        let view = ContactsTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
