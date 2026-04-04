//
//  WidgetPhotoViewController.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 04.04.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetPhotoViewController: UIViewController {
    private let mainView: WidgetPhotoView
    
    private let viewModel: WidgetPhotoViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var saveButton = UIBarButtonItem(title: "Save".localized, style: .done, target: nil, action: nil)
    
    private lazy var didRemoveConfirmedTrigger = PublishRelay<Void>()
    private lazy var didEnterNameTrigger = PublishRelay<String>()
    
    private init(
        storageModelId: String?,
        configuration: WidgetPhotoConfiguration?
    ) {
        self.mainView = WidgetPhotoView(editableMode: storageModelId != nil)
        self.viewModel = WidgetPhotoViewModel(
            storageModelId: storageModelId,
            configuration: configuration
        )
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = saveButton
        
        mainView.previewView.parentVC = self 
        mainView.photosView.parentVC = self
        
        let output = viewModel.configure(input: WidgetPhotoViewModel.Input(
            didTapHelper: mainView.helperButton?.rx.tap.asSignal() ?? .never(),
            didTapOpenPreview: mainView.previewWidgetButton.rx.tap.asSignal(),
            didTapSave: saveButton.rx.tap.asSignal(),
            didTapRemove: mainView.removeButton?.rx.tap.asSignal() ?? .never(),
            didRemoveConfirmed: didRemoveConfirmedTrigger.asSignal(),
            didEnterName: didEnterNameTrigger.asSignal(),
            didAddPhoto: Signal
                .merge(
                    mainView.photosView.didAdd,
                    mainView.previewView.didSelectPhotoAssetIdFromPicker.map { WidgetPhoto.photoAssetId($0) }
                ),
            didSelectPhoto: mainView.photosView.didSelect,
            didTapResetPhoto: mainView.photosView.didReset
        ))
        
        let selectedPhoto = output.selectedPhoto
        let initialPhoto = output.initialPhoto
        
        Driver
            .combineLatest(selectedPhoto, initialPhoto)
            .drive(Binder(mainView.photosView) { base, photos in
                let (selected, initial) = photos
                
                base.setup(selectedPhoto: selected, defaultPhoto: initial)
            })
            .disposed(by: disposeBag)
        
        selectedPhoto
            .drive(Binder(self) { base, photo in
                base.mainView.previewView.setup(photo: photo)
                
                base.mainView.photosView.setup(selected: photo)
                
                base.saveButton.isEnabled = photo != nil
                
                base.mainView.previewWidgetButton.isUserInteractionEnabled = photo != nil
                base.mainView.previewWidgetButton.alpha = photo == nil ? 0.4 : 1
            })
            .disposed(by: disposeBag)
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        output.photos
            .drive(Binder(mainView.photosView) { base, photos in
                base.setup(photos: photos)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension WidgetPhotoViewController {
    static func create(configuration: WidgetPhotoConfiguration?) -> WidgetPhotoViewController {
        let vc = WidgetPhotoViewController(
            storageModelId: nil,
            configuration: configuration
        )
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "WidgetsBuilders.Title".localized
        return vc
    }
    
    static func edit(
        storageModelId: String,
        configuration: WidgetPhotoConfiguration?
    ) -> WidgetPhotoViewController {
        let vc = WidgetPhotoViewController(
            storageModelId: storageModelId,
            configuration: configuration
        )
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "WidgetsBuilders.Title".localized
        return vc
    }
}

// MARK: Private
private extension WidgetPhotoViewController {
    func action(_ action: WidgetPhotoViewModel.Action) {
        switch action {
        case .openHelper:
            let vc = WidgetsHelperViewController.make()
            present(vc, animated: true)
        case .openPreview:
            guard let snapshot = mainView.makeSnapshotResultView() else { return }
            let vc = WidgetsPreviewViewController.make(snapshot: snapshot)
            present(vc, animated: true)
        case .close:
            navigationController?.popViewController(animated: true)
        case .requestRemoveConfirmation:
            let vc = WidgetBuilderRemoveConfirmViewController.make { [weak self] in
                self?.didRemoveConfirmedTrigger.accept(Void())
            }
            present(vc, animated: false)
        case .enterName(let name):
            let vc = WidgetBuilderEnterNameViewController.make(placeholder: name) { [weak self] name in
                self?.didEnterNameTrigger.accept(name)
            }
            present(vc, animated: false)
        }
    }
}
