//
//  SearchPlaceRootView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 26.05.2026.
//

import UIKit

final class SearchPlaceRootView: UIView {
    lazy var blurView = makeBlurView()
    lazy var overlayView = makeOverlayView()
    lazy var searchField = makeSearchField()
    lazy var closeButton = makeCloseButton()
    lazy var tableView = makeTableView()
    lazy var preloader = makePreloader()

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
private extension SearchPlaceRootView {
    func initialize() {
        layer.cornerRadius = 10.landscapeHScale
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension SearchPlaceRootView {
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
            searchField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.landscapeHScale),
            searchField.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -12.landscapeHScale),
            searchField.topAnchor.constraint(equalTo: topAnchor, constant: 16.landscapeVScale),
            searchField.heightAnchor.constraint(equalToConstant: 40.landscapeVScale)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.landscapeHScale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.landscapeHScale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.landscapeHScale),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 24.landscapeVScale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 2.landscapeVScale),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SearchPlaceRootView {
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
    
    func makeSearchField() -> SearchPlaceField {
        let view = SearchPlaceField()
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
    
    func makeTableView() -> SearchPlaceTableView {
        let view = SearchPlaceTableView()
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
