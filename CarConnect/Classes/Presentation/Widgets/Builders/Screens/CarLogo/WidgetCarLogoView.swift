//
//  WidgetCarLogoView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 02.04.2026.
//

import UIKit

final class WidgetCarLogoView: UIView {
    lazy var scrollView = makeScrollView()
    lazy var container = makeContainer()
    lazy var carLogoView = makeCarLogoView()
    lazy var previewWidgetButton = makePreviewWidgetButton()
    lazy var brandsView = makeCarBrandsView()
    lazy var backgroundView = makeBackgroundView()
    lazy var restoreDefaultButton = makeRestoreDefaultButton()
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
extension WidgetCarLogoView {
    func setup(configuration: WidgetCarLogoConfiguration) {
        carLogoView.setup(configuration: configuration)
    }
    
    func makeSnapshotResultView() -> UIImage? {
        let targetBounds = carLogoView.bounds
        guard targetBounds.width > 0, targetBounds.height > 0 else { return nil }

        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        format.opaque = carLogoView.isOpaque

        let renderer = UIGraphicsImageRenderer(size: targetBounds.size, format: format)

        if carLogoView.window != nil {
            return renderer.image { _ in
                carLogoView.drawHierarchy(in: targetBounds, afterScreenUpdates: true)
            }
        } else {
            return renderer.image { ctx in
                carLogoView.layer.render(in: ctx.cgContext)
            }
        }
    }
}

// MARK: Private
private extension WidgetCarLogoView {
    func initialize() {
        backgroundColor = Appearance.color_21232A
    }
}

// MARK: Make constraints
private extension WidgetCarLogoView {
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
            carLogoView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            carLogoView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            carLogoView.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.scale),
            carLogoView.heightAnchor.constraint(equalTo: carLogoView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            previewWidgetButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            previewWidgetButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            previewWidgetButton.heightAnchor.constraint(equalToConstant: 51.scale),
            previewWidgetButton.topAnchor.constraint(equalTo: carLogoView.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            brandsView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            brandsView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            brandsView.heightAnchor.constraint(equalToConstant: 86.scale),
            brandsView.topAnchor.constraint(equalTo: previewWidgetButton.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 86.scale),
            backgroundView.topAnchor.constraint(equalTo: brandsView.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            restoreDefaultButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            restoreDefaultButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            restoreDefaultButton.heightAnchor.constraint(equalToConstant: 51.scale),
            restoreDefaultButton.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 32.scale)
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
private extension WidgetCarLogoView {
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
    
    func makeCarLogoView() -> CarLogoView {
        let view = CarLogoView()
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
    
    func makeCarBrandsView() -> WidgetBuilderCarBrandsView {
        let view = WidgetBuilderCarBrandsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeBackgroundView() -> WidgetBuilderBackgroundView {
        let view = WidgetBuilderBackgroundView()
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
