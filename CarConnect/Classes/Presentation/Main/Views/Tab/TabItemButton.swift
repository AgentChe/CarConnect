//
//  TabItemButton.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 21.02.2026.
//

import UIKit

final class TabItemButton: UIButton {
    enum Domain {
        case garage, widgets, drivingMode
    }
    
    lazy var container = makeContainer()
    lazy var iconView = makeImageView()
    lazy var label = makeLabel()
    
    private let domain: Domain
    
    init(domain: Domain) {
        self.domain = domain
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TabItemButton {
    func initialize() {
        backgroundColor = UIColor.clear
        alpha = 0.6
        layer.cornerRadius = (TabView.Constants.tabBarHeight - TabView.Constants.tabBarItemsInsets * 2) / 2
        layer.masksToBounds = true 
    }
}

// MARK: Make constraints
private extension TabItemButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            iconView.topAnchor.constraint(equalTo: container.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 24.scale),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TabItemButton {
    func makeContainer() -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let iconName: String = {
            switch domain {
            case .garage:
                return "Main.Tab.Garage"
            case .widgets:
                return "Main.Tab.Widgets"
            case .drivingMode:
                return "Main.Tab.DrivingMode"
            }
        }()
        
        let view = UIImageView()
        view.image = UIImage(named: iconName)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.regular(size: 12.scale))
            .lineHeight(17.scale)
            .textAlignment(.center)
        
        let title: String = {
            switch domain {
            case .garage:
                return "Main.Tab.Garage".localized
            case .widgets:
                return "Main.Tab.Widgets".localized
            case .drivingMode:
                return "Main.Tab.DrivingMode".localized
            }
        }()
        
        let view = UILabel()
        view.attributedText = title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
