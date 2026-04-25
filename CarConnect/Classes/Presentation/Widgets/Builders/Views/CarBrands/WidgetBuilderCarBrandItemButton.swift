//
//  WidgetBuilderCarBrandItemButton.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 02.04.2026.
//

import UIKit
import Kingfisher

final class WidgetBuilderCarBrandItemButton: UIButton {
    lazy var logoView = makeLogoView()
    
    let brand: WidgetCarLogoBrand
    
    init(brand: WidgetCarLogoBrand) {
        self.brand = brand
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WidgetBuilderCarBrandItemButton {
    func setup(selected: Bool) {
        layer.borderWidth = selected ? 2.scale : 0
        layer.borderColor = selected ? Appearance.color_4178F6.cgColor : UIColor.clear.cgColor
    }
}

// MARK: Private
private extension WidgetBuilderCarBrandItemButton {
    func initialize() {
        backgroundColor = Appearance.color_868EB2.withAlphaComponent(0.1)
        layer.cornerRadius = 10.scale
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension WidgetBuilderCarBrandItemButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            logoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            logoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            logoView.topAnchor.constraint(equalTo: topAnchor),
            logoView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetBuilderCarBrandItemButton {
    func makeLogoView() -> UIImageView {
        let view = UIImageView()
        view.kf.setImage(with: brand.logo)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
