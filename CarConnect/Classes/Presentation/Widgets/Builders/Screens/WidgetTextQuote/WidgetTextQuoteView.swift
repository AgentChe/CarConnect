//
//  WidgetTextQuoteView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 23.02.2026.
//

import UIKit

final class WidgetTextQuoteView: UIView {
    lazy var scrollView = makeScrollView()
    lazy var container = makeContainer()
    lazy var sliderView = makeSliderView(quote: quote)
    lazy var previewWidgetButton = makePreviewWidgetButton()
    lazy var fontView = makeFontView()
    lazy var fontColorView = makeFontColorView()
    lazy var restoreDefaultButton = makeRestoreDefaultButton()
    lazy var helperButton = makeHelperButton()
    lazy var removeButton = makeRemoveButton()
    
    private let editableMode: Bool
    private let quote: WidgetTextQuote
    
    init(editableMode: Bool, quote: WidgetTextQuote) {
        self.editableMode = editableMode
        self.quote = quote
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension WidgetTextQuoteView {
    func initialize() {
        backgroundColor = Appearance.color_21232A
    }
}

// MARK: Make constraints
private extension WidgetTextQuoteView {
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
            sliderView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            sliderView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            sliderView.topAnchor.constraint(equalTo: container.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            previewWidgetButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            previewWidgetButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            previewWidgetButton.heightAnchor.constraint(equalToConstant: 51.scale),
            previewWidgetButton.topAnchor.constraint(equalTo: sliderView.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            fontView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            fontView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            fontView.heightAnchor.constraint(equalToConstant: 86.scale),
            fontView.topAnchor.constraint(equalTo: previewWidgetButton.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            fontColorView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            fontColorView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            fontColorView.heightAnchor.constraint(equalToConstant: 86.scale),
            fontColorView.topAnchor.constraint(equalTo: fontView.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            restoreDefaultButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            restoreDefaultButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            restoreDefaultButton.heightAnchor.constraint(equalToConstant: 51.scale),
            restoreDefaultButton.topAnchor.constraint(equalTo: fontColorView.bottomAnchor, constant: 32.scale)
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

// MARK: Lazy initializations
private extension WidgetTextQuoteView {
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
    
    func makeSliderView(quote: WidgetTextQuote) -> WidgetTextQuoteSliderView {
        let view = WidgetTextQuoteSliderView(quote: quote)
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
    
    func makeFontView() -> WidgetBuilderFontView {
        let view = WidgetBuilderFontView()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeFontColorView() -> WidgetBuilderFontColorView {
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
