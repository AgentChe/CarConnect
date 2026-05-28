//
//  RouteBuilderPreviewRootView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.05.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class RouteBuilderPreviewRootView: UIView {
    lazy var blurView = makeBlurView()
    lazy var overlayView = makeOverlayView()
    lazy var label = makeLabel()
    lazy var menuButton = makeIconButton(iconName: "Navigator.RouteBuilder.Menu")
    lazy var closeButton = makeIconButton(iconName: "Navigator.RouteBuilder.Close")
    lazy var addStopButton = makeAddStopButton()
    lazy var startButton = makeStartButton()
    lazy var preloader = makePreloader()
    
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
extension RouteBuilderPreviewRootView {
    func setup(route: NavigatorRoute?) {
        guard let route else {
            // TODO: отобразить другой UI с кнопкой повторить
            return
        }
        
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
private extension RouteBuilderPreviewRootView {
    func initialize() {
        layer.cornerRadius = 10.landscapeHScale
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension RouteBuilderPreviewRootView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
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
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension RouteBuilderPreviewRootView {
    func makeBlurView() -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialDark))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }

    func makeOverlayView() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.color_000000.withAlphaComponent(0.35)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
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
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.color = Appearance.color_FFFFFF
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
