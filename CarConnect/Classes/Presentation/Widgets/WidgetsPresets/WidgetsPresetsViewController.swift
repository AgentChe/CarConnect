//
//  WidgetsPresetsViewController.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.02.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetsPresetsViewController: UIViewController {
    private lazy var mainView = WidgetsPresetsView()
    
    private lazy var viewModel = WidgetsPresetsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: WidgetsPresetsViewModel.Input(
            didTapHelper: mainView.headerView.helperButton.rx.tap.asSignal(),
            didTapOpenHelperFromCollection: mainView.collectionView.didTapOpenHelper,
            didSelectTabItem: mainView.headerView.tabView.didSelect,
            didSelectPresetsType: mainView.presetsTypesView.didSelect,
            didSelectElement: mainView.collectionView.didSelect,
            didTapGoToCatalog: mainView.emptyView.catalogButton.rx.tap.asSignal()
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        output.selectedTabItem
            .drive(Binder(mainView.headerView.tabView) { base, selectedTabItem in
                base.select(tabItem: selectedTabItem)
            })
            .disposed(by: disposeBag)
        
        output.selectedPresetsType
            .drive(Binder(mainView.presetsTypesView) { base, selectedPresetsType in
                base.select(type: selectedPresetsType)
            })
            .disposed(by: disposeBag)
        
        output.collectionElements
            .drive(Binder(mainView.collectionView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.emptyHidden
            .drive(mainView.emptyView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

// MARK: Public
extension WidgetsPresetsViewController {
    static func make() -> UIViewController {
        WidgetsPresetsViewController()
    }
}

// MARK: Private
private extension WidgetsPresetsViewController {
    func action(_ action: WidgetsPresetsViewModel.Action) {
        switch action {
        case .openWidgetsHelper:
            let vc = WidgetsHelperViewController.make()
            present(vc, animated: true)
        case .openTextManuallyBuilder(let storageModelId, let config):
            let vc: UIViewController = {
                if let storageModelId {
                    return WidgetTextManuallyViewController.edit(storageModelId: storageModelId, configuration: config)
                } else {
                    return WidgetTextManuallyViewController.create(configuration: config)
                }
            }()
            navigationController?.pushViewController(vc, animated: true)
        case .openTextQuoteBuilder(let storageModelId, let quote, let config):
            let vc: UIViewController = {
                if let storageModelId {
                    return WidgetTextQuoteViewController.edit(storageModelId: storageModelId, quote: quote, configuration: config)
                } else {
                    return WidgetTextQuoteViewController.create(quote: quote, configuration: config)
                }
            }()
            navigationController?.pushViewController(vc, animated: true)
        case .openCalendarBuilder(let storageModelId, let config):
            let vc: UIViewController = {
                if let storageModelId {
                    return WidgetCalendarViewController.edit(storageModelId: storageModelId, configuration: config)
                } else {
                    return WidgetCalendarViewController.create(configuration: config)
                }
            }()
            navigationController?.pushViewController(vc, animated: true)
        case .openWeather(let storageModelId, let config):
            let vc: UIViewController = {
                if let storageModelId {
                    return WidgetWeatherViewController.edit(storageModelId: storageModelId, configuration: config)
                } else {
                    return WidgetWeatherViewController.create(configuration: config)
                }
            }()
            navigationController?.pushViewController(vc, animated: true)
        case .openClock(let storageModelId, let config):
            let vc: UIViewController = {
                if let storageModelId {
                    return WidgetClockViewController.edit(storageModelId: storageModelId, configuration: config)
                } else {
                    return WidgetClockViewController.create(configuration: config)
                }
            }()
            navigationController?.pushViewController(vc, animated: true)
        case .openClockAIPreview(let storageModelId, let config):
            let vc: UIViewController = {
                if let storageModelId {
                    return WidgetClockAIPreviewViewController.edit(storageModelId: storageModelId, configuration: config)
                } else {
                    return WidgetClockAIPreviewViewController.create(configuration: config)
                }
            }()
            navigationController?.pushViewController(vc, animated: true)
        case .openCarLogo(let storageModelId, let config):
            let vc: UIViewController = {
                if let storageModelId {
                    return WidgetCarLogoViewController.edit(storageModelId: storageModelId, configuration: config)
                } else {
                    return WidgetCarLogoViewController.create(configuration: config)
                }
            }()
            navigationController?.pushViewController(vc, animated: true)
        case .openAIPhoto(let storageModelId, let config):
            let vc: UIViewController = {
                if let storageModelId {
                    return WidgetAIPhotoViewController.edit(storageModelId: storageModelId, configuration: config)
                } else {
                    return WidgetAIPhotoViewController.create(configuration: config)
                }
            }()
            navigationController?.pushViewController(vc, animated: true)
        case .openPhotoWihText(let storageModelId, let config):
            let vc: UIViewController = {
                if let storageModelId {
                    return WidgetPhotoWithTextViewController.edit(storageModelId: storageModelId, configuration: config)
                } else {
                    return WidgetPhotoWithTextViewController.create(configuration: config)
                }
            }()
            navigationController?.pushViewController(vc, animated: true)
        case .openPhoto(let storageModelId, let config):
            let vc: UIViewController = {
                if let storageModelId {
                    return WidgetPhotoViewController.edit(storageModelId: storageModelId, configuration: config)
                } else {
                    return WidgetPhotoViewController.create(configuration: config)
                }
            }()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
