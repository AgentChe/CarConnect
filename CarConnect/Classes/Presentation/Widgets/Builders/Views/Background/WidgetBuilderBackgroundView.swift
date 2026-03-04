//
//  WidgetBuilderBackgroundView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.03.2026.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

final class WidgetBuilderBackgroundView: UIView {
    lazy var label = makeLabel()
    lazy var scrollView = makeScrollView()
    lazy var container = makeContainer()
    lazy var resetButton = makeResetButton()
    lazy var photoButton = makePhotoButton()
    lazy var separator = makeSeparator()
    lazy var customColorButton = makeCustomColorButton()
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
    private lazy var didSelectPhotoAssetIdFromPickerTrigger = PublishRelay<String>()
    
    private lazy var presetsColorsButtons = [
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
extension WidgetBuilderBackgroundView {
    func setup(selectedBackground: WidgetBackground, defaultBackground: WidgetBackground) {
        resetButton.setup(enable: !selectedBackground.isEqual(another: defaultBackground))
        
        photoButton.setup(selected: selectedBackground.isImage)
        
        let isPresetColor = presetsColorsButtons.contains { selectedBackground.isEqual(color: $0.color) }
        customColorButton.setup(selected: selectedBackground.isColor && !isPresetColor)
        
        presetsColorsButtons.forEach { button in
            button.setup(selected: selectedBackground.isEqual(color: button.color))
        }
    }
    
    var didReset: Signal<Void> {
        resetButton.rx.tap.asSignal()
    }
    
    var didSelect: Signal<WidgetBackground> {
        Signal<WidgetBackground>
            .merge(
                didSelectColorFromPickerTrigger
                    .map { WidgetBackground.color(CodableColor(wrappedValue: $0)) }
                    .asSignal(onErrorSignalWith: .never()),
                didSelectPhotoAssetIdFromPickerTrigger
                    .map { WidgetBackground.photoAssetId($0) }
                    .asSignal(onErrorSignalWith: .never()),
                color_FFFFFFButton.didTap.map { WidgetBackground.color(CodableColor(wrappedValue: $0)) },
                color_000000Button.didTap.map { WidgetBackground.color(CodableColor(wrappedValue: $0)) },
                color_FF9800Button.didTap.map { WidgetBackground.color(CodableColor(wrappedValue: $0)) },
                color_FFD200Button.didTap.map { WidgetBackground.color(CodableColor(wrappedValue: $0)) },
                color_008000Button.didTap.map { WidgetBackground.color(CodableColor(wrappedValue: $0)) },
                color_0000FFButton.didTap.map { WidgetBackground.color(CodableColor(wrappedValue: $0)) },
                color_800080Button.didTap.map { WidgetBackground.color(CodableColor(wrappedValue: $0)) },
                color_FF0000Button.didTap.map { WidgetBackground.color(CodableColor(wrappedValue: $0)) }
            )
    }
}

// MARK: PHPickerViewControllerDelegate
extension WidgetBuilderBackgroundView: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let assetId = results.first?.assetIdentifier else { return }

        didSelectPhotoAssetIdFromPickerTrigger.accept(assetId)
    }
}

// MARK: UIColorPickerViewControllerDelegate
extension WidgetBuilderBackgroundView: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        didSelectColorFromPickerTrigger.accept(viewController.selectedColor)
    }
}

// MARK: Private
private extension WidgetBuilderBackgroundView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    @objc
    func customColorTapped() {
        guard let parentVC else { return }
        
        let picker = UIColorPickerViewController()
        picker.delegate = self
        picker.supportsAlpha = false
        
        parentVC.present(picker, animated: true)
    }
    
    @objc
    func selectPhotoTapped() {
        guard let parentVC else { return }

        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        parentVC.present(picker, animated: true)
    }
}

// MARK: Make constraints
private extension WidgetBuilderBackgroundView {
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
            photoButton.widthAnchor.constraint(equalToConstant: 48.scale),
            photoButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            photoButton.topAnchor.constraint(equalTo: container.topAnchor),
            photoButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separator.widthAnchor.constraint(equalToConstant: 1.scale),
            separator.leadingAnchor.constraint(equalTo: photoButton.trailingAnchor, constant: 8.scale),
            separator.topAnchor.constraint(equalTo: container.topAnchor, constant: 8.scale),
            separator.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            resetButton.widthAnchor.constraint(equalToConstant: 48.scale),
            resetButton.leadingAnchor.constraint(equalTo: separator.trailingAnchor, constant: 8.scale),
            resetButton.topAnchor.constraint(equalTo: container.topAnchor),
            resetButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            customColorButton.widthAnchor.constraint(equalToConstant: 48.scale),
            customColorButton.leadingAnchor.constraint(equalTo: resetButton.trailingAnchor, constant: 8.scale),
            customColorButton.topAnchor.constraint(equalTo: container.topAnchor),
            customColorButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            color_FFFFFFButton.widthAnchor.constraint(equalToConstant: 48.scale),
            color_FFFFFFButton.leadingAnchor.constraint(equalTo: customColorButton.trailingAnchor, constant: 8.scale),
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
private extension WidgetBuilderBackgroundView {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(22.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "WidgetsBuilders.Background".localized.attributed(with: attrs)
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
    
    func makePhotoButton() -> WidgetBuilderBackgroundPhotoItemButton {
        let view = WidgetBuilderBackgroundPhotoItemButton()
        view.addTarget(self, action: #selector(selectPhotoTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.color_373B47
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeResetButton() -> WidgetBuilderResetItemButton {
        let view = WidgetBuilderResetItemButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeCustomColorButton() -> WidgetBuilderFontColorCustomButton {
        let view = WidgetBuilderFontColorCustomButton()
        view.addTarget(self, action: #selector(customColorTapped), for: .touchUpInside)
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

// MARK: Additional
private extension WidgetBackground {
    var isColor: Bool {
        switch self {
        case .color:
            return true
        default:
            return false
        }
    }
    
    var isImage: Bool {
        switch self {
        case .fileName, .photoAssetId:
            return true
        default:
            return false
        }
    }
    
    func isEqual(color: UIColor) -> Bool {
        switch self {
        case .color(let codableColor):
            return codableColor.wrappedValue.isEqualTo(color)
        default:
            return false
        }
    }
}
