//
//  WidgetsPresetsTemplateCarLogoCell.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 02.04.2026.
//

import UIKit

final class WidgetsPresetsTemplateCarLogoCell: UICollectionViewCell {
    lazy var logoView = makeLogoView()
    lazy var tagLabel = makePaddingLabel()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.color_FFFFFF)
        .font(Fonts.Inter.semiBold(size: 14.scale))
        .textAlignment(.center)
    
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
extension WidgetsPresetsTemplateCarLogoCell {
    func setup(configuration: WidgetCarLogoConfiguration, isUsersLogo: Bool, catalogsCount: Int?) {
        updateTag(isUsersLogo: isUsersLogo, catalogsCount: catalogsCount)
        logoView.setup(configuration: configuration)
    }
}

// MARK: Private
private extension WidgetsPresetsTemplateCarLogoCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
    
    func updateTag(isUsersLogo: Bool, catalogsCount: Int?) {
        if isUsersLogo {
            tagLabel.isHidden = false
            tagLabel.attributedText = "WidgetsPresets.CarLogo.YourLogo".localized.attributed(with: attrs)
        } else if let catalogsCount {
            tagLabel.isHidden = false
            tagLabel.attributedText = "+\(catalogsCount)".attributed(with: attrs)
        } else {
            tagLabel.isHidden = true
        }
    }
}

// MARK: Make constraints
private extension WidgetsPresetsTemplateCarLogoCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            logoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            logoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            logoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            logoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tagLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.scale),
            tagLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPresetsTemplateCarLogoCell {
    func makeLogoView() -> CarLogoView {
        let view = CarLogoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makePaddingLabel() -> PaddingLabel {
        let view = PaddingLabel()
        view.backgroundColor = Appearance.color_4178F6
        view.layer.cornerRadius = 16.scale
        view.layer.masksToBounds = true
        view.insets = UIEdgeInsets(vertical: 4.5.scale, horizontal: 8.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
