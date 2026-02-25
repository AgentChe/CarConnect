//
//  WidgetBuilderFontColorView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 24.02.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetBuilderFontColorView: UIView {
    lazy var label = makeLabel()
    lazy var scrollView = makeScrollView()
    lazy var container = makeContainer()
    lazy var resetButton = makeResetButton()
    lazy var customButton = makeCustomButton()
    lazy var color_FFFFFFButton = makeColorButton(color: Appearance.color_FFFFFF)
    lazy var color_000000Button = makeColorButton(color: Appearance.color_000000)
    lazy var color_FF9800Button = makeColorButton(color: Appearance.color_FF9800)
    lazy var color_FFD200Button = makeColorButton(color: Appearance.color_FFD200)
    lazy var color_008000Button = makeColorButton(color: Appearance.color_008000)
    lazy var color_0000FFButton = makeColorButton(color: Appearance.color_0000FF)
    lazy var color_800080Button = makeColorButton(color: Appearance.color_800080)
    lazy var color_FF0000Button = makeColorButton(color: Appearance.color_FF0000)
    
    weak var parentVC: UIViewController?
    
    private lazy var didSelectColorFromPickerTrigger = PublishRelay<UIColor>()
    
    private lazy var presetsButtons = [
        color_FFFFFFButton,
        color_000000Button,
        color_FF9800Button,
        color_FFD200Button,
        color_008000Button,
        color_0000FFButton,
        color_800080Button,
        color_FF0000Button
    ]
    
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
extension WidgetBuilderFontColorView {
    func setup(selectedColor: UIColor, defaultColor: UIColor) {
        resetButton.setup(enable: !selectedColor.isEqualTo(defaultColor))
        
        let isPreset = presetsButtons.contains { $0.color.isEqualTo(selectedColor) }
        customButton.setup(selected: !isPreset)
        
        presetsButtons.forEach {
            $0.setup(selected: $0.color.isEqualTo(selectedColor))
        }
    }
    
    var didReset: Signal<Void> {
        resetButton.rx.tap.asSignal()
    }
    
    var didSelect: Signal<UIColor> {
        Signal<UIColor>
            .merge(
                didSelectColorFromPickerTrigger.asSignal(),
                color_FFFFFFButton.didTap,
                color_000000Button.didTap,
                color_FF9800Button.didTap,
                color_FFD200Button.didTap,
                color_008000Button.didTap,
                color_0000FFButton.didTap,
                color_800080Button.didTap,
                color_FF0000Button.didTap
            )
    }
}

// MARK: UIColorPickerViewControllerDelegate
extension WidgetBuilderFontColorView: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        didSelectColorFromPickerTrigger.accept(viewController.selectedColor)
    }
}

// MARK: Private
private extension WidgetBuilderFontColorView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    @objc
    func customTapped() {
        guard let parentVC else { return }
        
        let picker = UIColorPickerViewController()
        picker.delegate = self
        picker.supportsAlpha = false
        
        parentVC.present(picker, animated: true)
    }
}

// MARK: Make constraints
private extension WidgetBuilderFontColorView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 48.scale)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            container.topAnchor.constraint(equalTo: scrollView.topAnchor),
            container.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 48.scale)
        ])
        
        NSLayoutConstraint.activate([
            resetButton.widthAnchor.constraint(equalToConstant: 48.scale),
            resetButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            resetButton.topAnchor.constraint(equalTo: container.topAnchor),
            resetButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            customButton.widthAnchor.constraint(equalToConstant: 48.scale),
            customButton.leadingAnchor.constraint(equalTo: resetButton.trailingAnchor, constant: 8.scale),
            customButton.topAnchor.constraint(equalTo: container.topAnchor),
            customButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            color_FFFFFFButton.widthAnchor.constraint(equalToConstant: 48.scale),
            color_FFFFFFButton.leadingAnchor.constraint(equalTo: customButton.trailingAnchor, constant: 8.scale),
            color_FFFFFFButton.topAnchor.constraint(equalTo: container.topAnchor),
            color_FFFFFFButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            color_000000Button.widthAnchor.constraint(equalToConstant: 48.scale),
            color_000000Button.leadingAnchor.constraint(equalTo: color_FFFFFFButton.trailingAnchor, constant: 8.scale),
            color_000000Button.topAnchor.constraint(equalTo: container.topAnchor),
            color_000000Button.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            color_FF9800Button.widthAnchor.constraint(equalToConstant: 48.scale),
            color_FF9800Button.leadingAnchor.constraint(equalTo: color_000000Button.trailingAnchor, constant: 8.scale),
            color_FF9800Button.topAnchor.constraint(equalTo: container.topAnchor),
            color_FF9800Button.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            color_FFD200Button.widthAnchor.constraint(equalToConstant: 48.scale),
            color_FFD200Button.leadingAnchor.constraint(equalTo: color_FF9800Button.trailingAnchor, constant: 8.scale),
            color_FFD200Button.topAnchor.constraint(equalTo: container.topAnchor),
            color_FFD200Button.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            color_008000Button.widthAnchor.constraint(equalToConstant: 48.scale),
            color_008000Button.leadingAnchor.constraint(equalTo: color_FFD200Button.trailingAnchor, constant: 8.scale),
            color_008000Button.topAnchor.constraint(equalTo: container.topAnchor),
            color_008000Button.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            color_0000FFButton.widthAnchor.constraint(equalToConstant: 48.scale),
            color_0000FFButton.leadingAnchor.constraint(equalTo: color_008000Button.trailingAnchor, constant: 8.scale),
            color_0000FFButton.topAnchor.constraint(equalTo: container.topAnchor),
            color_0000FFButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            color_800080Button.widthAnchor.constraint(equalToConstant: 48.scale),
            color_800080Button.leadingAnchor.constraint(equalTo: color_0000FFButton.trailingAnchor, constant: 8.scale),
            color_800080Button.topAnchor.constraint(equalTo: container.topAnchor),
            color_800080Button.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            color_FF0000Button.widthAnchor.constraint(equalToConstant: 48.scale),
            color_FF0000Button.leadingAnchor.constraint(equalTo: color_800080Button.trailingAnchor, constant: 8.scale),
            color_FF0000Button.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            color_FF0000Button.topAnchor.constraint(equalTo: container.topAnchor),
            color_FF0000Button.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetBuilderFontColorView {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(22.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "WidgetsBuilders.FontColor".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.contentInset = UIEdgeInsets(horizontal: 16.scale)
        view.setContentOffset(CGPoint(x: 16.scale, y: 0), animated: false)
        view.showsHorizontalScrollIndicator = false
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
    
    func makeResetButton() -> WidgetBuilderResetItemButton {
        let view = WidgetBuilderResetItemButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeCustomButton() -> WidgetBuilderFontColorCustomButton {
        let view = WidgetBuilderFontColorCustomButton()
        view.addTarget(self, action: #selector(customTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeColorButton(color: UIColor) -> WidgetBuilderFontColorItemButton {
        let view = WidgetBuilderFontColorItemButton(color: color)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
