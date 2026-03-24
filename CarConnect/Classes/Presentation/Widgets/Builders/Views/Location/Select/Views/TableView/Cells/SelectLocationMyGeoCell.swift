//
//  SelectLocationMyGeoCell.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 23.03.2026.
//

import UIKit

final class SelectLocationMyGeoCell: UITableViewCell {
    lazy var titleLabel = makeTitleLabel()
    lazy var container = makeContainer()
    lazy var nameLabel = makeNameLabel()
    lazy var geoIconView = makeGeoIconView()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.color_FFFFFF)
        .font(Fonts.Inter.regular(size: 16.scale))
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    
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
extension SelectLocationMyGeoCell {
    func setup(element: Location) {
        nameLabel.attributedText = element.name.attributed(with: attrs)
    }
}

// MARK: Private
private extension SelectLocationMyGeoCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension SelectLocationMyGeoCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 64.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -48.scale),
            nameLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            geoIconView.widthAnchor.constraint(equalToConstant: 24.scale),
            geoIconView.heightAnchor.constraint(equalToConstant: 24.scale),
            geoIconView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            geoIconView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SelectLocationMyGeoCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF.withAlphaComponent(0.4))
            .font(Fonts.Inter.regular(size: 14.scale))
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "WidgetsBuilders.Location.MyGeo.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.color_2C2F39
        view.layer.cornerRadius = 12.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeNameLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeGeoIconView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "WidgetsBuilders.Geo")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
