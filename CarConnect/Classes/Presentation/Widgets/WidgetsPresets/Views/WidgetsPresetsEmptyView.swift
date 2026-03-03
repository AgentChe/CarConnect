//
//  WidgetsPresetsEmptyView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.03.2026.
//

import UIKit

final class WidgetsPresetsEmptyView: UIView {
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var catalogButton = makeCatalogButton()
    
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
private extension WidgetsPresetsEmptyView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension WidgetsPresetsEmptyView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 42.scale),
            imageView.heightAnchor.constraint(equalToConstant: 42.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 74.scale),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.scale),
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48.scale)
        ])
        
        NSLayoutConstraint.activate([
            catalogButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            catalogButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            catalogButton.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 16.scale),
            catalogButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            catalogButton.heightAnchor.constraint(equalToConstant: 51.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPresetsEmptyView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "WidgetsPresents.Empty")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(22.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "WidgetsPresets.Empty.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF.withAlphaComponent(0.6))
            .font(Fonts.Inter.regular(size: 14.scale))
            .lineHeight(20.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "WidgetsPresets.Empty.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCatalogButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.medium(size: 16.scale))
        
        let view = UIButton()
        view.backgroundColor = Appearance.color_2C2F39
        view.layer.cornerRadius = 10.scale
        view.setAttributedTitle("WidgetsPresets.Empty.CatalogButton".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
