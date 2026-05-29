//
//  RBPErrorView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 29.05.2026.
//

import UIKit

final class RBPErrorView: UIView {
    var didTapClose: (() -> Void)?
    var didTapTryAgain: (() -> Void)?
    
    lazy var closeButton = makeCloseButton()
    lazy var label = makeLabel()
    lazy var tryAgainButton = makeTryAgainButton()
    
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
private extension RBPErrorView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    @objc
    func closeTapped() {
        didTapClose?()
    }
    
    @objc
    func tryAgainTapped() {
        didTapTryAgain?()
    }
}

// MARK: Make constraints
private extension RBPErrorView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.landscapeHScale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.landscapeHScale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.landscapeHScale),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 16.landscapeHScale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.landscapeHScale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.landscapeHScale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16.landscapeHScale)
        ])
        
        NSLayoutConstraint.activate([
            tryAgainButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            tryAgainButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.landscapeHScale),
            tryAgainButton.widthAnchor.constraint(equalToConstant: 140.landscapeHScale),
            tryAgainButton.heightAnchor.constraint(equalToConstant: 48.landscapeHScale)
        ])
    }
}

// MARK: Lazy initialization
private extension RBPErrorView {
    func makeCloseButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Navigator.RouteBuilder.Close"), for: .normal)
        view.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.bold(size: 20.landscapeHScale))
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Navigator.RouteBuilderPreview.Error.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTryAgainButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.bold(size: 20.landscapeHScale))
        
        let view = UIButton()
        view.setAttributedTitle("Navigator.RouteBuilderPreview.Error.Action".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 10.landscapeHScale
        view.backgroundColor = Appearance.color_4178F6
        view.addTarget(self, action: #selector(tryAgainTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
