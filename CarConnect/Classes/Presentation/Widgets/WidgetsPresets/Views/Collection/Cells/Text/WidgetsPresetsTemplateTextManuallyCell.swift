//
//  WidgetsPresetsTemplateTextManuallyCell.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.02.2026.
//

import UIKit

final class WidgetsPresetsTemplateTextManuallyCell: UICollectionViewCell {
    lazy var container = makeContainer()
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
    
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
extension WidgetsPresetsTemplateTextManuallyCell {
    func setup(configuration: WidgetTextManuallyConfiguration) {
        updateText(configuration: configuration)
        updateBackgroundIfNeeded(configuration: configuration)
    }
}

// MARK: Private
private extension WidgetsPresetsTemplateTextManuallyCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
    
    func updateText(configuration: WidgetTextManuallyConfiguration) {
        let attrs = TextAttributes()
            .textColor(configuration.textColor)
            .font(configuration.font.uiFont(baseSize: 28.scale))
            .textAlignment(.center)
        label.attributedText = configuration.text.attributed(with: attrs)
    }
    
    func updateBackgroundIfNeeded(configuration: WidgetTextManuallyConfiguration) {
        switch configuration.background {
        case .color(let codableColor):
            imageView.isHidden = true
            imageView.image = nil

            container.backgroundColor = codableColor.wrappedValue
            
            container.gradientLayer.colors = nil
        case .gradient(let codableColors):
            imageView.isHidden = true
            imageView.image = nil

            container.backgroundColor = .clear
            
            container.gradientLayer.colors = codableColors.map { $0.wrappedValue.cgColor }
            container.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            container.gradientLayer.endPoint   = CGPoint(x: 0.5, y: 1.0)
            container.gradientLayer.locations = [NSNumber(value: 0), NSNumber(value: 1)]
        case .fileName(let fileName):
            imageView.isHidden = false
            imageView.image = SharedImageFileStore.shared.loadImage(fileName: fileName)

            container.backgroundColor = .clear
            container.gradientLayer.colors = nil
        case .photoAssetId(let assetId):
            imageView.isHidden = false
            imageView.image = nil

            container.backgroundColor = .clear
            container.gradientLayer.colors = nil
            
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
private extension WidgetsPresetsTemplateTextManuallyCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.scale),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.scale),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPresetsTemplateTextManuallyCell {
    func makeContainer() -> GradientView {
        let view = GradientView()
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.color_2C2F39.cgColor
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.color_2C2F39.cgColor
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
