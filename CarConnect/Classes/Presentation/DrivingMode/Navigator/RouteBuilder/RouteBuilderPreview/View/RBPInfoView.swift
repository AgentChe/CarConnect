//
//  RBPInfoView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 29.05.2026.
//

import UIKit

final class RBPInfoView: UIView {
    var didTapClose: (() -> Void)?
    var didTapMenu: (() -> Void)?
    var didTapAddStop: (() -> Void)?
    var didTapStart: (() -> Void)?
    
    lazy var label = makeLabel()
    lazy var menuButton = makeIconButton(iconName: "Navigator.RouteBuilder.Menu")
    lazy var closeButton = makeIconButton(iconName: "Navigator.RouteBuilder.Close")
    lazy var addStopButton = makeAddStopButton()
    lazy var startButton = makeStartButton()
    
    private lazy var infoAttrs = TextAttributes()
        .textColor(Appearance.color_FFFFFF)
        .font(Fonts.Inter.bold(size: 20.landscapeHScale))
        .textAlignment(.left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension RBPInfoView {
    func setup(route: NavigatorRoute) {
        let formattedDuration: String = {
            let totalMinutes = route.durationSeconds / 60
            let hours = totalMinutes / 60
            let minutes = totalMinutes % 60
            if hours > 0 {
                return "\(hours) \("hr".localized) \(minutes) \("min".localized)"
            }
            return "\(minutes) \("min".localized)"
        }()
        
        let formattedDistance = DistanceConverter.formattedDistance(
            Double(route.distanceMeters),
            unit: SettingsEnvironment.shared.distanceUnit
        )
        
        let info = String(format: "Navigator.RouteBuilderPreview.Info".localized, formattedDuration, formattedDistance)
        label.attributedText = info.attributed(with: infoAttrs)
    }
}

// MARK: Private
private extension RBPInfoView {
    func initialize() {
        backgroundColor = UIColor.clear
        
        menuButton.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    }
    
    @objc
    func closeTapped() {
        didTapClose?()
    }
    
    @objc
    func menuTapped() {
        didTapMenu?()
    }
    
    @objc
    func addStopTapped() {
        didTapAddStop?()
    }
    
    @objc
    func startTapped() {
        didTapStart?()
    }
}

// MARK: Make constraints
private extension RBPInfoView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.landscapeHScale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16.landscapeHScale)
        ])
        
        NSLayoutConstraint.activate([
            menuButton.widthAnchor.constraint(equalToConstant: 40.landscapeHScale),
            menuButton.heightAnchor.constraint(equalToConstant: 40.landscapeHScale),
            menuButton.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            menuButton.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -12.landscapeHScale)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 40.landscapeHScale),
            closeButton.heightAnchor.constraint(equalToConstant: 40.landscapeHScale),
            closeButton.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.landscapeHScale)
        ])
        
        NSLayoutConstraint.activate([
            addStopButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.landscapeHScale),
            addStopButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.landscapeHScale),
            addStopButton.widthAnchor.constraint(equalToConstant: 140.landscapeHScale),
            addStopButton.heightAnchor.constraint(equalToConstant: 48.landscapeHScale)
        ])
        
        NSLayoutConstraint.activate([
            startButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.landscapeHScale),
            startButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.landscapeHScale),
            startButton.widthAnchor.constraint(equalToConstant: 140.landscapeHScale),
            startButton.heightAnchor.constraint(equalToConstant: 48.landscapeHScale)
        ])
    }
}

// MARK: Lazy initialization
private extension RBPInfoView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIconButton(iconName: String) -> RBPIconButton {
        let view = RBPIconButton(iconName: iconName)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAddStopButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.bold(size: 20.landscapeHScale))
            .textAlignment(.center)
        
        let view = UIButton()
        view.setAttributedTitle("Navigator.RouteBuilderPreview.AddStop".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 10.landscapeHScale
        view.backgroundColor = Appearance.color_FFFFFF.withAlphaComponent(0.16)
        view.addTarget(self, action: #selector(addStopTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeStartButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.bold(size: 20.landscapeHScale))
            .textAlignment(.center)
        
        let view = UIButton()
        view.setAttributedTitle("Navigator.RouteBuilderPreview.Start".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 10.landscapeHScale
        view.backgroundColor = Appearance.color_4178F6
        view.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
