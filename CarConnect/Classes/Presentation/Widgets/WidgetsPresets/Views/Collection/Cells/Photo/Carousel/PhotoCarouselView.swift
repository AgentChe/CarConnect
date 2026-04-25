//
//  PhotoCarouselView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 05.04.2026.
//

import UIKit

final class PhotoCarouselView: UIView {
    enum Metrics {
        case small, large
    }
    
    lazy var backgroundPhotoView = makeBackgroundPhotoView()
    lazy var backgroundBlurView = makeBackgroundBlurView()
    lazy var photo1View = makePhotoView()
    lazy var photo2View = makePhotoView()
    lazy var photo3View = makePhotoView()
    
    private let metrics: Metrics
    
    init(metrics: Metrics) {
        self.metrics = metrics
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension PhotoCarouselView {
    func setup(configuration: WidgetPhotoCarouselConfiguration) {
        setup(photoView: backgroundPhotoView, photo: configuration.photo2)
        setup(photoView: photo1View.imageView, photo: configuration.photo1)
        setup(photoView: photo2View.imageView, photo: configuration.photo2)
        setup(photoView: photo3View.imageView, photo: configuration.photo3)
    }
}

// MARK: Private
private extension PhotoCarouselView {
    func initialize() {
        backgroundColor = .clear
        layer.cornerRadius = 10.scale
        layer.masksToBounds = true
        
        backgroundBlurView.alpha = 0.8
    }
    
    func setup(photoView: UIImageView, photo: WidgetPhoto) {
        switch photo {
        case .assetName(let name):
            photoView.image = UIImage(named: name)
        case .fileName(let fileName):
            photoView.image = SharedImageFileStore.shared.loadImage(fileName: fileName)
        case .photoAssetId(let assetId):
            PhotoAssetImageLoader.shared.loadImage(
                assetId: assetId,
                targetSize: {
                    let scale = UIScreen.main.scale
                    return CGSize(
                        width: bounds.width * scale,
                        height: bounds.height * scale
                    )
                }()
            ) { [weak photoView] image in
                photoView?.image = image
            }
        }
    }
}

// MARK: Make constraints
private extension PhotoCarouselView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundPhotoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundPhotoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundPhotoView.topAnchor.constraint(equalTo: topAnchor),
            backgroundPhotoView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            backgroundBlurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundBlurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundBlurView.topAnchor.constraint(equalTo: topAnchor),
            backgroundBlurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            photo1View.widthAnchor.constraint(equalToConstant: {
                switch metrics {
                case .small:
                    return 86.scale
                case .large:
                    return 178.scale
                }
            }()),
            photo1View.heightAnchor.constraint(equalToConstant: {
                switch metrics {
                case .small:
                    return 109.scale
                case .large:
                    return 225.scale
                }
            }()),
            photo1View.trailingAnchor.constraint(equalTo: photo2View.leadingAnchor, constant: {
                switch metrics {
                case .small:
                    return -4.scale
                case .large:
                    return -8.scale
                }
            }()),
            photo1View.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            photo2View.widthAnchor.constraint(equalToConstant: {
                switch metrics {
                case .small:
                    return 132.scale
                case .large:
                    return 273.scale
                }
            }()),
            photo2View.heightAnchor.constraint(equalToConstant: {
                switch metrics {
                case .small:
                    return 141.scale
                case .large:
                    return 293.scale
                }
            }()),
            photo2View.centerXAnchor.constraint(equalTo: centerXAnchor),
            photo2View.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            photo3View.widthAnchor.constraint(equalToConstant: {
                switch metrics {
                case .small:
                    return 86.scale
                case .large:
                    return 178.scale
                }
            }()),
            photo3View.heightAnchor.constraint(equalToConstant: {
                switch metrics {
                case .small:
                    return 109.scale
                case .large:
                    return 225.scale
                }
            }()),
            photo3View.leadingAnchor.constraint(equalTo: photo2View.trailingAnchor, constant: {
                switch metrics {
                case .small:
                    return 4.scale
                case .large:
                    return 8.scale
                }
            }()),
            photo3View.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension PhotoCarouselView {
    func makeBackgroundPhotoView() -> UIImageView {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBackgroundBlurView() -> UIVisualEffectView {
        let blur = UIBlurEffect(style: .systemUltraThinMaterial)
        let view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePhotoView() -> ShadowImageView {
        let view = ShadowImageView(cornerRadius: {
            switch metrics {
            case .small:
                return 4.scale
            case .large:
                return 8.scale
            }
        }())
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

final class ShadowImageView: UIView {
    let imageView = UIImageView()

    init(cornerRadius: CGFloat) {
        super.init(frame: .zero)

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.12
        layer.shadowRadius = 8.scale
        layer.shadowOffset = CGSize(width: 0, height: 2.scale)

        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
