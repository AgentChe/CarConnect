//
//  RouteOptionsItemSelectView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.05.2026.
//

import UIKit

final class RouteOptionsItemSelectView: UIView {
    lazy var label = makeLabel()
    lazy var switchView = makeSwitchView()
    lazy var separator = makeSeparator()
    
    private let title: String
    private let isOn: Bool
    private let separatorHidden: Bool
    
    init(title: String, isOn: Bool, separatorHidden: Bool) {
        self.title = title
        self.isOn = isOn
        self.separatorHidden = separatorHidden
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension RouteOptionsItemSelectView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension RouteOptionsItemSelectView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.landscapeHScale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -76.landscapeHScale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 18.5.landscapeVScale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18.5.landscapeVScale)
        ])
        
        NSLayoutConstraint.activate([
            switchView.widthAnchor.constraint(equalToConstant: 51.landscapeHScale),
            switchView.heightAnchor.constraint(equalToConstant: 31.landscapeHScale),
            switchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.landscapeHScale),
            switchView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.landscapeVScale)
        ])
    }
}

// MARK: Lazy initialization
private extension RouteOptionsItemSelectView {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.medium(size: 18.landscapeHScale))
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSwitchView() -> UISwitch {
        let view = UISwitch()
        view.setOn(isOn, animated: false)
        view.thumbTintColor = Appearance.color_FFFFFF
        view.onTintColor = Appearance.color_4178F6
        view.tintColor = Appearance.color_FFFFFF.withAlphaComponent(0.16)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.isHidden = separatorHidden
        view.backgroundColor = Appearance.color_FFFFFF.withAlphaComponent(0.04)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
