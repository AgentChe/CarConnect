//
//  WidgetsPreviewCarPlayView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.02.2026.
//

import UIKit

final class WidgetsPreviewCarPlayView: UIView {
    enum Count {
        case one, two, three
    }
    
    lazy var container = makeContainer()
    
    private let snapshot: UIImage
    
    init(snapshot: UIImage) {
        self.snapshot = snapshot
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WidgetsPreviewCarPlayView {
    func setup(count: Count) {
        container.subviews.forEach { $0.removeFromSuperview() }
        
        switch count {
        case .one:
            buildOneLayout()
        case .two:
            buildTwoLayout()
        case .three:
            buildThreeLayout()
        }
    }
}

// MARK: Private
private extension WidgetsPreviewCarPlayView {
    func initialize() {
        backgroundColor = UIColor.clear
        layer.cornerRadius = 10.scale
        layer.masksToBounds = true
    }
    
    func buildOneLayout() {
        let snapshotView = UIImageView()
        snapshotView.contentMode = .scaleAspectFill
        snapshotView.layer.cornerRadius = 10.scale
        snapshotView.layer.masksToBounds = true
        snapshotView.image = snapshot
        snapshotView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(snapshotView)
        
        NSLayoutConstraint.activate([
            snapshotView.widthAnchor.constraint(equalToConstant: 120.vScale),
            snapshotView.heightAnchor.constraint(equalToConstant: 120.vScale),
            snapshotView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -99.scale),
            snapshotView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
    
    func buildTwoLayout() {
        let snapshotView = UIImageView()
        snapshotView.contentMode = .scaleAspectFill
        snapshotView.layer.cornerRadius = 10.scale
        snapshotView.layer.masksToBounds = true
        snapshotView.image = snapshot
        snapshotView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(snapshotView)
        
        NSLayoutConstraint.activate([
            snapshotView.widthAnchor.constraint(equalToConstant: 120.vScale),
            snapshotView.heightAnchor.constraint(equalToConstant: 120.vScale),
            snapshotView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 77.scale),
            snapshotView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        let weatherView = UIImageView()
        weatherView.layer.cornerRadius = 10.scale
        weatherView.layer.masksToBounds = true
        weatherView.image = UIImage(named: "WidgetsPreview.CarPlay.Weather.Large")
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(weatherView)
        
        NSLayoutConstraint.activate([
            weatherView.widthAnchor.constraint(equalToConstant: 120.vScale),
            weatherView.heightAnchor.constraint(equalToConstant: 120.vScale),
            weatherView.leadingAnchor.constraint(equalTo: snapshotView.trailingAnchor, constant: 4.scale),
            weatherView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
    
    func buildThreeLayout() {
        let calendarView = UIImageView()
        calendarView.layer.cornerRadius = 10.scale
        calendarView.layer.masksToBounds = true
        calendarView.image = UIImage(named: "WidgetsPreview.CarPlay.Weather.Large")
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.widthAnchor.constraint(equalToConstant: 100.vScale),
            calendarView.heightAnchor.constraint(equalToConstant: 100.vScale),
            calendarView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 28.scale),
            calendarView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        let snapshotView = UIImageView()
        snapshotView.layer.cornerRadius = 10.scale
        snapshotView.layer.masksToBounds = true
        snapshotView.image = snapshot
        snapshotView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(snapshotView)
        
        NSLayoutConstraint.activate([
            snapshotView.widthAnchor.constraint(equalToConstant: 100.vScale),
            snapshotView.heightAnchor.constraint(equalToConstant: 100.vScale),
            snapshotView.leadingAnchor.constraint(equalTo: calendarView.trailingAnchor, constant: 4.scale),
            snapshotView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        let weatherView = UIImageView()
        weatherView.layer.cornerRadius = 10.scale
        weatherView.layer.masksToBounds = true
        weatherView.image = UIImage(named: "WidgetsPreview.CarPlay.Weather.Small")
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(weatherView)
        
        NSLayoutConstraint.activate([
            weatherView.widthAnchor.constraint(equalToConstant: 100.vScale),
            weatherView.heightAnchor.constraint(equalToConstant: 100.vScale),
            weatherView.leadingAnchor.constraint(equalTo: snapshotView.trailingAnchor, constant: 4.scale),
            weatherView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Make constraints
private extension WidgetsPreviewCarPlayView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPreviewCarPlayView {
    func makeContainer() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "WidgetsPreview.CarPlay")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
