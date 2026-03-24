//
//  WidgetWeatherViewController.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 21.03.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetWeatherViewController: UIViewController {
    private let mainView: WidgetWeatherView
    
    private let viewModel: WidgetWeatherViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var saveButton = UIBarButtonItem(title: "Save".localized, style: .done, target: nil, action: nil)
    
    private lazy var didRemoveConfirmedTrigger = PublishRelay<Void>()
    private lazy var didEnterNameTrigger = PublishRelay<String>()
    
    private init(
        storageModelId: String?,
        configuration: WidgetWeatherConfiguration
    ) {
        self.mainView = WidgetWeatherView(
            editableMode: storageModelId != nil,
            configuration: configuration
        )
        self.viewModel = WidgetWeatherViewModel(
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
        
        mainView.fontColorView.parentVC = self
        mainView.locationView.parentVC = self 
        mainView.temperatureTypeView.parentVC = self
        
        let output = viewModel.configure(input: WidgetWeatherViewModel.Input(
            didTapHelper: mainView.helperButton?.rx.tap.asSignal() ?? .never(),
            didSelectConfigurationTabItem: mainView.configurationTabView.didSelect,
            didTapResetFont: mainView.fontView.didReset,
            didSelectFont: mainView.fontView.didSelect,
            didTapResetFontColor: mainView.fontColorView.didReset,
            didSelectFontColor: mainView.fontColorView.didSelect,
            didEnableChangedTwentyFourHour: mainView.timeFormatView.didChangeIsOn,
            didSelectLocation: mainView.locationView.didSelectLocation,
            didSelectTemperatureType: mainView.temperatureTypeView.didSelectTemperatureType,
            didTapRestoreDefault: mainView.restoreDefaultButton.rx.tap.asSignal(),
            didTapOpenPreview: mainView.previewWidgetButton.rx.tap.asSignal(),
            didTapSave: saveButton.rx.tap.asSignal(),
            didTapRemove: mainView.removeButton?.rx.tap.asSignal() ?? .never(),
            didRemoveConfirmed: didRemoveConfirmedTrigger.asSignal(),
            didEnterName: didEnterNameTrigger.asSignal()
        ))
        
        let defaultConfiguration = output.defaultConfiguration
        let configuration = output.configuration
        let weatherData = output.weatherData
        
        Driver
            .combineLatest(configuration, weatherData)
            .drive(Binder(mainView) { base, args in
                let (configuration, weatherData) = args
                base.setup(configuration: configuration, weatherData: weatherData)
            })
            .disposed(by: disposeBag)
        
        Driver
            .combineLatest(defaultConfiguration, configuration)
            .drive(Binder(mainView) { base, configs in
                let (defaultConfiguration, configuration) = configs
                
                base.fontView.setup(selectedFont: configuration.font, defaultFont: defaultConfiguration.font)
                base.fontColorView.setup(selectedColor: configuration.textColor, defaultColor: defaultConfiguration.textColor)
                base.timeFormatView.setup(isTwentyFourHour: configuration.timeFormat == .twentyFourHour)
                base.locationView.setup(location: configuration.location)
                base.temperatureTypeView.setup(temperatureType: configuration.temperatureType)
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
        
        output.configurationTabItem
            .drive(Binder(mainView) { base, item in
                base.setup(configurationTabItem: item)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension WidgetWeatherViewController {
    static func create(configuration: WidgetWeatherConfiguration) -> WidgetWeatherViewController {
        let vc = WidgetWeatherViewController(
            storageModelId: nil,
            configuration: configuration
        )
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "WidgetsBuilders.Title".localized
        return vc
    }
    
    static func edit(
        storageModelId: String,
        configuration: WidgetWeatherConfiguration
    ) -> WidgetWeatherViewController {
        let vc = WidgetWeatherViewController(
            storageModelId: storageModelId,
            configuration: configuration
        )
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "WidgetsBuilders.Title".localized
        return vc
    }
}

// MARK: Private
private extension WidgetWeatherViewController {
    func action(_ action: WidgetWeatherViewModel.Action) {
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
