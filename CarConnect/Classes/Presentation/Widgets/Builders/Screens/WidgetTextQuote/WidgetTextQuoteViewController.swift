//
//  WidgetTextQuoteViewController.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 23.02.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetTextQuoteViewController: UIViewController {
    private let mainView: WidgetTextQuoteView
    
    private let viewModel: WidgetTextQuoteViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var saveButton = UIBarButtonItem(title: "Save".localized, style: .done, target: nil, action: nil)
    
    private weak var previousPopDelegate: UIGestureRecognizerDelegate?
    
    private lazy var didRemoveConfirmedTrigger = PublishRelay<Void>()
    private lazy var didEnterNameTrigger = PublishRelay<String>()
    
    private init(
        storageModelId: String?,
        quote: WidgetTextQuote,
        configuration: WidgetTextQuoteConfiguration
    ) {
        self.mainView = WidgetTextQuoteView(
            editableMode: storageModelId != nil,
            quote: quote
        )
        self.viewModel = WidgetTextQuoteViewModel(
            storageModelId: storageModelId,
            quote: quote,
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
        
        let output = viewModel.configure(input: WidgetTextQuoteViewModel.Input(
            didTapHelper: mainView.helperButton?.rx.tap.asSignal() ?? .never(),
            didTapResetFont: mainView.fontView.didReset,
            didSelectFont: mainView.fontView.didSelect,
            didTapResetFontColor: mainView.fontColorView.didReset,
            didSelectFontColor: mainView.fontColorView.didSelect,
            didTapRestoreDefault: mainView.restoreDefaultButton.rx.tap.asSignal(),
            didTapOpenPreview: mainView.previewWidgetButton.rx.tap.asSignal(),
            didTapSave: saveButton.rx.tap.asSignal(),
            didTapRemove: mainView.removeButton?.rx.tap.asSignal() ?? .never(),
            didRemoveConfirmed: didRemoveConfirmedTrigger.asSignal(),
            didChangeQuote: mainView.sliderView.didChangedQuote,
            didEnterName: didEnterNameTrigger.asSignal()
        ))
        
        let defaultConfiguration = output.defaultConfiguration
        let configuration = output.configuration
        
        configuration
            .drive(Binder(mainView.sliderView) { base, config in
                base.setup(configuration: config)
            })
            .disposed(by: disposeBag)
        
        Driver
            .combineLatest(defaultConfiguration, configuration)
            .drive(Binder(mainView) { base, configs in
                let (defaultConfiguration, configuration) = configs
                
                base.fontView.setup(selectedFont: configuration.font, defaultFont: defaultConfiguration.font)
                base.fontColorView.setup(selectedColor: configuration.textColor, defaultColor: defaultConfiguration.textColor)
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let popGesture: UIGestureRecognizer? = {
            if #available(iOS 26.0, *) {
                return navigationController?.interactiveContentPopGestureRecognizer
            }
            return navigationController?.interactivePopGestureRecognizer
        }()

        guard let popGesture else { return }
        
        previousPopDelegate = popGesture.delegate
        popGesture.delegate = self
        popGesture.isEnabled = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let popGesture: UIGestureRecognizer? = {
            if #available(iOS 26.0, *) {
                return navigationController?.interactiveContentPopGestureRecognizer
            }
            return navigationController?.interactivePopGestureRecognizer
        }()
        
        if let popGesture {
            popGesture.delegate = previousPopDelegate
        }
    }
}

// MARK: Public
extension WidgetTextQuoteViewController {
    static func create(quote: WidgetTextQuote, configuration: WidgetTextQuoteConfiguration) -> WidgetTextQuoteViewController {
        let vc = WidgetTextQuoteViewController(
            storageModelId: nil,
            quote: quote,
            configuration: configuration
        )
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "WidgetsBuilders.Title".localized
        return vc
    }
    
    static func edit(
        storageModelId: String,
        quote: WidgetTextQuote,
        configuration: WidgetTextQuoteConfiguration
    ) -> WidgetTextQuoteViewController {
        let vc = WidgetTextQuoteViewController(
            storageModelId: storageModelId,
            quote: quote,
            configuration: configuration
        )
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "WidgetsBuilders.Title".localized
        return vc
    }
}

// MARK: UIGestureRecognizerDelegate
extension WidgetTextQuoteViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if !mainView.sliderView.canRigthSwipe() {
            return true
        }
        
        let popGesture: UIGestureRecognizer? = {
            if #available(iOS 26.0, *) {
                return navigationController?.interactiveContentPopGestureRecognizer
            }
            return navigationController?.interactivePopGestureRecognizer
        }()
        
        guard gestureRecognizer === popGesture else { return true }
        
        guard let hostView = gestureRecognizer.view else { return true }

        let point = gestureRecognizer.location(in: hostView)

        let blockView = mainView.sliderView

        let blockRect = blockView.convert(blockView.bounds, to: hostView)

        if blockRect.contains(point) {
            return false
        }

        return true
    }
}

// MARK: Private
private extension WidgetTextQuoteViewController {
    func action(_ action: WidgetTextQuoteViewModel.Action) {
        switch action {
        case .openHelper:
            let vc = WidgetsHelperViewController.make()
            present(vc, animated: true)
        case .openPreview:
            guard let snapshot = mainView.sliderView.makeSnapshotCurrentView() else { return }
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
