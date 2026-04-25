//
//  WidgetsPresetsTemplateCarouselCell.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 05.04.2026.
//

import UIKit

final class WidgetsPresetsTemplateCarouselCell: UICollectionViewCell {
    lazy var photoCarouselView = makePhotoCarouselView()
    
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
extension WidgetsPresetsTemplateCarouselCell {
    func setup(configuration: WidgetPhotoCarouselConfiguration) {
        photoCarouselView.setup(configuration: configuration)
    }
}

// MARK: Private
private extension WidgetsPresetsTemplateCarouselCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension WidgetsPresetsTemplateCarouselCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            photoCarouselView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoCarouselView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoCarouselView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoCarouselView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPresetsTemplateCarouselCell {
    func makePhotoCarouselView() -> PhotoCarouselView {
        let view = PhotoCarouselView(metrics: .small)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
