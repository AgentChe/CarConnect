//
//  WidgetBuilderConfigurationTabItemButton.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 21.03.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetBuilderConfigurationTabItemButton: UIButton {
    enum Item {
        case visualEditor, widgetSettings
    }
    
    lazy var label = makeLabel()
    
    private let item: Item
    
    init(item: Item) {
        self.item = item
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WidgetBuilderConfigurationTabItemButton {
    func setup(selected: Bool) {
        backgroundColor = selected ? Appearance.color_2C2F39 : UIColor.clear
    }
    
    var didTap: Signal<Item> {
        rx.tap
            .compactMap { [weak self] in self?.item }
            .asSignal(onErrorSignalWith: .never())
    }
}

// MARK: Private
private extension WidgetBuilderConfigurationTabItemButton {
    func initialize() {
        layer.cornerRadius = 8.scale
    }
}

// MARK: Make constraints
private extension WidgetBuilderConfigurationTabItemButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetBuilderConfigurationTabItemButton {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.regular(size: 16.scale))
            .textAlignment(.center)
        
        let title: String = {
            switch item {
            case .visualEditor:
                return "WidgetsBuilders.ConfigurationTab.VisualEditor".localized
            case .widgetSettings:
                return "WidgetsBuilders.ConfigurationTab.WidgetsSettings".localized
            }
        }()
        
        let view = UILabel()
        view.attributedText = title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
