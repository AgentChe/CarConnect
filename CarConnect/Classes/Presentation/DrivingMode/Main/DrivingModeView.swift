//
//  DrivingModeView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 12.03.2026.
//

import UIKit

final class DrivingModeView: UIView {
    lazy var container = makeContainer()
    lazy var menuView = makeMenuView()
    
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
private extension DrivingModeView {
    func initialize() {
        backgroundColor = Appearance.color_080A0C
    }
}

// MARK: Make constraints
private extension DrivingModeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            menuView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 56.landscapeHScale),
            menuView.topAnchor.constraint(equalTo: topAnchor, constant: 20.landscapeVScale),
            menuView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.landscapeVScale),
            menuView.widthAnchor.constraint(equalToConstant: 84.landscapeHScale)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: menuView.trailingAnchor, constant: 16.landscapeHScale),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension DrivingModeView {
    func makeMenuView() -> DrivingModeMenuView {
        let view = DrivingModeMenuView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
