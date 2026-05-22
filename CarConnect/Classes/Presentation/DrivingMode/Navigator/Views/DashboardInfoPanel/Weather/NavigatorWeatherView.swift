//
//  NavigatorWeatherView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.05.2026.
//

import UIKit

final class NavigatorWeatherView: UIView {
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
private extension NavigatorWeatherView {
    func initialize() {
        layer.cornerRadius = 10.landscapeHScale
    }
}

// MARK: Make constraints
private extension NavigatorWeatherView {
    func makeConstraints() {
        
    }
}

// MARK: Lazy initialization
private extension NavigatorWeatherView {
    
}
