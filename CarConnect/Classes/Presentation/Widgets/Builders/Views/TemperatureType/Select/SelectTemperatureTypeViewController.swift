//
//  SelectTemperatureTypeViewController.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 23.03.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class SelectTemperatureTypeViewController: UIViewController {
    private lazy var mainView = SelectTemperatureTypeView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let initialTemperatureType: TemperatureType
    private let didSelect: (TemperatureType) -> Void
    
    private init(temperatureType: TemperatureType, didSelect: @escaping (TemperatureType) -> Void) {
        self.initialTemperatureType = temperatureType
        self.didSelect = didSelect
        
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
        
        Signal
            .merge(
                mainView.celsiusButton.didTap,
                mainView.fahrenheitButton.didTap
            )
            .startWith(initialTemperatureType)
            .asDriver(onErrorDriveWith: .never())
            .drive(Binder(self) { base, temperatureType in
                base.mainView.celsiusButton.setup(selected: temperatureType == .celsius)
                base.mainView.fahrenheitButton.setup(selected: temperatureType == .fahrenheit)
                
                base.didSelect(temperatureType)
            })
            .disposed(by: disposeBag)
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension SelectTemperatureTypeViewController {
    static func make(temperatureType: TemperatureType, didSelect: @escaping (TemperatureType) -> Void) -> SelectTemperatureTypeViewController {
        SelectTemperatureTypeViewController(temperatureType: temperatureType, didSelect: didSelect)
    }
}
