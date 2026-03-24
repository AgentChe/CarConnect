//
//  SelectLocationCell.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 24.03.2026.
//

import UIKit

final class SelectLocationCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var nameLabel = makeLabel()
    lazy var checkedView = makeCheckedView()
    lazy var separator = makeSeparator()
    
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
extension SelectLocationCell {
    func setup(element: SelectLocationElement) {
        nameLabel.attributedText = element.location.name.attributed(with: attrs)
        checkedView.isHidden = !element.checked
        separator.isHidden = element.separatorHidden
        container.layer.cornerRadius = (element.corneredTop || element.corneredBottom) ? 12.scale : 0
        container.layer.maskedCorners = {
            if element.corneredTop {
                return [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else if element.corneredBottom {
                return [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
            return []
        }()
    }
}

// MARK: Private
private extension SelectLocationCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension SelectLocationCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -48.scale),
            nameLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            checkedView.widthAnchor.constraint(equalToConstant: 24.scale),
            checkedView.heightAnchor.constraint(equalToConstant: 24.scale),
            checkedView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            checkedView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12.scale),
            separator.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12.scale),
            separator.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SelectLocationCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.color_2C2F39
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeCheckedView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "WidgetsBuilders.ItemChecked")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.color_868EB2.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
