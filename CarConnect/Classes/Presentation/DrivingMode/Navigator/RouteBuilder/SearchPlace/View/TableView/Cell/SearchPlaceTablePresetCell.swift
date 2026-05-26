//
//  SearchPlaceTablePresetCell.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 26.05.2026.
//

import UIKit

final class SearchPlaceTablePresetCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var iconContainer = makeIconContainer()
    lazy var iconView = makeIconView()
    lazy var nameLabel = makeNameLabel()
    
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.color_FFFFFF)
        .font(Fonts.Inter.bold(size: 20.landscapeHScale))
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
extension SearchPlaceTablePresetCell {
    func setup(element: NavigatorPreset) {
        let iconName: String = {
            switch element {
            case .parking:
                return "Navigator.Preset.Parking"
            case .gasStation:
                return "Navigator.Preset.GasStation"
            case .carRepair:
                return "Navigator.Preset.CarRepair"
            case .atm:
                return "Navigator.Preset.ATM"
            case .hospital:
                return "Navigator.Preset.Hospital"
            case .pharmacy:
                return "Navigator.Preset.Pharmacy"
            case .restaurant:
                return "Navigator.Preset.Restaurant"
            }
        }()
        iconView.image = UIImage(named: iconName)
        
        let name: String = {
            switch element {
            case .parking:
                return "Navigator.Preset.Parking".localized
            case .gasStation:
                return "Navigator.Preset.GasStation".localized
            case .carRepair:
                return "Navigator.Preset.CarRepair".localized
            case .atm:
                return "Navigator.Preset.ATM".localized
            case .hospital:
                return "Navigator.Preset.Hospital".localized
            case .pharmacy:
                return "Navigator.Preset.Pharmacy".localized
            case .restaurant:
                return "Navigator.Preset.Restaurant".localized
            }
        }()
        nameLabel.attributedText = name.attributed(with: nameAttrs)
    }
}

// MARK: Private
private extension SearchPlaceTablePresetCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension SearchPlaceTablePresetCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.landscapeVScale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.landscapeVScale)
        ])
        
        NSLayoutConstraint.activate([
            iconContainer.widthAnchor.constraint(equalToConstant: 50.landscapeHScale),
            iconContainer.heightAnchor.constraint(equalToConstant: 50.landscapeHScale),
            iconContainer.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.landscapeHScale)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.landscapeHScale),
            iconView.heightAnchor.constraint(equalToConstant: 24.landscapeHScale),
            iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 78.landscapeHScale),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.landscapeHScale),
            nameLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.landscapeVScale),
            nameLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16.landscapeVScale)
        ])
    }
}

// MARK: Lazy initialization
private extension SearchPlaceTablePresetCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeIconContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 25.landscapeHScale
        view.backgroundColor = Appearance.color_FFFFFF.withAlphaComponent(0.16)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.addSubview(view)
        return view
    }
    
    func makeNameLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
