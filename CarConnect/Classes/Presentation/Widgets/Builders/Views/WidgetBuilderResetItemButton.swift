//
//  WidgetBuilderResetItemButton.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 24.02.2026.
//

import UIKit

final class WidgetBuilderResetItemButton: UIButton {
    lazy var iconView = makeIconView()
    
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
extension WidgetBuilderResetItemButton {
    func setup(enable: Bool) {
        isUserInteractionEnabled = enable
        iconView.alpha = enable ? 1 : 0.2
    }
}

// MARK: Private
private extension WidgetBuilderResetItemButton {
    func initialize() {
        backgroundColor = Appearance.color_868EB2.withAlphaComponent(0.1)
        layer.cornerRadius = 10.scale
        layer.masksToBounds = true
        isUserInteractionEnabled = false
        iconView.alpha = 0.2
    }
}

// MARK: Make constraints
private extension WidgetBuilderResetItemButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetBuilderResetItemButton {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.isUserInteractionEnabled = false
        view.image = UIImage(named: "WidgetsBuilders.ResetItem")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
