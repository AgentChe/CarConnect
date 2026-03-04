//
//  WidgetTextManuallyResultView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 04.03.2026.
//

import UIKit
import Photos

final class WidgetTextManuallyResultView: GradientView {
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
    
    private var configuration: WidgetTextManuallyConfiguration?
    private var photoRequestId: PHImageRequestID?
    
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
extension WidgetTextManuallyResultView {
    func setup(configuration: WidgetTextManuallyConfiguration) {
        updateText(configuration: configuration)
        updateBackgroundIfNeeded(configuration: configuration)
        
        self.configuration = configuration
    }
    
    func makeSnapshot() -> UIImage? {
        let targetBounds = bounds
        
        guard targetBounds.width > 0, targetBounds.height > 0 else { return nil }

        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        format.opaque = isOpaque

        let renderer = UIGraphicsImageRenderer(size: targetBounds.size, format: format)

        if window != nil {
            return renderer.image { _ in
                drawHierarchy(in: targetBounds, afterScreenUpdates: true)
            }
        } else {
            return renderer.image { ctx in
                layer.render(in: ctx.cgContext)
            }
        }
    }
}

// MARK: Private
private extension WidgetTextManuallyResultView {
    func initialize() {
        layer.cornerRadius = 10.scale
        layer.masksToBounds = true
    }
    
    func updateText(configuration: WidgetTextManuallyConfiguration) {
        let attrs = TextAttributes()
            .textColor(configuration.textColor)
            .font(configuration.font.uiFont(baseSize: 40.scale))
            .textAlignment(.center)
        label.attributedText = configuration.text.attributed(with: attrs)
    }
    
    func updateBackgroundIfNeeded(configuration: WidgetTextManuallyConfiguration) {
        if let current = self.configuration?.background, current.isEqual(another: configuration.background) {
            return 
        }
        
        if let id = photoRequestId {
            PhotoAssetImageLoader.shared.cancel(id)
            photoRequestId = nil
        }
        
        switch configuration.background {
        case .color(let codableColor):
            imageView.isHidden = true
            imageView.image = nil

            backgroundColor = codableColor.wrappedValue
            
            gradientLayer.colors = nil
        case .gradient(let codableColors):
            imageView.isHidden = true
            imageView.image = nil

            backgroundColor = .clear
            
            gradientLayer.colors = codableColors.map { $0.wrappedValue.cgColor }
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint   = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.locations = [NSNumber(value: 0), NSNumber(value: 1)]
        case .fileName(let fileName):
            imageView.isHidden = false
            imageView.image = SharedImageFileStore.shared.loadImage(fileName: fileName)

            backgroundColor = .clear
            gradientLayer.colors = nil
        case .photoAssetId(let assetId):
            imageView.isHidden = false
            imageView.image = nil

            backgroundColor = .clear
            gradientLayer.colors = nil
            
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
    }
}

// MARK: Make constraints
private extension WidgetTextManuallyResultView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetTextManuallyResultView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
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
