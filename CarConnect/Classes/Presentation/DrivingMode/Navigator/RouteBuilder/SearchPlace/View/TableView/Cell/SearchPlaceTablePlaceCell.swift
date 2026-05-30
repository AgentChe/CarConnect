//
//  SearchPlaceTablePlaceCell.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 26.05.2026.
//

import UIKit

final class SearchPlaceTablePlaceCell: UITableViewCell {
    lazy var nameLabel = makeLabel()
    lazy var addressLabel = makeLabel()
    
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.color_FFFFFF)
        .font(Fonts.Inter.bold(size: 20.landscapeHScale))
        .textAlignment(.left)
    private lazy var addressAttrs = TextAttributes()
        .textColor(Appearance.color_FFFFFF.withAlphaComponent(0.6))
        .font(Fonts.Inter.medium(size: 16.landscapeHScale))
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
extension SearchPlaceTablePlaceCell {
    func setup(element: NavigatorPlace) {
        nameLabel.attributedText = element.name.attributed(with: nameAttrs)
        addressLabel.attributedText = element.address.attributed(with: addressAttrs)
    }
}

// MARK: Private
private extension SearchPlaceTablePlaceCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension SearchPlaceTablePlaceCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.landscapeHScale),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.landscapeHScale),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.landscapeVScale)
        ])
        
        NSLayoutConstraint.activate([
            addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.landscapeHScale),
            addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.landscapeHScale),
            addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5.landscapeVScale),
            addressLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.landscapeVScale)
        ])
    }
}

// MARK: Lazy initialization
private extension SearchPlaceTablePlaceCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
