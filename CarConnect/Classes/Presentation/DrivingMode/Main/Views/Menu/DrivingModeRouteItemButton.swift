//
//  DrivingModeRouteItemButton.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 12.03.2026.
//

import UIKit

final class DrivingModeRouteItemButton: UIButton {
    enum Item: Codable, Hashable {
        case map, music(MusicPlayerRoute), phone
    }
    
    lazy var iconView = makeIconView()
    
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
extension DrivingModeRouteItemButton {
    func setup(selected: Bool) {
        layer.borderWidth = selected ? 2.landscapeHScale : 0
        layer.borderColor = selected ? Appearance.color_4178F6.cgColor : UIColor.clear.cgColor
    }
}

// MARK: Private
private extension DrivingModeRouteItemButton {
    func initialize() {
        backgroundColor = UIColor.clear
        layer.cornerRadius = 10.landscapeHScale
    }
}

// MARK: Make constraints
private extension DrivingModeRouteItemButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 48.landscapeHScale),
            iconView.heightAnchor.constraint(equalToConstant: 48.landscapeHScale),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension DrivingModeRouteItemButton {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: item.iconName)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
extension DrivingModeRouteItemButton.Item {
    var iconName: String {
        switch self {
        case .map:
            return "DrivingMode.Menu.MapItem"
        case .music(let route):
            return (route.musicSource ?? .appleMusic).iconName
        case .phone:
            return "DrivingMode.Menu.PhoneItem"
        }
    }
}
