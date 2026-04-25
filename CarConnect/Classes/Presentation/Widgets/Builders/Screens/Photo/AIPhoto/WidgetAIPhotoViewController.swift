//
//  WidgetAIPhotoViewController.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.04.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetAIPhotoViewController: UIViewController {
    private let mainView: WidgetAIPhotoView
    
    private let viewModel: WidgetAIPhotoViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var saveButton = UIBarButtonItem(title: "Save".localized, style: .done, target: nil, action: nil)
    
    private lazy var didRemoveConfirmedTrigger = PublishRelay<Void>()
    private lazy var didEnterNameTrigger = PublishRelay<String>()
    private lazy var didTapGenerateAIPhotoTrigger = PublishRelay<WidgetAIPhotoPreviewView.State>()
    
    private init(
        storageModelId: String?,
        configuration: WidgetAIPhotoConfiguration?
    ) {
        self.mainView = WidgetAIPhotoView(
            editableMode: storageModelId != nil,
            configuration: configuration
        )
        self.viewModel = WidgetAIPhotoViewModel(
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
        
        mainView.previewView.parentVC = self 
        
        navigationItem.rightBarButtonItem = saveButton
        
        let output = viewModel.configure(input: WidgetAIPhotoViewModel.Input(
            didTapHelper: mainView.helperButton?.rx.tap.asSignal() ?? .never(),
            didTapOpenPreview: mainView.previewWidgetButton.rx.tap.asSignal(),
            didTapSave: saveButton.rx.tap.asSignal(),
            didTapRemove: mainView.removeButton?.rx.tap.asSignal() ?? .never(),
            didRemoveConfirmed: didRemoveConfirmedTrigger.asSignal(),
            didEnterName: didEnterNameTrigger.asSignal(),
            didSelectPhotoAssetIdFromPicker: mainView.previewView.didSelectPhotoAssetIdFromPicker,
            didEnterPrompt: mainView.promptField.didChangeText,
            didTapGenerateAIPhoto: didTapGenerateAIPhotoTrigger.asSignal()
        ))
        
        let state = output.state
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        state
            .drive(Binder(self) { base, state in
                let enable: Bool = {
                    switch state {
                    case .generated:
                        return true
                    default:
                        return false
                    }
                }()
                base.saveButton.isEnabled = enable
                
                base.mainView.previewWidgetButton.isUserInteractionEnabled = enable
                base.mainView.previewWidgetButton.alpha = enable ? 1 : 0.4
                
                base.mainView.previewView.setup(state: state)
            })
            .disposed(by: disposeBag)
        
        output.generateAIPhotoEnable
            .drive(Binder(mainView.generateAIPhotoButton) { base, enable in
                base.isUserInteractionEnabled = enable
                base.alpha = enable ? 1 : 0.4
            })
            .disposed(by: disposeBag)
        
        output.generateAIPhotoActivity
            .drive(Binder(mainView) { base, activity in
                base.generateAIPhotoButton.isHidden = activity
                base.removeButton?.isHidden = activity
                
                activity ? base.preloader.startAnimating() : base.preloader.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        mainView.generateAIPhotoButton.rx.tap
            .withLatestFrom(state)
            .bind(to: didTapGenerateAIPhotoTrigger)
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension WidgetAIPhotoViewController {
    static func create(configuration: WidgetAIPhotoConfiguration?) -> WidgetAIPhotoViewController {
        let vc = WidgetAIPhotoViewController(
            storageModelId: nil,
            configuration: configuration
        )
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "WidgetsBuilders.Title".localized
        return vc
    }
    
    static func edit(
        storageModelId: String,
        configuration: WidgetAIPhotoConfiguration?
    ) -> WidgetAIPhotoViewController {
        let vc = WidgetAIPhotoViewController(
            storageModelId: storageModelId,
            configuration: configuration
        )
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "WidgetsBuilders.Title".localized
        return vc
    }
}

// MARK: Private
private extension WidgetAIPhotoViewController {
    func action(_ action: WidgetAIPhotoViewModel.Action) {
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
