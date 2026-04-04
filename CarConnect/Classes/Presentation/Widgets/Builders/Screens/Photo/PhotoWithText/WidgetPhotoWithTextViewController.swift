//
//  WidgetPhotoWithTextViewController.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 04.04.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetPhotoWithTextViewController: UIViewController {
    private let mainView: WidgetPhotoWithTextView
    
    private let viewModel: WidgetPhotoWithTextViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var saveButton = UIBarButtonItem(title: "Save".localized, style: .done, target: nil, action: nil)
    
    private lazy var didRemoveConfirmedTrigger = PublishRelay<Void>()
    private lazy var didEnterNameTrigger = PublishRelay<String>()
    
    private init(
        storageModelId: String?,
        configuration: WidgetPhotoWithTextConfiguration
    ) {
        self.mainView = WidgetPhotoWithTextView(
            editableMode: storageModelId != nil,
            configuration: configuration
        )
        self.viewModel = WidgetPhotoWithTextViewModel(
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
        
        mainView.photosView.parentVC = self
        mainView.textColorView.parentVC = self
        
        let output = viewModel.configure(input: WidgetPhotoWithTextViewModel.Input(
            didTapHelper: mainView.helperButton?.rx.tap.asSignal() ?? .never(),
            didTapRestoreDefault: mainView.restoreDefaultButton.rx.tap.asSignal(),
            didTapOpenPreview: mainView.previewWidgetButton.rx.tap.asSignal(),
            didTapSave: saveButton.rx.tap.asSignal(),
            didTapRemove: mainView.removeButton?.rx.tap.asSignal() ?? .never(),
            didRemoveConfirmed: didRemoveConfirmedTrigger.asSignal(),
            didEnterName: didEnterNameTrigger.asSignal(),
            didAddPhoto: mainView.photosView.didAdd,
            didSelectPhoto: mainView.photosView.didSelect,
            didTapResetPhoto: mainView.photosView.didReset,
            didEnterText: mainView.textField.didChangeText,
            didSelectFont: mainView.fontView.didSelect,
            didTapResetFont: mainView.fontView.didReset,
            didSelectColor: mainView.textColorView.didSelect,
            didTapResetColor: mainView.textColorView.didReset
        ))
        
        let defaultConfiguration = output.defaultConfiguration
        let configuration = output.configuration
        
        Driver
            .combineLatest(defaultConfiguration, configuration)
            .drive(Binder(mainView) { base, configs in
                let (defaultConfiguration, configuration) = configs
                
                base.setup(configuration: configuration, defaultConfiguration: defaultConfiguration)
            })
            .disposed(by: disposeBag)
        
        output.enableRestoreDefault
            .drive(Binder(mainView.restoreDefaultButton) { base, enable in
                base.setup(enable: enable)
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
        
        output.selectedPhoto
            .drive(Binder(mainView.photosView) { base, photo in
                base.setup(selected: photo)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension WidgetPhotoWithTextViewController {
    static func create(configuration: WidgetPhotoWithTextConfiguration) -> WidgetPhotoWithTextViewController {
        let vc = WidgetPhotoWithTextViewController(
            storageModelId: nil,
            configuration: configuration
        )
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "WidgetsBuilders.Title".localized
        return vc
    }
    
    static func edit(
        storageModelId: String,
        configuration: WidgetPhotoWithTextConfiguration
    ) -> WidgetPhotoWithTextViewController {
        let vc = WidgetPhotoWithTextViewController(
            storageModelId: storageModelId,
            configuration: configuration
        )
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "WidgetsBuilders.Title".localized
        return vc
    }
}

// MARK: Private
private extension WidgetPhotoWithTextViewController {
    func action(_ action: WidgetPhotoWithTextViewModel.Action) {
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
