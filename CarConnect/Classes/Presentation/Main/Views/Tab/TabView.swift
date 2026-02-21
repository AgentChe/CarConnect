//
//  TabView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 21.02.2026.
//

import UIKit

final class TabView: UIView {
    enum Constants {
        static let tabBarHeight = 64.scale
        static let tabBarBottomInset = 29.scale
        static let tabBarItemsInsets = 4.scale
    }
    
    enum TabItem {
        case garage, widgets, drivingMode
    }
    
    lazy var garageButton = makeItemButton(domain: .garage)
    lazy var widgetsButton = makeItemButton(domain: .widgets)
    lazy var drivingModeButton = makeItemButton(domain: .drivingMode)
    
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
extension TabView {
    func select(tabItem: TabItem) {
        garageButton.backgroundColor = tabItem == .garage ? Appearance.color_4178F6 : UIColor.clear
        garageButton.alpha = tabItem == .garage ? 1 : 0.6
        
        widgetsButton.backgroundColor = tabItem == .widgets ? Appearance.color_4178F6 : UIColor.clear
        widgetsButton.alpha = tabItem == .widgets ? 1 : 0.6
    }
}

// MARK: Private
private extension TabView {
    func initialize() {
        backgroundColor = Appearance.color_2C2F39.withAlphaComponent(0.8)
        layer.cornerRadius = Constants.tabBarHeight / 2
        layer.masksToBounds = true
        layer.borderWidth = 1.scale
        layer.borderColor = Appearance.color_2C2F39.cgColor
    }
}

// MARK: Make constraints
private extension TabView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            garageButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.tabBarItemsInsets),
            garageButton.topAnchor.constraint(equalTo: topAnchor, constant: Constants.tabBarItemsInsets),
            garageButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.tabBarItemsInsets),
            garageButton.widthAnchor.constraint(equalTo: widgetsButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            widgetsButton.leadingAnchor.constraint(equalTo: garageButton.trailingAnchor, constant: Constants.tabBarItemsInsets),
            widgetsButton.topAnchor.constraint(equalTo: topAnchor, constant: Constants.tabBarItemsInsets),
            widgetsButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.tabBarItemsInsets),
            widgetsButton.widthAnchor.constraint(equalTo: drivingModeButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            drivingModeButton.leadingAnchor.constraint(equalTo: widgetsButton.trailingAnchor, constant: Constants.tabBarItemsInsets),
            drivingModeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.tabBarItemsInsets),
            drivingModeButton.topAnchor.constraint(equalTo: topAnchor, constant: Constants.tabBarItemsInsets),
            drivingModeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.tabBarItemsInsets)
        ])
    }
}

// MARK: Lazy initialization
private extension TabView {
    func makeItemButton(domain: TabItemButton.Domain) -> TabItemButton {
        let view = TabItemButton(domain: domain)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
