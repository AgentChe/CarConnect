//
//  WidgetsBuilderRemoveButton.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.02.2026.
//

import UIKit

final class WidgetsBuilderRemoveButton: UIButton {
    lazy var container = makeContainer()
    lazy var iconView = makeIconView()
    lazy var label = makeLabel()
    
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
private extension WidgetsBuilderRemoveButton {
    func initialize() {
        backgroundColor = UIColor.clear
        layer.cornerRadius = 10.scale
        layer.masksToBounds = true
        layer.borderWidth = 1.scale
        layer.borderColor = Appearance.color_F4433E.cgColor
    }
}

// MARK: Make constraints
private extension WidgetsBuilderRemoveButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 20.scale),
            iconView.heightAnchor.constraint(equalToConstant: 20.scale),
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 28.scale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsBuilderRemoveButton {
    func makeContainer() -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "WidgetsBuilders.Remove")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FE7571)
            .font(Fonts.Inter.medium(size: 16.scale))
            .lineHeight(20.scale)
        
        let view = UILabel()
        view.attributedText = "WidgetsBuilders.RemoveWidget".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
