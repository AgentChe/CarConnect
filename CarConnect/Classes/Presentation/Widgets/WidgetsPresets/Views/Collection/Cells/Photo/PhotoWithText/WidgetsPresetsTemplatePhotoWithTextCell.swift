//
//  WidgetsPresetsTemplatePhotoWithTextCell.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 04.04.2026.
//

import UIKit

final class WidgetsPresetsTemplatePhotoWithTextCell: UICollectionViewCell {
    lazy var view = makeView()
    
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
extension WidgetsPresetsTemplatePhotoWithTextCell {
    func setup(configuration: WidgetPhotoWithTextConfiguration) {
        view.setup(configuration: configuration)
    }
}

// MARK: Private
private extension WidgetsPresetsTemplatePhotoWithTextCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension WidgetsPresetsTemplatePhotoWithTextCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPresetsTemplatePhotoWithTextCell {
    func makeView() -> PhotoWithTextView {
        let view = PhotoWithTextView(metrics: .small)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
