//
//  DrivingModeSignalBarsView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 12.03.2026.
//

import UIKit
import Network
import CoreTelephony

final class DrivingModeSignalBarsView: UIView {
    lazy var container = makeContainer()
    lazy var barsView = makeBarsView()
    lazy var typeLabel = makeLabel()
    
    deinit {
        pathMonitor.cancel()
    }
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.color_FFFFFF)
        .font(Fonts.Inter.regular(size: 16.landscapeHScale))
        .textAlignment(.right)
    
    private let pathMonitor = NWPathMonitor()
    private let pathMonitorQueue = DispatchQueue(label: "driving.mode.network.monitor")
    private let telephonyInfo = CTTelephonyNetworkInfo()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
        update(strength: 0, type: "--")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension DrivingModeSignalBarsView {
    func initialize() {
        backgroundColor = UIColor.clear
        
        pathMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.updateNetwork(path: path)
            }
        }
        pathMonitor.start(queue: pathMonitorQueue)
    }
    
    func updateNetwork(path: NWPath) {
        guard path.status == .satisfied else {
            update(strength: 0, type: "No")
            return
        }
        
        if path.usesInterfaceType(.wifi) {
            update(strength: 4, type: "Wi-Fi")
            return
        }
        
        if path.usesInterfaceType(.cellular) {
            let networkType = currentCellularType()
            
            update(strength: 4, type: networkType)
            return
        }
        
        update(strength: 1, type: "Net")
    }
    
    func currentCellularType() -> String {
        if let value = telephonyInfo.serviceCurrentRadioAccessTechnology?.values.first {
            return mapRadioAccessTechnology(value)
        }
        
        return "Cell"
    }
    
    func mapRadioAccessTechnology(_ value: String) -> String {
        switch value {
        case CTRadioAccessTechnologyNR, CTRadioAccessTechnologyNRNSA:
            return "5G"
            
        case CTRadioAccessTechnologyLTE:
            return "4G"
            
        case CTRadioAccessTechnologyWCDMA,
             CTRadioAccessTechnologyHSDPA,
             CTRadioAccessTechnologyHSUPA,
             CTRadioAccessTechnologyCDMAEVDORev0,
             CTRadioAccessTechnologyCDMAEVDORevA,
             CTRadioAccessTechnologyCDMAEVDORevB,
             CTRadioAccessTechnologyeHRPD:
            return "3G"
            
        case CTRadioAccessTechnologyEdge,
             CTRadioAccessTechnologyGPRS,
             CTRadioAccessTechnologyCDMA1x:
            return "2G"
            
        default:
            return "Cell"
        }
    }
    
    func update(strength: Int, type: String) {
        typeLabel.attributedText = type.attributed(with: attrs)
        
        let clampedStrength = max(0, min(4, strength))
        barsView.update(strength: clampedStrength)
    }
}

// MARK: Make constraints
private extension DrivingModeSignalBarsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            barsView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            barsView.centerYAnchor.constraint(equalTo: typeLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            typeLabel.leadingAnchor.constraint(equalTo: barsView.trailingAnchor, constant: 5.landscapeHScale),
            typeLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            typeLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            typeLabel.topAnchor.constraint(equalTo: container.topAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension DrivingModeSignalBarsView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBarsView() -> SignalBarsView {
        let view = SignalBarsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
