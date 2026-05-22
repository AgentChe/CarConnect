//
//  NavigatorDashboardInfoPanelView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.05.2026.
//

import UIKit

final class NavigatorDashboardInfoPanelView: UIView {
    lazy var musicPlayerView = makeMusicPlayerView()
    lazy var weatherView = makeWeatherView()
    
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
private extension NavigatorDashboardInfoPanelView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension NavigatorDashboardInfoPanelView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            musicPlayerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            musicPlayerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            musicPlayerView.topAnchor.constraint(equalTo: topAnchor),
            musicPlayerView.heightAnchor.constraint(equalToConstant: 202.landscapeVScale)
        ])
        
        NSLayoutConstraint.activate([
            weatherView.leadingAnchor.constraint(equalTo: leadingAnchor),
            weatherView.trailingAnchor.constraint(equalTo: trailingAnchor),
            weatherView.bottomAnchor.constraint(equalTo: bottomAnchor),
            weatherView.heightAnchor.constraint(equalToConstant: 122.landscapeVScale)
        ])
    }
}

// MARK: Lazy initialization
private extension NavigatorDashboardInfoPanelView {
    // TODO: заменить на умную UIView, которую сделает Виталя
    func makeMusicPlayerView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeWeatherView() -> NavigatorWeatherView {
        let view = NavigatorWeatherView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
