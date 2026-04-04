//
//  WidgetBuilderPhotoView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 04.04.2026.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

final class WidgetBuilderPhotoView: UIView {
    lazy var label = makeLabel()
    lazy var scrollView = makeScrollView()
    lazy var container = makeContainer()
    lazy var selectPhotoButton = makeSelectPhotoButton()
    lazy var separator = makeSeparator()
    lazy var resetButton = makeResetButton()
    lazy var itemsButtonsContainer = makeItemsContainer()
    
    weak var parentVC: UIViewController?
    
    private lazy var itemsButtons = [WidgetBuilderPhotoItemButton]()
    
    private var selected: WidgetPhoto?
    
    private lazy var didAddPhotoAssetIdFromPickerTrigger = PublishRelay<String>()
    private lazy var didSelectPhotoTrigger = PublishRelay<WidgetPhoto>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: PHPickerViewControllerDelegate
extension WidgetBuilderPhotoView: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let assetId = results.first?.assetIdentifier else { return }

        didAddPhotoAssetIdFromPickerTrigger.accept(assetId)
    }
}

// MARK: Public
extension WidgetBuilderPhotoView {
    func setup(selectedPhoto: WidgetPhoto, defaultPhoto: WidgetPhoto) {
        resetButton.setup(enable: selectedPhoto != defaultPhoto)
    }
    
    func setup(photos: [WidgetPhoto]) {
        itemsButtons.forEach { $0.removeFromSuperview() }
        itemsButtons = []
        
        var leftView = itemsButtonsContainer
        
        photos.enumerated().forEach { index, photo in
            let button = WidgetBuilderPhotoItemButton(photo: photo)
            button.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(button)
            
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: itemsButtonsContainer.topAnchor),
                button.bottomAnchor.constraint(equalTo: itemsButtonsContainer.bottomAnchor),
                button.widthAnchor.constraint(equalTo: button.heightAnchor)
            ])
            
            if index == 0 {
                button.leadingAnchor.constraint(equalTo: itemsButtonsContainer.leadingAnchor).isActive = true
            } else {
                button.leadingAnchor.constraint(equalTo: leftView.trailingAnchor, constant: 8.scale).isActive = true
            }
            
            if (photos.count - 1) == index {
                button.trailingAnchor.constraint(equalTo: itemsButtonsContainer.trailingAnchor).isActive = true
            }
            
            leftView = button
            
            button.addTarget(self, action: #selector(photoButtonTapped(sender:)), for: .touchUpInside)
            
            itemsButtons.append(button)
        }
        
        if let selected {
            setup(selected: selected)
        }
    }
    
    func setup(selected: WidgetPhoto) {
        self.selected = selected
        
        itemsButtons.forEach { button in
            button.setup(selected: button.photo == selected)
        }
    }
    
    var didAdd: Signal<WidgetPhoto> {
        didAddPhotoAssetIdFromPickerTrigger
            .map { WidgetPhoto.photoAssetId($0) }
            .asSignal(onErrorSignalWith: .never())
    }
    
    var didSelect: Signal<WidgetPhoto> {
        didSelectPhotoTrigger.asSignal()
    }
    
    var didReset: Signal<Void> {
        resetButton.rx.tap.asSignal()
    }
}

// MARK: Private
private extension WidgetBuilderPhotoView {
    func initialize() {
        backgroundColor = UIColor.clear
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
    
    @objc
    func photoButtonTapped(sender: UIButton) {
        guard let photoButton = sender as? WidgetBuilderPhotoItemButton else { return }
        
        didSelectPhotoTrigger.accept(photoButton.photo)
    }
}

// MARK: Make constraints
private extension WidgetBuilderPhotoView {
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
            selectPhotoButton.widthAnchor.constraint(equalToConstant: 48.scale),
            selectPhotoButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            selectPhotoButton.topAnchor.constraint(equalTo: container.topAnchor),
            selectPhotoButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separator.widthAnchor.constraint(equalToConstant: 1.scale),
            separator.leadingAnchor.constraint(equalTo: selectPhotoButton.trailingAnchor, constant: 8.scale),
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
            itemsButtonsContainer.leadingAnchor.constraint(equalTo: resetButton.trailingAnchor, constant: 8.scale),
            itemsButtonsContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            itemsButtonsContainer.topAnchor.constraint(equalTo: container.topAnchor),
            itemsButtonsContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetBuilderPhotoView {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(22.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "WidgetsBuilders.BackgroundPhoto".localized.attributed(with: attrs)
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
    
    func makeSelectPhotoButton() -> WidgetBuilderBackgroundPhotoItemButton {
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
    
    func makeItemsContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
