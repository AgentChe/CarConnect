//
//  RouteOptionsRootView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.05.2026.
//

import UIKit

final class RouteOptionsRootView: UIView {
    lazy var blurView = makeBlurView()
    lazy var overlayView = makeOverlayView()
    lazy var titleLabel = makeTitleLabel()
    lazy var closeButton = makeCloseButton()
    lazy var separator = makeSeparator()
    lazy var scrollView = makeScrollView()
    lazy var avoidTollsView = makeItemSelectView(
        title: "Navigator.RouteOptions.AvoidTolls".localized,
        isOn: initialOptions.avoidTolls,
        separatorHidden: false
    )
    lazy var avoidHighwaysView = makeItemSelectView(
        title: "Navigator.RouteOptions.AvoidHighways".localized,
        isOn: initialOptions.avoidHighways,
        separatorHidden: false
    )
    lazy var policeView = makeItemSelectView(
        title: "Navigator.RouteOptions.Police".localized,
        isOn: initialOptions.police,
        separatorHidden: false
    )
    lazy var speedCamerasView = makeItemSelectView(
        title: "Navigator.RouteOptions.SpeedCameras".localized,
        isOn: initialOptions.speedCameras,
        separatorHidden: false
    )
    lazy var trafficView = makeItemSelectView(
        title: "Navigator.RouteOptions.Traffic".localized,
        isOn: initialOptions.traffic,
        separatorHidden: true
    )
    
    private let initialOptions: RouteOptions
    
    init(options: RouteOptions) {
        initialOptions = options
        
        super.init(frame: .zero)

        makeConstraints()
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension RouteOptionsRootView {
    func initialize() {
        layer.cornerRadius = 10.landscapeHScale
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension RouteOptionsRootView {
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
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.landscapeHScale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.landscapeHScale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.landscapeVScale)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.landscapeHScale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.landscapeHScale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.landscapeHScale),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20.landscapeVScale),
            separator.heightAnchor.constraint(equalToConstant: 1.landscapeVScale)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: separator.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            avoidTollsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            avoidTollsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            avoidTollsView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            avoidTollsView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            avoidTollsView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            avoidHighwaysView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            avoidHighwaysView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            avoidHighwaysView.topAnchor.constraint(equalTo: avoidTollsView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            policeView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            policeView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            policeView.topAnchor.constraint(equalTo: avoidHighwaysView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            speedCamerasView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            speedCamerasView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            speedCamerasView.topAnchor.constraint(equalTo: policeView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            trafficView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            trafficView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            trafficView.topAnchor.constraint(equalTo: speedCamerasView.bottomAnchor),
            trafficView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension RouteOptionsRootView {
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
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.bold(size: 20.landscapeHScale))
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Navigator.RouteOptions.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.dx = -10.landscapeHScale
        view.dy = -10.landscapeHScale
        view.setImage(UIImage(named: "Navigator.RouteBuilder.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.color_FFFFFF.withAlphaComponent(0.04)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.contentInset = UIEdgeInsets()
        view.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeItemSelectView(title: String, isOn: Bool, separatorHidden: Bool) -> RouteOptionsItemSelectView {
        let view = RouteOptionsItemSelectView(title: title, isOn: isOn, separatorHidden: separatorHidden)
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
}
