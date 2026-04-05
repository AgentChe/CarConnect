//
//  WidgetAIPhotoMyCarView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 05.04.2026.
//

import UIKit
import Kingfisher

final class WidgetAIPhotoMyCarView: UIView {
    lazy var scrollView = makeScrollView()
    lazy var container = makeContainer()
    lazy var imageView = makeImageView()
    lazy var previewWidgetButton = makePreviewWidgetButton()
    lazy var helperButton = makeHelperButton()
    lazy var removeButton = makeRemoveButton()
    
    private let editableMode: Bool
    private let configuration: WidgetAIPhotoMyCarConfiguration
    
    init(editableMode: Bool, configuration: WidgetAIPhotoMyCarConfiguration) {
        self.editableMode = editableMode
        self.configuration = configuration
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WidgetAIPhotoMyCarView {
    func makeSnapshotResultView() -> UIImage? {
        let targetBounds = imageView.bounds
        guard targetBounds.width > 0, targetBounds.height > 0 else { return nil }

        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        format.opaque = imageView.isOpaque

        let renderer = UIGraphicsImageRenderer(size: targetBounds.size, format: format)

        if imageView.window != nil {
            return renderer.image { _ in
                imageView.drawHierarchy(in: targetBounds, afterScreenUpdates: true)
            }
        } else {
            return renderer.image { ctx in
                imageView.layer.render(in: ctx.cgContext)
            }
        }
    }
}

// MARK: Private
private extension WidgetAIPhotoMyCarView {
    func initialize() {
        backgroundColor = Appearance.color_21232A
    }
}

// MARK: Make constraints
private extension WidgetAIPhotoMyCarView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            container.topAnchor.constraint(equalTo: scrollView.topAnchor),
            container.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            imageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.scale),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            previewWidgetButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            previewWidgetButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            previewWidgetButton.heightAnchor.constraint(equalToConstant: 51.scale),
            previewWidgetButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12.scale),
        ])
        
        if let helperButton {
            NSLayoutConstraint.activate([
                helperButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
                helperButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
                helperButton.heightAnchor.constraint(equalToConstant: 51.scale),
                helperButton.topAnchor.constraint(equalTo: previewWidgetButton.bottomAnchor, constant: 32.scale),
                helperButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
        }
        
        if let removeButton {
            NSLayoutConstraint.activate([
                removeButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
                removeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
                removeButton.heightAnchor.constraint(equalToConstant: 51.scale),
                removeButton.topAnchor.constraint(equalTo: previewWidgetButton.bottomAnchor, constant: 32.scale),
                removeButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
        }
    }
}

// MARK: Lazy initialization
private extension WidgetAIPhotoMyCarView {
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.contentInset = UIEdgeInsets(vertical: 8.scale)
        view.setContentOffset(CGPoint(x: 0, y: 8.scale), animated: false)
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.kf.setImage(with: configuration.url)
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makePreviewWidgetButton() -> WidgetBuilderPreviewWidgetButton {
        let view = WidgetBuilderPreviewWidgetButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeHelperButton() -> WidgetBuilderHelperButton? {
        guard !editableMode else { return nil }
        
        let view = WidgetBuilderHelperButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeRemoveButton() -> WidgetsBuilderRemoveButton? {
        guard editableMode else { return nil }
        
        let view = WidgetsBuilderRemoveButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
