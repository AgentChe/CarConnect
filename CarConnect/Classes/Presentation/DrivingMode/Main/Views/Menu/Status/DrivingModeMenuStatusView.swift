//
//  DrivingModeMenuStatusView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 12.03.2026.
//

import UIKit

final class DrivingModeMenuStatusView: UIView {
    lazy var timeView = makeTimeView()
    lazy var signalBarsView = makeSignalBarsView()
    lazy var batteryView = makeBatteryView()
    
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
private extension DrivingModeMenuStatusView {
    func initialize() {
        backgroundColor = .clear
    }
}

// MARK: Make constraints
private extension DrivingModeMenuStatusView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            timeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            timeView.trailingAnchor.constraint(equalTo: trailingAnchor),
            timeView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            signalBarsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            signalBarsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            signalBarsView.topAnchor.constraint(equalTo: timeView.bottomAnchor, constant: 7.landscapeVScale)
        ])
        
        NSLayoutConstraint.activate([
            batteryView.centerXAnchor.constraint(equalTo: centerXAnchor),
            batteryView.topAnchor.constraint(equalTo: signalBarsView.bottomAnchor, constant: 7.landscapeVScale)
        ])
    }
}

// MARK: Lazy initialization
private extension DrivingModeMenuStatusView {
    func makeTimeView() -> DrivingModeStatusTimeView {
        let view = DrivingModeStatusTimeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSignalBarsView() -> DrivingModeSignalBarsView {
        let view = DrivingModeSignalBarsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBatteryView() -> DrivingModeBatteryView {
        let view = DrivingModeBatteryView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
