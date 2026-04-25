//
//  PhotoWithTextView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 04.04.2026.
//

import UIKit

final class PhotoWithTextView: UIView {
    enum Metrics {
        case small, large
    }
    
    lazy var imageView = makeImageView()
    lazy var gradientView = makeGradientView()
    lazy var label = makeLabel()
    
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
extension PhotoWithTextView {
    func setup(configuration: WidgetPhotoWithTextConfiguration) {
        switch configuration.photo {
        case .assetName(let name):
            imageView.image = UIImage(named: name)
        case .fileName(let name):
            imageView.image = SharedImageFileStore.shared.loadImage(fileName: name)
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
            ) { [weak self] image in
                self?.imageView.image = image
            }
        }
        
        let attrs = TextAttributes()
            .textColor(configuration.textColor.wrappedValue)
            .font(configuration.font.uiFont(baseSize: {
                switch metrics {
                case .small:
                    return 20.scale
                case .large:
                    return 40.scale
                }
            }()))
            .textAlignment(.left)
        label.attributedText = configuration.text.attributed(with: attrs)
    }
}

// MARK: Private
private extension PhotoWithTextView {
    func initialize() {
        backgroundColor = UIColor.clear
        layer.cornerRadius = 10.scale
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension PhotoWithTextView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.topAnchor.constraint(equalTo: topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: {
                switch metrics {
                case .small:
                    return 12.scale
                case .large:
                    return 24.scale
                }
            }()),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: {
                switch metrics {
                case .small:
                    return -12.scale
                case .large:
                    return -24.scale
                }
            }()),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: {
                switch metrics {
                case .small:
                    return -12.scale
                case .large:
                    return -24.scale
                }
            }()),
        ])
    }
}

// MARK: Lazy initialization
private extension PhotoWithTextView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeGradientView() -> GradientView {
        let view = GradientView()
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.gradientLayer.cornerRadius = 10.scale
        view.gradientLayer.masksToBounds = true
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        view.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.gradientLayer.locations = [
            NSNumber(value: 0),
            NSNumber(value: 1)
        ]
        view.gradientLayer.colors = [
            Appearance.color_2E2E2E.withAlphaComponent(0).cgColor,
            Appearance.color_242424.withAlphaComponent(0.4).cgColor,
        ]
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
