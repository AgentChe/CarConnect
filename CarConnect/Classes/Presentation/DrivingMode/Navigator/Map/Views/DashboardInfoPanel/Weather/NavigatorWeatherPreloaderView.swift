//
//  NavigatorWeatherPreloaderView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 26.05.2026.
//

import UIKit

final class NavigatorWeatherPreloaderView: GradientView {
    lazy var preloader = makePreloader()
    
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
private extension NavigatorWeatherPreloaderView {
    func initialize() {
        layer.cornerRadius = 10.landscapeHScale
        gradientLayer.backgroundColor = Appearance.color_4178F6.cgColor
        gradientLayer.cornerRadius = 10.landscapeHScale
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.colors = {
            let isDay = Date.isDay(Date())
            
            if isDay {
                return [
                    Appearance.color_9EBAFA.withAlphaComponent(0).cgColor,
                    Appearance.color_0943C8.cgColor
                ]
            } else {
                return [
                    Appearance.color_031236.withAlphaComponent(0.4).cgColor,
                    Appearance.color_031236.cgColor
                ]
            }
        }()
        
        preloader.startAnimating()
    }
}

// MARK: Make constraints
private extension NavigatorWeatherPreloaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            preloader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.landscapeHScale),
            preloader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension NavigatorWeatherPreloaderView {
    func makePreloader() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.color = Appearance.color_FFFFFF
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
