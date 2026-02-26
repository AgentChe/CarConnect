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
    private lazy var mainView = WidgetTextQuoteView(quote: quote)
    
    private let viewModel: WidgetTextQuoteViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var saveButton = UIBarButtonItem(title: "Save".localized, style: .done, target: nil, action: nil)
    
    private let quote: WidgetTextQuote
    
    private weak var previousPopDelegate: UIGestureRecognizerDelegate?
    
    private init(quote: WidgetTextQuote, configuration: WidgetTextQuoteConfiguration) {
        self.quote = quote
        self.viewModel = WidgetTextQuoteViewModel(quote: quote, configuration: configuration)
        
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
            didTapHelper: mainView.helperButton.rx.tap.asSignal(),
            didTapResetFont: mainView.fontView.didReset,
            didSelectFont: mainView.fontView.didSelect,
            didTapResetFontColor: mainView.fontColorView.didReset,
            didSelectFontColor: mainView.fontColorView.didSelect,
            didTapRestoreDefault: mainView.restoreDefaultButton.rx.tap.asSignal()
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
        let vc = WidgetTextQuoteViewController(quote: quote, configuration: configuration)
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
        }
    }
}
