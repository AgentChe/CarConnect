//
//  PhoneTabItemView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.06.2026.
//

import UIKit

final class PhoneTabItemView: UIButton {
    enum Item {
        case contacts
        case keypad
    }
    
    lazy var container = makeContainer()
    lazy var iconView = makeIconView()
    lazy var label = makeLabel()
    
    let item: Item
    
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
extension PhoneTabItemView {
    func setup(selected: Bool) {
        backgroundColor = selected ? Appearance.color_FFFFFF.withAlphaComponent(0.1) : UIColor.clear
        container.alpha = selected ? 1 : 0.6
    }
}

// MARK: Private
private extension PhoneTabItemView {
    func initialize() {
        layer.cornerRadius = 10.landscapeHScale
    }
}

// MARK: Make constraints
private extension PhoneTabItemView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 40.landscapeHScale),
            iconView.heightAnchor.constraint(equalToConstant: 40.landscapeHScale),
            iconView.topAnchor.constraint(equalTo: container.topAnchor),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 50.landscapeHScale),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension PhoneTabItemView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let iconName: String = {
            switch item {
            case .contacts:
                return "DrivingMode.Phone.Contacts"
            case .keypad:
                return "DrivingMode.Phone.Keypad"
            }
        }()
        
        let view = UIImageView()
        view.isUserInteractionEnabled = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: iconName)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let title: String = {
            switch item {
            case .contacts:
                return "Phone.Contants".localized
            case .keypad:
                return "Phone.Keypad".localized
            }
        }()
        
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.bold(size: 24.landscapeHScale))
            .textAlignment(.center)
        
        let view = UILabel()
        view.isUserInteractionEnabled = false 
        view.attributedText = title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
