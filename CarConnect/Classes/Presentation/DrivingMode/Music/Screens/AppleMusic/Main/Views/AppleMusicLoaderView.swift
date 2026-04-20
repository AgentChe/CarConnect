//
//  AppleMusicLoaderView.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 20.04.2026.
//

import UIKit

class AppleMusicLoaderView: UIView {
    private lazy var loaderImage = makeLoaderImage()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AppleMusicLoaderView {
    func initialize() {
        backgroundColor = .clear
        isHidden = true
    }
    
    func startSpinningAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = 1.0
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        loaderImage.layer.add(rotationAnimation, forKey: "rotationAnimation")
        isHidden = false
    }
    
    func stopSpinningAnimation() {
        loaderImage.layer.removeAnimation(forKey: "rotationAnimation")
        isHidden = true
    }
}

private extension AppleMusicLoaderView {
    func makeConstrains() {
        NSLayoutConstraint.activate([
            loaderImage.topAnchor.constraint(equalTo: topAnchor),
            loaderImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            loaderImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            loaderImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            loaderImage.heightAnchor.constraint(equalToConstant: 24.landscapeVScale),
            loaderImage.widthAnchor.constraint(equalTo: loaderImage.heightAnchor)
        ])
    }
}

private extension AppleMusicLoaderView {
    func makeLoaderImage() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Library.Loader")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
