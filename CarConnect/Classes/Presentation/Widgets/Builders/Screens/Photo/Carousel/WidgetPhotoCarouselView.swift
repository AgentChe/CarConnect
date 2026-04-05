//
//  WidgetPhotoCarouselView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 05.04.2026.
//

import UIKit

final class WidgetPhotoCarouselView: UIView {
    lazy var scrollView = makeScrollView()
    lazy var container = makeContainer()
    lazy var previewView = makePreviewView()
    lazy var previewWidgetButton = makePreviewWidgetButton()
    lazy var photos1View = makePhotosView()
    lazy var photos2View = makePhotosView()
    lazy var photos3View = makePhotosView()
    lazy var helperButton = makeHelperButton()
    lazy var removeButton = makeRemoveButton()
    
    private let editableMode: Bool
    
    init(editableMode: Bool) {
        self.editableMode = editableMode
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WidgetPhotoCarouselView {
    func setup(configuration: WidgetPhotoCarouselConfiguration) {
        previewView.setup(configuration: configuration)
        
        photos1View.setup(selected: configuration.photo1)
        photos2View.setup(selected: configuration.photo2)
        photos3View.setup(selected: configuration.photo3)
    }
}

// MARK: Public
extension WidgetPhotoCarouselView {
    func makeSnapshotResultView() -> UIImage? {
        let targetBounds = previewView.bounds
        guard targetBounds.width > 0, targetBounds.height > 0 else { return nil }

        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        format.opaque = previewView.isOpaque

        let renderer = UIGraphicsImageRenderer(size: targetBounds.size, format: format)

        if previewView.window != nil {
            return renderer.image { _ in
                previewView.drawHierarchy(in: targetBounds, afterScreenUpdates: true)
            }
        } else {
            return renderer.image { ctx in
                previewView.layer.render(in: ctx.cgContext)
            }
        }
    }
}

// MARK: Private
private extension WidgetPhotoCarouselView {
    func initialize() {
        backgroundColor = Appearance.color_21232A
    }
}

// MARK: Make constraints
private extension WidgetPhotoCarouselView {
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
            previewView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            previewView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            previewView.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.scale),
            previewView.heightAnchor.constraint(equalTo: previewView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            previewWidgetButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            previewWidgetButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            previewWidgetButton.heightAnchor.constraint(equalToConstant: 51.scale),
            previewWidgetButton.topAnchor.constraint(equalTo: previewView.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            photos1View.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            photos1View.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            photos1View.heightAnchor.constraint(equalToConstant: 86.scale),
            photos1View.topAnchor.constraint(equalTo: previewWidgetButton.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            photos2View.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            photos2View.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            photos2View.heightAnchor.constraint(equalToConstant: 86.scale),
            photos2View.topAnchor.constraint(equalTo: photos1View.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            photos3View.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            photos3View.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            photos3View.heightAnchor.constraint(equalToConstant: 86.scale),
            photos3View.topAnchor.constraint(equalTo: photos2View.bottomAnchor, constant: 24.scale)
        ])
        
        if let helperButton {
            NSLayoutConstraint.activate([
                helperButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
                helperButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
                helperButton.heightAnchor.constraint(equalToConstant: 51.scale),
                helperButton.topAnchor.constraint(equalTo: photos3View.bottomAnchor, constant: 32.scale),
                helperButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
        }
        
        if let removeButton {
            NSLayoutConstraint.activate([
                removeButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
                removeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
                removeButton.heightAnchor.constraint(equalToConstant: 51.scale),
                removeButton.topAnchor.constraint(equalTo: photos3View.bottomAnchor, constant: 32.scale),
                removeButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
        }
    }
}

// MARK: Lazy initialization
private extension WidgetPhotoCarouselView {
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
    
    func makePreviewView() -> PhotoCarouselView {
        let view = PhotoCarouselView(metrics: .large)
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
    
    func makePhotosView() -> WidgetBuilderPhotoView {
        let view = WidgetBuilderPhotoView()
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
