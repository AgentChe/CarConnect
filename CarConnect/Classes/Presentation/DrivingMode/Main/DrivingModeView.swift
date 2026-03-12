//
//  DrivingModeView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 12.03.2026.
//

import UIKit

final class DrivingModeView: UIView {
    lazy var backgroundView = makeBackgroundView()
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
        backgroundColor = Appearance.color_1B1C1D
    }
}

// MARK: Make constraints
private extension DrivingModeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            menuView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 56.landscapeHScale),
            menuView.topAnchor.constraint(equalTo: topAnchor, constant: 20.landscapeVScale),
            menuView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.landscapeVScale),
            menuView.widthAnchor.constraint(equalToConstant: 84.landscapeHScale)
        ])
    }
}

// MARK: Lazy initialization
private extension DrivingModeView {
    func makeBackgroundView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "DrivingMode.Background")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeMenuView() -> DrivingModeMenuView {
        let view = DrivingModeMenuView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
