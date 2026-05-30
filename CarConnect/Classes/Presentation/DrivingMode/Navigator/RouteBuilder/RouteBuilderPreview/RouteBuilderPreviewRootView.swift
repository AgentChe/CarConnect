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
    
    private var infoView: RBPInfoView?
    private var errorView: RBPErrorView?
    private var preloader: UIActivityIndicatorView?
    
    private lazy var didTapCloseTrigger = PublishRelay<Void>()
    private lazy var didTapMenuTrigger = PublishRelay<Void>()
    private lazy var didTapAddStopTrigger = PublishRelay<Void>()
    private lazy var didTapStartTrigger = PublishRelay<Void>()
    private lazy var didTapTryAgainTrigger = PublishRelay<Void>()

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
    func preloader(activity: Bool) {
        if activity {
            guard preloader == nil else { return }
            
            let view = UIActivityIndicatorView(style: .large)
            view.color = Appearance.color_FFFFFF
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            
            NSLayoutConstraint.activate([
                view.centerXAnchor.constraint(equalTo: centerXAnchor),
                view.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
            
            view.startAnimating()
            
            preloader = view
        } else {
            preloader?.removeFromSuperview()
            preloader = nil 
        }
    }
    
    func setup(route: NavigatorRoute?) {
        if let route {
            displayInfo(route: route)
        } else {
            displayError()
        }
    }
    
    var didTapClose: Signal<Void> {
        didTapCloseTrigger.asSignal()
    }
    
    var didTapMenu: Signal<Void> {
        didTapMenuTrigger.asSignal()
    }
    
    var didTapAddStop: Signal<Void> {
        didTapAddStopTrigger.asSignal()
    }
    
    var didTapStart: Signal<Void> {
        didTapStartTrigger.asSignal()
    }
    
    var didTapTryAgain: Signal<Void> {
        didTapTryAgainTrigger.asSignal()
    }
}

// MARK: Private
private extension RouteBuilderPreviewRootView {
    func initialize() {
        layer.cornerRadius = 10.landscapeHScale
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.masksToBounds = true
    }
    
    func displayInfo(route: NavigatorRoute) {
        errorView?.removeFromSuperview()
        errorView = nil
        
        let view: RBPInfoView = {
            if let infoView {
                return infoView
            }
            
            let view = RBPInfoView()
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor),
                view.topAnchor.constraint(equalTo: topAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
            
            infoView = view
            
            return view
        }()
        
        view.setup(route: route)
        
        view.didTapClose = { [weak self] in
            self?.didTapCloseTrigger.accept(Void())
        }
        
        view.didTapMenu = { [weak self] in
            self?.didTapMenuTrigger.accept(Void())
        }
        
        view.didTapAddStop = { [weak self] in
            self?.didTapAddStopTrigger.accept(Void())
        }
        
        view.didTapStart = { [weak self] in
            self?.didTapStartTrigger.accept(Void())
        }
    }
    
    func displayError() {
        infoView?.removeFromSuperview()
        infoView = nil
        
        let view: RBPErrorView = {
            if let errorView {
                return errorView
            }
            
            let view = RBPErrorView()
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor),
                view.topAnchor.constraint(equalTo: topAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
            
            errorView = view
            
            return view
        }()
        
        view.didTapClose = { [weak self] in
            self?.didTapCloseTrigger.accept(Void())
        }
        
        view.didTapTryAgain = { [weak self] in
            self?.didTapTryAgainTrigger.accept(Void())
            
            self?.errorView?.removeFromSuperview()
            self?.errorView = nil
        }
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
}
