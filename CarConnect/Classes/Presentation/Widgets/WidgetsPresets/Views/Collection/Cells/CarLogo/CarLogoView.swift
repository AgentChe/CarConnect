//
//  CarLogoView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 02.04.2026.
//

import UIKit
import Kingfisher

final class CarLogoView: UIView {
    lazy var backgroundColorView = makeBackgroundColorView()
    lazy var backgroundImageView = makeBackgroundImageView()
    lazy var logoView = makeLogoView()
    
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
extension CarLogoView {
    func setup(configuration: WidgetCarLogoConfiguration) {
        updateLogo(brand: configuration.brand)
        updateBackground(background: configuration.background)
    }
}

// MARK: Private
private extension CarLogoView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    func updateLogo(brand: WidgetCarLogoBrand) {
        logoView.kf.cancelDownloadTask()
        logoView.kf.setImage(with: brand.logo)
    }
    
    func updateBackground(background: WidgetBackground) {
        switch background {
        case .color(let codableColor):
            backgroundImageView.isHidden = true
            backgroundImageView.image = nil

            backgroundColorView.backgroundColor = codableColor.wrappedValue
            
            backgroundColorView.gradientLayer.colors = nil
        case .gradient(let codableColors):
            backgroundImageView.isHidden = true
            backgroundImageView.image = nil

            backgroundColorView.backgroundColor = .clear
            
            backgroundColorView.gradientLayer.colors = codableColors.map { $0.wrappedValue.cgColor }
            backgroundColorView.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            backgroundColorView.gradientLayer.endPoint   = CGPoint(x: 0.5, y: 1.0)
            backgroundColorView.gradientLayer.locations = [NSNumber(value: 0), NSNumber(value: 1)]
        case .fileName(let fileName):
            backgroundImageView.isHidden = false
            backgroundImageView.image = SharedImageFileStore.shared.loadImage(fileName: fileName)

            backgroundColorView.backgroundColor = .clear
            backgroundColorView.gradientLayer.colors = nil
        case .photoAssetId(let assetId):
            backgroundImageView.isHidden = false
            backgroundImageView.image = nil

            backgroundColorView.backgroundColor = .clear
            backgroundColorView.gradientLayer.colors = nil
            
            PhotoAssetImageLoader.shared.loadImage(
                assetId: assetId,
                targetSize: {
                    let scale = UIScreen.main.scale
                    return CGSize(
                        width: bounds.width * scale,
                        height: bounds.height * scale
                    )
                }()
            ) { [weak self] image in
                self?.backgroundImageView.image = image
            }
        }
    }
}

// MARK: Make constraints
private extension CarLogoView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundColorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundColorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundColorView.topAnchor.constraint(equalTo: topAnchor),
            backgroundColorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            logoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            logoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            logoView.topAnchor.constraint(equalTo: topAnchor),
            logoView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CarLogoView {
    func makeBackgroundColorView() -> GradientView {
        let view = GradientView()
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBackgroundImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLogoView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
