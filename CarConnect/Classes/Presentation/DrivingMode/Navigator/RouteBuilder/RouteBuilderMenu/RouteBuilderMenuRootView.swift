//
//  RouteBuilderMenuRootView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.05.2026.
//

import UIKit

final class RouteBuilderMenuRootView: UIView {
    lazy var blurView = makeBlurView()
    lazy var overlayView = makeOverlayView()
    lazy var titleLabel = makeTitleLabel()
    lazy var closeButton = makeCloseButton()
    lazy var separator = makeSeparator()
    lazy var addStopButton = makeRouteButton(
        title: "Navigator.RouteBuilderMenu.AddStop".localized,
        separatorHidden: false
    )
    lazy var routeOptionsButton = makeRouteButton(
        title: "Navigator.RouteBuilderMenu.RouteOptions".localized,
        separatorHidden: false
    )
    lazy var setDepartureTimeButton = makeRouteButton(
        title: "Navigator.RouteBuilderMenu.SetDepartureTime".localized,
        separatorHidden: true
    )
    
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
private extension RouteBuilderMenuRootView {
    func initialize() {
        layer.cornerRadius = 10.landscapeHScale
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension RouteBuilderMenuRootView {
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
            addStopButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            addStopButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            addStopButton.topAnchor.constraint(equalTo: separator.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            routeOptionsButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            routeOptionsButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            routeOptionsButton.topAnchor.constraint(equalTo: addStopButton.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            setDepartureTimeButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            setDepartureTimeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            setDepartureTimeButton.topAnchor.constraint(equalTo: routeOptionsButton.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension RouteBuilderMenuRootView {
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
        view.attributedText = "Navigator.RouteBuilderMenu.Title".localized.attributed(with: attrs)
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
    
    func makeRouteButton(title: String, separatorHidden: Bool) -> RouteBuilderMenuOptionButton {
        let view = RouteBuilderMenuOptionButton(title: title, separatorHidden: separatorHidden)
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
}
