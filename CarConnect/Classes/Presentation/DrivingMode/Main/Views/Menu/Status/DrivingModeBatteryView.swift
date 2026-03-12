//
//  DrivingModeBatteryView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 12.03.2026.
//

import UIKit

final class DrivingModeBatteryView: UIView {
    lazy var bodyView = makeBodyView()
    lazy var levelView = makeLevelView()
    lazy var terminalView = makeTerminalView()
    
    deinit {
        batteryTimer?.invalidate()
        
        UIDevice.current.isBatteryMonitoringEnabled = false
    }
    
    private var bodyWidthConstraint = NSLayoutConstraint()
    private var bodyHeightConstraint = NSLayoutConstraint()
    private var levelWidthConstraint = NSLayoutConstraint()
    private var levelHeightConstraint = NSLayoutConstraint()
    private var terminalWidthConstraint = NSLayoutConstraint()
    private var terminalHeightConstraint = NSLayoutConstraint()
    
    private var batteryTimer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
        updateBattery()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension DrivingModeBatteryView {
    func initialize() {
        backgroundColor = .clear
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        batteryTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            self?.updateBattery()
        }
    }
    
    func updateBattery() {
        let state = UIDevice.current.batteryState
        
        guard state != .unknown else {
            isHidden = true
            return
        }
        
        isHidden = false
        
        let levelFloat = UIDevice.current.batteryLevel
        let level = levelFloat < 0 ? 0 : Int(levelFloat * 100)
        let isCharging = (state == .charging || state == .full)
        
        let clampedLevel = max(0, min(100, level))
        applyCurrentState(batteryLevel: clampedLevel, isCharging: isCharging)
    }
    
    func applyCurrentState(batteryLevel: Int, isCharging: Bool) {
        let batteryWidth = 27.landscapeHScale
        let batteryHeight = 13.landscapeVScale
        
        let borderWidth: CGFloat = 1
        let padding: CGFloat = 2
        let borderRadius = batteryHeight * 0.25
        
        let termWidth = batteryWidth * 0.1
        let termHeight = batteryHeight * 0.4
        let termBorderRadius = termHeight * 0.5
        
        let adjustedBatteryWidth = batteryWidth - termWidth - 2
        let innerMaxWidth = adjustedBatteryWidth - (borderWidth * 2) - (padding * 2)
        let innerHeight = batteryHeight - (borderWidth * 2) - (padding * 2)
        let innerBorderRadius = max(borderRadius - padding, 1)
        
        let chargeColor = UIColor(red: 61/255, green: 186/255, blue: 98/255, alpha: 1)
        let inactiveBorderColor = UIColor.white.withAlphaComponent(0.4)
        
        let borderColor = isCharging ? chargeColor : inactiveBorderColor
        let terminalColor = isCharging ? chargeColor : inactiveBorderColor
        let fillColor = isCharging ? chargeColor : .white
        
        bodyWidthConstraint.constant = adjustedBatteryWidth
        bodyHeightConstraint.constant = batteryHeight
        
        terminalWidthConstraint.constant = termWidth
        terminalHeightConstraint.constant = termHeight
        
        levelWidthConstraint.constant = innerMaxWidth * CGFloat(batteryLevel) / 100
        levelHeightConstraint.constant = innerHeight
        
        bodyView.layer.cornerRadius = borderRadius
        bodyView.layer.borderWidth = borderWidth
        bodyView.layer.borderColor = borderColor.cgColor
        
        levelView.layer.cornerRadius = innerBorderRadius
        levelView.backgroundColor = fillColor
        
        terminalView.layer.cornerRadius = termBorderRadius
        terminalView.backgroundColor = terminalColor
        
        layoutIfNeeded()
    }
}

// MARK: Make constraints
private extension DrivingModeBatteryView {
    func makeConstraints() {
        bodyWidthConstraint = bodyView.widthAnchor.constraint(equalToConstant: 0)
        bodyHeightConstraint = bodyView.heightAnchor.constraint(equalToConstant: 0)
        levelWidthConstraint = levelView.widthAnchor.constraint(equalToConstant: 0)
        levelHeightConstraint = levelView.heightAnchor.constraint(equalToConstant: 0)
        terminalWidthConstraint = terminalView.widthAnchor.constraint(equalToConstant: 0)
        terminalHeightConstraint = terminalView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            bodyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bodyView.topAnchor.constraint(equalTo: topAnchor),
            bodyView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bodyWidthConstraint,
            bodyHeightConstraint
        ])
        
        NSLayoutConstraint.activate([
            levelView.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: 3),
            levelView.centerYAnchor.constraint(equalTo: bodyView.centerYAnchor),
            levelWidthConstraint,
            levelHeightConstraint
        ])
        
        NSLayoutConstraint.activate([
            terminalView.leadingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: 2),
            terminalView.centerYAnchor.constraint(equalTo: bodyView.centerYAnchor),
            terminalView.trailingAnchor.constraint(equalTo: trailingAnchor),
            terminalWidthConstraint,
            terminalHeightConstraint
        ])
    }
}

// MARK: Lazy initialization
private extension DrivingModeBatteryView {
    func makeBodyView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLevelView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        bodyView.addSubview(view)
        return view
    }
    
    func makeTerminalView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
