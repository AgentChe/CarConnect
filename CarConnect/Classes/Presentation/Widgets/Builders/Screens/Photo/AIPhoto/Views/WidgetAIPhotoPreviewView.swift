//
//  WidgetAIPhotoPreviewView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.04.2026.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

final class WidgetAIPhotoPreviewView: GradientView {
    enum State: Hashable {
        case empty
        case fileName(String)
        case photoAssetId(String)
        case generated(String)
    }
    
    weak var parentVC: UIViewController?
    
    lazy var imageView = makeImageView()
    lazy var uploadPhotoContainer = makeUploadPhotoContainer()
    lazy var uploadPhotoImageView = makeUploadPhotoImageView()
    lazy var uploadPhotoLabel = makeUploadPhotoLabel()
    
    private lazy var didSelectPhotoAssetIdFromPickerTrigger = PublishRelay<String>()
    
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
extension WidgetAIPhotoPreviewView {
    func setup(state: State) {
        imageView.isHidden = state == .empty
        uploadPhotoContainer.isHidden = state != .empty
        
        switch state {
        case .fileName(let fileName):
            imageView.image = SharedImageFileStore.shared.loadImage(fileName: fileName)
        case .photoAssetId(let assetId):
            PhotoAssetImageLoader.shared.loadImage(
                assetId: assetId,
                targetSize: {
                    let scale = UIScreen.main.scale
                    return CGSize(
                        width: bounds.width * scale,
                        height: bounds.height * scale
                    )
                }()
            ) { [weak self] image in
                self?.imageView.image = image
            }
        case .generated(let base64):
            imageView.image = UIImage(base64: base64)
        case .empty:
            break
        }
    }
    
    var didSelectPhotoAssetIdFromPicker: Signal<String> {
        didSelectPhotoAssetIdFromPickerTrigger.asSignal()
    }
}

// MARK: PHPickerViewControllerDelegate
extension WidgetAIPhotoPreviewView: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let assetId = results.first?.assetIdentifier else { return }

        didSelectPhotoAssetIdFromPickerTrigger.accept(assetId)
    }
}

// MARK: Private
private extension WidgetAIPhotoPreviewView {
    func initialize() {
        gradientLayer.cornerRadius = 10.scale
        gradientLayer.masksToBounds = true 
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [NSNumber(value: 0), NSNumber(value: 1)]
        gradientLayer.colors = [
            Appearance.color_373B47.cgColor,
            Appearance.color_2C2F39.cgColor
        ]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectPhotoTapped))
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
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
private extension WidgetAIPhotoPreviewView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            uploadPhotoContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            uploadPhotoContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            uploadPhotoContainer.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            uploadPhotoImageView.widthAnchor.constraint(equalToConstant: 58.scale),
            uploadPhotoImageView.heightAnchor.constraint(equalToConstant: 58.scale),
            uploadPhotoImageView.centerXAnchor.constraint(equalTo: uploadPhotoContainer.centerXAnchor),
            uploadPhotoImageView.topAnchor.constraint(equalTo: uploadPhotoContainer.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            uploadPhotoLabel.leadingAnchor.constraint(equalTo: uploadPhotoContainer.leadingAnchor),
            uploadPhotoLabel.trailingAnchor.constraint(equalTo: uploadPhotoContainer.trailingAnchor),
            uploadPhotoLabel.topAnchor.constraint(equalTo: uploadPhotoContainer.topAnchor, constant: 74.scale),
            uploadPhotoLabel.bottomAnchor.constraint(equalTo: uploadPhotoContainer.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetAIPhotoPreviewView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeUploadPhotoContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeUploadPhotoImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "WidgetsBuilders.UploadPhoto")
        view.translatesAutoresizingMaskIntoConstraints = false
        uploadPhotoContainer.addSubview(view)
        return view
    }
    
    func makeUploadPhotoLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.semiBold(size: 14.scale))
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "WidgetsBuilders.UploadPhoto".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        uploadPhotoContainer.addSubview(view)
        return view
    }
}
