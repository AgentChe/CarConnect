//
//  WidgetPhotoCarouselViewController.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 05.04.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetPhotoCarouselViewController: UIViewController {
    private let mainView: WidgetPhotoCarouselView
    
    private let viewModel: WidgetPhotoCarouselViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var saveButton = UIBarButtonItem(title: "Save".localized, style: .done, target: nil, action: nil)
    
    private lazy var didRemoveConfirmedTrigger = PublishRelay<Void>()
    private lazy var didEnterNameTrigger = PublishRelay<String>()
    
    private init(
        storageModelId: String?,
        configuration: WidgetPhotoCarouselConfiguration
    ) {
        self.mainView = WidgetPhotoCarouselView(editableMode: storageModelId != nil)
        self.viewModel = WidgetPhotoCarouselViewModel(
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
        
        mainView.photos1View.parentVC = self
        mainView.photos2View.parentVC = self
        mainView.photos3View.parentVC = self
        
        let output = viewModel.configure(input: WidgetPhotoCarouselViewModel.Input(
            didTapHelper: mainView.helperButton?.rx.tap.asSignal() ?? .never(),
            didTapOpenPreview: mainView.previewWidgetButton.rx.tap.asSignal(),
            didTapSave: saveButton.rx.tap.asSignal(),
            didTapRemove: mainView.removeButton?.rx.tap.asSignal() ?? .never(),
            didRemoveConfirmed: didRemoveConfirmedTrigger.asSignal(),
            didEnterName: didEnterNameTrigger.asSignal(),
            didAddPhoto1: mainView.photos1View.didAdd,
            didSelectPhoto1: mainView.photos1View.didSelect,
            didTapResetPhoto1: mainView.photos1View.didReset,
            didAddPhoto2: mainView.photos2View.didAdd,
            didSelectPhoto2: mainView.photos2View.didSelect,
            didTapResetPhoto2: mainView.photos2View.didReset,
            didAddPhoto3: mainView.photos3View.didAdd,
            didSelectPhoto3: mainView.photos3View.didSelect,
            didTapResetPhoto3: mainView.photos3View.didReset
        ))
        
        let defaultConfiguration = output.defaultConfiguration
        let configuration = output.configuration
        
        Driver
            .combineLatest(configuration, defaultConfiguration)
            .drive(Binder(mainView) { base, configs in
                let (configuration, defaultConfiguration) = configs
                
                base.photos1View.setup(selectedPhoto: configuration.photo1, defaultPhoto: defaultConfiguration.photo1)
                base.photos2View.setup(selectedPhoto: configuration.photo2, defaultPhoto: defaultConfiguration.photo2)
                base.photos3View.setup(selectedPhoto: configuration.photo3, defaultPhoto: defaultConfiguration.photo3)
            })
            .disposed(by: disposeBag)
        
        configuration
            .drive(Binder(mainView) { base, configuration in
                base.setup(configuration: configuration)
            })
            .disposed(by: disposeBag)
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        output.photos1
            .drive(Binder(mainView.photos1View) { base, photos in
                base.setup(photos: photos)
            })
            .disposed(by: disposeBag)
        
        output.photos2
            .drive(Binder(mainView.photos2View) { base, photos in
                base.setup(photos: photos)
            })
            .disposed(by: disposeBag)
        
        output.photos3
            .drive(Binder(mainView.photos3View) { base, photos in
                base.setup(photos: photos)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension WidgetPhotoCarouselViewController {
    static func create(configuration: WidgetPhotoCarouselConfiguration) -> WidgetPhotoCarouselViewController {
        let vc = WidgetPhotoCarouselViewController(
            storageModelId: nil,
            configuration: configuration
        )
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "WidgetsBuilders.Title".localized
        return vc
    }
    
    static func edit(
        storageModelId: String,
        configuration: WidgetPhotoCarouselConfiguration
    ) -> WidgetPhotoCarouselViewController {
        let vc = WidgetPhotoCarouselViewController(
            storageModelId: storageModelId,
            configuration: configuration
        )
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "WidgetsBuilders.Title".localized
        return vc
    }
}

// MARK: Private
private extension WidgetPhotoCarouselViewController {
    func action(_ action: WidgetPhotoCarouselViewModel.Action) {
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
