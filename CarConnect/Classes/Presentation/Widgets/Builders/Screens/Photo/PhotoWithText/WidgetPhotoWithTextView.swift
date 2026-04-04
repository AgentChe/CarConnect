//
//  WidgetPhotoWithTextView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 04.04.2026.
//

import UIKit

final class WidgetPhotoWithTextView: UIView {
    lazy var scrollView = makeScrollView()
    lazy var container = makeContainer()
    lazy var photoWithTextView = makePhotoWithTextView()
    lazy var previewWidgetButton = makePreviewWidgetButton()
    lazy var photosView = makeBackgroundPhotoView()
    lazy var textField = makeTextField()
    lazy var fontView = makeFontView()
    lazy var textColorView = makeTextColorView()
    lazy var restoreDefaultButton = makeRestoreDefaultButton()
    lazy var helperButton = makeHelperButton()
    lazy var removeButton = makeRemoveButton()
    
    private let editableMode: Bool
    private let configuration: WidgetPhotoWithTextConfiguration
    
    init(editableMode: Bool, configuration: WidgetPhotoWithTextConfiguration) {
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
extension WidgetPhotoWithTextView {
    func setup(configuration: WidgetPhotoWithTextConfiguration, defaultConfiguration: WidgetPhotoWithTextConfiguration) {
        photoWithTextView.setup(configuration: configuration)
        photosView.setup(selectedPhoto: configuration.photo, defaultPhoto: defaultConfiguration.photo)
        fontView.setup(selectedFont: configuration.font, defaultFont: defaultConfiguration.font)
        textColorView.setup(selectedColor: configuration.textColor.wrappedValue, defaultColor: defaultConfiguration.textColor.wrappedValue)
    }
    
    func makeSnapshotResultView() -> UIImage? {
        let targetBounds = photoWithTextView.bounds
        guard targetBounds.width > 0, targetBounds.height > 0 else { return nil }

        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        format.opaque = photoWithTextView.isOpaque

        let renderer = UIGraphicsImageRenderer(size: targetBounds.size, format: format)

        if photoWithTextView.window != nil {
            return renderer.image { _ in
                photoWithTextView.drawHierarchy(in: targetBounds, afterScreenUpdates: true)
            }
        } else {
            return renderer.image { ctx in
                photoWithTextView.layer.render(in: ctx.cgContext)
            }
        }
    }
}

// MARK: Private
private extension WidgetPhotoWithTextView {
    func initialize() {
        backgroundColor = Appearance.color_21232A
    }
}

// MARK: Make constraints
private extension WidgetPhotoWithTextView {
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
            photoWithTextView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            photoWithTextView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            photoWithTextView.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.scale),
            photoWithTextView.heightAnchor.constraint(equalTo: photoWithTextView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            previewWidgetButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            previewWidgetButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            previewWidgetButton.heightAnchor.constraint(equalToConstant: 51.scale),
            previewWidgetButton.topAnchor.constraint(equalTo: photoWithTextView.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            photosView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            photosView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            photosView.heightAnchor.constraint(equalToConstant: 86.scale),
            photosView.topAnchor.constraint(equalTo: previewWidgetButton.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 86.scale),
            textField.topAnchor.constraint(equalTo: photosView.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            fontView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            fontView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            fontView.heightAnchor.constraint(equalToConstant: 86.scale),
            fontView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            textColorView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            textColorView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            textColorView.heightAnchor.constraint(equalToConstant: 86.scale),
            textColorView.topAnchor.constraint(equalTo: fontView.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            restoreDefaultButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            restoreDefaultButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            restoreDefaultButton.heightAnchor.constraint(equalToConstant: 51.scale),
            restoreDefaultButton.topAnchor.constraint(equalTo: textColorView.bottomAnchor, constant: 32.scale)
        ])
        
        if let helperButton {
            NSLayoutConstraint.activate([
                helperButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
                helperButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
                helperButton.heightAnchor.constraint(equalToConstant: 51.scale),
                helperButton.topAnchor.constraint(equalTo: restoreDefaultButton.bottomAnchor, constant: 12.scale),
                helperButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
        }
        
        if let removeButton {
            NSLayoutConstraint.activate([
                removeButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
                removeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
                removeButton.heightAnchor.constraint(equalToConstant: 51.scale),
                removeButton.topAnchor.constraint(equalTo: restoreDefaultButton.bottomAnchor, constant: 12.scale),
                removeButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
        }
    }
}

// MARK: Lazy initialization
private extension WidgetPhotoWithTextView {
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
    
    func makePhotoWithTextView() -> PhotoWithTextView {
        let view = PhotoWithTextView(metrics: .large)
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
    
    func makeBackgroundPhotoView() -> WidgetBuilderPhotoView {
        let view = WidgetBuilderPhotoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeTextField() -> WidgetBuilderTextField {
        let view = WidgetBuilderTextField(
            title: "WidgetsBuilders.PhotoWithText.Placeholder".localized,
            text: configuration.text,
            placeholder: "WidgetsBuilders.PhotoWithText.Placeholder".localized,
            limit: 50
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeFontView() -> WidgetBuilderFontView {
        let view = WidgetBuilderFontView()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeTextColorView() -> WidgetBuilderFontColorView {
        let view = WidgetBuilderFontColorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeRestoreDefaultButton() -> WidgetBuilderRestoreDefaultButton {
        let view = WidgetBuilderRestoreDefaultButton()
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
