//
//  WidgetBuilderPhotoItemButton.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 04.04.2026.
//

import UIKit

final class WidgetBuilderPhotoItemButton: UIButton {
    lazy var iconView = makeIconView()
    
    let photo: WidgetPhoto
    
    init(photo: WidgetPhoto) {
        self.photo = photo
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WidgetBuilderPhotoItemButton {
    func setup(selected: Bool) {
        layer.borderWidth = selected ? 2.scale : 0
        layer.borderColor = selected ? Appearance.color_4178F6.cgColor : UIColor.clear.cgColor
    }
}

// MARK: Private
private extension WidgetBuilderPhotoItemButton {
    func initialize() {
        backgroundColor = Appearance.color_868EB2.withAlphaComponent(0.1)
        layer.cornerRadius = 10.scale
        layer.masksToBounds = true
        
        switch photo {
        case .assetName(let name):
            iconView.image = UIImage(named: name)
        case .fileName(let name):
            iconView.image = SharedImageFileStore.shared.loadImage(fileName: name)
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
                self?.iconView.image = image
            }
        }
    }
}

// MARK: Make Constraints
private extension WidgetBuilderPhotoItemButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconView.trailingAnchor.constraint(equalTo: trailingAnchor),
            iconView.topAnchor.constraint(equalTo: topAnchor),
            iconView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetBuilderPhotoItemButton {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = false
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
