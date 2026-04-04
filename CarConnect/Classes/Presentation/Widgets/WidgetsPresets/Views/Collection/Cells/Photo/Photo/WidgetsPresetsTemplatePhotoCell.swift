//
//  WidgetsPresetsTemplatePhotoCell.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 04.04.2026.
//

import UIKit

final class WidgetsPresetsTemplatePhotoCell: UICollectionViewCell {
    lazy var backgroundColorView = makeBackgroundColorView()
    lazy var imageView = makeImageView()
    
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
extension WidgetsPresetsTemplatePhotoCell {
    func setup(configuration: WidgetPhotoConfiguration) {
        switch configuration.photo {
        case .assetName(let name):
            imageView.image = UIImage(named: name)
        case .fileName(let fileName):
            imageView.image = SharedImageFileStore.shared.loadImage(fileName: fileName)
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
    }
}

// MARK: Private
private extension WidgetsPresetsTemplatePhotoCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension WidgetsPresetsTemplatePhotoCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundColorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundColorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundColorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundColorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPresetsTemplatePhotoCell {
    func makeBackgroundColorView() -> GradientView {
        let view = GradientView()
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        view.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        view.gradientLayer.locations = [NSNumber(value: 0), NSNumber(value: 1)]
        view.gradientLayer.colors = [
            Appearance.color_373B47.cgColor,
            Appearance.color_2C2F39.cgColor
        ]
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
