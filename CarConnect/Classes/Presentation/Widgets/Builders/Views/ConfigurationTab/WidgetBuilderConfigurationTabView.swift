//
//  WidgetBuilderConfigurationTabView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 21.03.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetBuilderConfigurationTabView: UIView {
    lazy var visualEditorButton = makeItemButton(item: .visualEditor)
    lazy var widgetsSettingsButton = makeItemButton(item: .widgetSettings)
    
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
extension WidgetBuilderConfigurationTabView {
    func setup(selected: WidgetBuilderConfigurationTabItemButton.Item) {
        visualEditorButton.setup(selected: selected == .visualEditor)
        widgetsSettingsButton.setup(selected: selected == .widgetSettings)
    }
    
    var didSelect: Signal<WidgetBuilderConfigurationTabItemButton.Item> {
        Signal
            .merge(
                visualEditorButton.didTap,
                widgetsSettingsButton.didTap
            )
    }
}

// MARK: Private
private extension WidgetBuilderConfigurationTabView {
    func initialize() {
        backgroundColor = UIColor.clear
        layer.borderWidth = 1.scale
        layer.borderColor = Appearance.color_2C2F39.cgColor
        layer.cornerRadius = 10.scale
    }
}

// MARK: Make constraints
private extension WidgetBuilderConfigurationTabView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            visualEditorButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4.scale),
            visualEditorButton.topAnchor.constraint(equalTo: topAnchor, constant: 4.scale),
            visualEditorButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4.scale),
            visualEditorButton.widthAnchor.constraint(equalTo: widgetsSettingsButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            widgetsSettingsButton.leadingAnchor.constraint(equalTo: visualEditorButton.trailingAnchor, constant: 2.scale),
            widgetsSettingsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4.scale),
            widgetsSettingsButton.topAnchor.constraint(equalTo: topAnchor, constant: 4.scale),
            widgetsSettingsButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetBuilderConfigurationTabView {
    func makeItemButton(item: WidgetBuilderConfigurationTabItemButton.Item) -> WidgetBuilderConfigurationTabItemButton {
        let view = WidgetBuilderConfigurationTabItemButton(item: item)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
