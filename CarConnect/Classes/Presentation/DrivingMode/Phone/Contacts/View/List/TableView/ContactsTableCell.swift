//
//  ContactsTableCell.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.06.2026.
//

import UIKit

final class ContactsTableCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var placeholderView = makePlaceholderView()
    lazy var label = makeLabel()
    lazy var arrowView = makeArrowView()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.color_FFFFFF)
        .font(Fonts.Inter.bold(size: 24.landscapeHScale))
        .textAlignment(.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ContactsTableCell {
    func setup(element: ContactsTableElement) {
        label.attributedText = element.name.attributed(with: attrs)
    }
}

// MARK: Private
private extension ContactsTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ContactsTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6.landscapeVScale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6.landscapeVScale)
        ])
        
        NSLayoutConstraint.activate([
            placeholderView.widthAnchor.constraint(equalToConstant: 50.landscapeHScale),
            placeholderView.heightAnchor.constraint(equalToConstant: 50.landscapeHScale),
            placeholderView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 62.landscapeHScale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -40.landscapeHScale),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 8.landscapeVScale),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8.landscapeVScale)
        ])
        
        NSLayoutConstraint.activate([
            arrowView.widthAnchor.constraint(equalToConstant: 32.landscapeHScale),
            arrowView.heightAnchor.constraint(equalToConstant: 32.landscapeHScale),
            arrowView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            arrowView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ContactsTableCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makePlaceholderView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "DrivingMode.Phone.Contact.Placeholder")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeArrowView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "DrivingMode.Phone.Arrow")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
