//
//  WidgetsPreviewView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.02.2026.
//

import UIKit

final class WidgetsPreviewView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var closeButton = makeCloseButton()
    lazy var tabView = makeTabView()
    lazy var carPlayView = makeCarPlayView()
    lazy var phoneView = makePhoneView()
    lazy var gradientView = makeGradientView()
    
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

// MARK: Private
private extension WidgetsPreviewView {
    func initialize() {
        backgroundColor = Appearance.color_21232A
    }
}

// MARK: Make constraints
private extension WidgetsPreviewView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 18.vScale)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tabView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            tabView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            tabView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 34.vScale),
            tabView.heightAnchor.constraint(equalToConstant: 48.scale)
        ])
        
        NSLayoutConstraint.activate([
            carPlayView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            carPlayView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            carPlayView.topAnchor.constraint(equalTo: tabView.bottomAnchor, constant: 12.vScale),
            carPlayView.heightAnchor.constraint(equalToConstant: 128.vScale)
        ])
        
        NSLayoutConstraint.activate([
            phoneView.leadingAnchor.constraint(equalTo: leadingAnchor),
            phoneView.trailingAnchor.constraint(equalTo: trailingAnchor),
            phoneView.topAnchor.constraint(equalTo: carPlayView.bottomAnchor, constant: 16.vScale),
            phoneView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 40.vScale)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPreviewView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(19.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "WidgetsPreview.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "WidgetsPreview.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTabView() -> WidgetsPreviewTabView {
        let view = WidgetsPreviewTabView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCarPlayView() -> WidgetsPreviewCarPlayView {
        let view = WidgetsPreviewCarPlayView(snapshot: snapshot)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePhoneView() -> WidgetsPreviewPhoneView {
        let view = WidgetsPreviewPhoneView(snapshot: snapshot)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeGradientView() -> GradientView {
        let view = GradientView()
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        view.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.gradientLayer.locations = [
            NSNumber(value: 0),
            NSNumber(value: 1)
        ]
        view.gradientLayer.colors = [
            Appearance.color_21232A.withAlphaComponent(0).cgColor,
            Appearance.color_21232A.cgColor
        ]
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
