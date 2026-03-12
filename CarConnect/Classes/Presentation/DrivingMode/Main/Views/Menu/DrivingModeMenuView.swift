//
//  DrivingModeMenuView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 12.03.2026.
//

import UIKit

final class DrivingModeMenuView: UIView {
    lazy var statusView = makeStatusView()
    lazy var mapItemButton = makeRouteItemButton(item: .map)
    lazy var musicItemButton = makeRouteItemButton(item: .music(.appleMusic))
    lazy var phoneItemButton = makeRouteItemButton(item: .phone)
    lazy var settingsButton = makeSettingsButton()
    
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
private extension DrivingModeMenuView {
    func initialize() {
        backgroundColor = Appearance.color_1B1C1D
        layer.cornerRadius = 10.landscapeHScale
    }
}

// MARK: Make constraints
private extension DrivingModeMenuView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            statusView.leadingAnchor.constraint(equalTo: leadingAnchor),
            statusView.trailingAnchor.constraint(equalTo: trailingAnchor),
            statusView.topAnchor.constraint(equalTo: topAnchor, constant: 8.landscapeVScale),
            statusView.heightAnchor.constraint(equalToConstant: 70.landscapeVScale)
        ])
        
        NSLayoutConstraint.activate([
            mapItemButton.widthAnchor.constraint(equalToConstant: 58.landscapeHScale),
            mapItemButton.heightAnchor.constraint(equalToConstant: 58.landscapeHScale),
            mapItemButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            mapItemButton.topAnchor.constraint(equalTo: statusView.bottomAnchor, constant: 6.landscapeVScale)
        ])
        
        NSLayoutConstraint.activate([
            musicItemButton.widthAnchor.constraint(equalToConstant: 58.landscapeHScale),
            musicItemButton.heightAnchor.constraint(equalToConstant: 58.landscapeHScale),
            musicItemButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            musicItemButton.topAnchor.constraint(equalTo: mapItemButton.bottomAnchor, constant: 4.landscapeVScale)
        ])
        
        NSLayoutConstraint.activate([
            phoneItemButton.widthAnchor.constraint(equalToConstant: 58.landscapeHScale),
            phoneItemButton.heightAnchor.constraint(equalToConstant: 58.landscapeHScale),
            phoneItemButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            phoneItemButton.topAnchor.constraint(equalTo: musicItemButton.bottomAnchor, constant: 4.landscapeVScale)
        ])
        
        NSLayoutConstraint.activate([
            settingsButton.widthAnchor.constraint(equalToConstant: 28.landscapeHScale),
            settingsButton.heightAnchor.constraint(equalToConstant: 19.landscapeHScale),
            settingsButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            settingsButton.topAnchor.constraint(equalTo: phoneItemButton.bottomAnchor, constant: 24.landscapeVScale)
        ])
    }
}

// MARK: Lazy initialization
private extension DrivingModeMenuView {
    func makeStatusView() -> DrivingModeMenuStatusView {
        let view = DrivingModeMenuStatusView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeRouteItemButton(item: DrivingModeRouteItemButton.Item) -> DrivingModeRouteItemButton {
        let view = DrivingModeRouteItemButton(item: item)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSettingsButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.backgroundColor = UIColor.clear
        view.setImage(UIImage(named: "DrivingMode.Menu.Settings"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
