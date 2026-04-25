//
//  WidgetAIPhotoView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.04.2026.
//

import UIKit

final class WidgetAIPhotoView: UIView {
    lazy var scrollView = makeScrollView()
    lazy var container = makeContainer()
    lazy var previewView = makePreviewView()
    lazy var previewWidgetButton = makePreviewWidgetButton()
    lazy var promptField = makePromptField()
    lazy var generateAIPhotoButton = makeGenerateAIPhotoButton()
    lazy var helperButton = makeHelperButton()
    lazy var removeButton = makeRemoveButton()
    lazy var preloader = makePreloader()
    
    private let editableMode: Bool
    private let initialConfiguration: WidgetAIPhotoConfiguration?
    
    init(editableMode: Bool, configuration: WidgetAIPhotoConfiguration?) {
        self.editableMode = editableMode
        self.initialConfiguration = configuration
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WidgetAIPhotoView {
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
private extension WidgetAIPhotoView {
    func initialize() {
        backgroundColor = Appearance.color_21232A
    }
}

// MARK: Make constraints
private extension WidgetAIPhotoView {
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
            promptField.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            promptField.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            promptField.heightAnchor.constraint(equalToConstant: 86.scale),
            promptField.topAnchor.constraint(equalTo: previewWidgetButton.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            generateAIPhotoButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            generateAIPhotoButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            generateAIPhotoButton.heightAnchor.constraint(equalToConstant: 51.scale),
            generateAIPhotoButton.topAnchor.constraint(equalTo: promptField.bottomAnchor, constant: 32.scale)
        ])
        
        if let helperButton {
            NSLayoutConstraint.activate([
                helperButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
                helperButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
                helperButton.heightAnchor.constraint(equalToConstant: 51.scale),
                helperButton.topAnchor.constraint(equalTo: generateAIPhotoButton.bottomAnchor, constant: 12.scale),
                helperButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
        }
        
        if let removeButton {
            NSLayoutConstraint.activate([
                removeButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
                removeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
                removeButton.heightAnchor.constraint(equalToConstant: 51.scale),
                removeButton.topAnchor.constraint(equalTo: generateAIPhotoButton.bottomAnchor, constant: 12.scale),
                removeButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
        }
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: generateAIPhotoButton.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: generateAIPhotoButton.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetAIPhotoView {
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
    
    func makePreviewView() -> WidgetAIPhotoPreviewView {
        let view = WidgetAIPhotoPreviewView()
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
    
    func makePromptField() -> WidgetBuilderTextField {
        let view = WidgetBuilderTextField(
            title: "WidgetsBuilders.Prompt".localized,
            text: initialConfiguration?.prompt ?? "",
            placeholder: "WidgetsBuilders.Prompt.Placeholder".localized,
            limit: 100
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeGenerateAIPhotoButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.medium(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle("WidgetsBuilders.GenerateAIPhoto".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.color_4178F6
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
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
    
    func makePreloader() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = Appearance.color_FFFFFF
        view.hidesWhenStopped = true 
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
