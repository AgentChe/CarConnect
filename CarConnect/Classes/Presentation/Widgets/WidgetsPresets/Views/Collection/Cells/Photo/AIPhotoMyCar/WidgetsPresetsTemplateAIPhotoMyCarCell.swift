//
//  WidgetsPresetsTemplateAIPhotoMyCarCell.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 05.04.2026.
//

import UIKit
import Kingfisher

final class WidgetsPresetsTemplateAIPhotoMyCarCell: UICollectionViewCell {
    lazy var imageView = makeImageView()
    lazy var aiGeneratedView = makeAIGeneratedView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
}

// MARK: Public
extension WidgetsPresetsTemplateAIPhotoMyCarCell {
    func setup(configuration: WidgetAIPhotoMyCarConfiguration) {
        imageView.kf.setImage(with: configuration.url)
    }
}

// MARK: Private
private extension WidgetsPresetsTemplateAIPhotoMyCarCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension WidgetsPresetsTemplateAIPhotoMyCarCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            aiGeneratedView.widthAnchor.constraint(equalToConstant: 48.scale),
            aiGeneratedView.heightAnchor.constraint(equalToConstant: 26.scale),
            aiGeneratedView.topAnchor.constraint(equalTo: topAnchor, constant: 8.scale),
            aiGeneratedView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPresetsTemplateAIPhotoMyCarCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeAIGeneratedView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "WidgetsPresents.AIGenerated")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
