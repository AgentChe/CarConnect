//
//  WidgetCarLogoViewController.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 02.04.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetCarLogoViewController: UIViewController {
    private let mainView: WidgetCarLogoView
    
    private let viewModel: WidgetCarLogoViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var saveButton = UIBarButtonItem(title: "Save".localized, style: .done, target: nil, action: nil)
    
    private lazy var didRemoveConfirmedTrigger = PublishRelay<Void>()
    private lazy var didEnterNameTrigger = PublishRelay<String>()
    
    private init(
        storageModelId: String?,
        configuration: WidgetCarLogoConfiguration
    ) {
        self.mainView = WidgetCarLogoView(editableMode: storageModelId != nil)
        self.viewModel = WidgetCarLogoViewModel(
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
        
        mainView.brandsView.parentVC = self 
        mainView.backgroundView.parentVC = self
        
        let output = viewModel.configure(input: WidgetCarLogoViewModel.Input(
            didTapHelper: mainView.helperButton?.rx.tap.asSignal() ?? .never(),
            didTapRestoreDefault: mainView.restoreDefaultButton.rx.tap.asSignal(),
            didTapOpenPreview: mainView.previewWidgetButton.rx.tap.asSignal(),
            didTapSave: saveButton.rx.tap.asSignal(),
            didTapRemove: mainView.removeButton?.rx.tap.asSignal() ?? .never(),
            didSelectBrand: mainView.brandsView.didSelect,
            didRemoveConfirmed: didRemoveConfirmedTrigger.asSignal(),
            didTapResetBackground: mainView.backgroundView.didReset,
            didSelectBackground: mainView.backgroundView.didSelect,
            didEnterName: didEnterNameTrigger.asSignal()
        ))
        
        let defaultConfiguration = output.defaultConfiguration
        let configuration = output.configuration
        
        configuration
            .drive(Binder(mainView) { base, configuration in
                base.setup(configuration: configuration)
            })
            .disposed(by: disposeBag)
        
        Driver
            .combineLatest(defaultConfiguration, configuration)
            .drive(Binder(mainView) { base, configs in
                let (defaultConfiguration, configuration) = configs
                
                base.brandsView.setup(selected: configuration.brand)
                base.backgroundView.setup(selectedBackground: configuration.background, defaultBackground: defaultConfiguration.background)
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
        
        output.brands
            .drive(Binder(mainView.brandsView) { base, brands in
                base.setup(brands: Array(brands.prefix(10))) 
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension WidgetCarLogoViewController {
    static func create(configuration: WidgetCarLogoConfiguration) -> WidgetCarLogoViewController {
        let vc = WidgetCarLogoViewController(
            storageModelId: nil,
            configuration: configuration
        )
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "WidgetsBuilders.Title".localized
        return vc
    }
    
    static func edit(
        storageModelId: String,
        configuration: WidgetCarLogoConfiguration
    ) -> WidgetCarLogoViewController {
        let vc = WidgetCarLogoViewController(
            storageModelId: storageModelId,
            configuration: configuration
        )
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "WidgetsBuilders.Title".localized
        return vc
    }
}

// MARK: Private
private extension WidgetCarLogoViewController {
    func action(_ action: WidgetCarLogoViewModel.Action) {
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
