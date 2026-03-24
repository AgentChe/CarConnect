//
//  WidgetBuilderTemperatureTypeView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 23.03.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetBuilderTemperatureTypeView: UIView {
    weak var parentVC: UIViewController?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var valueLabel = makeLabel()
    lazy var arrowView = makeArrowView()
    
    private var temperatureType: TemperatureType?
    
    private lazy var valueAttrs = TextAttributes()
        .textColor(Appearance.color_FFFFFF)
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(20.scale)
        .textAlignment(.left)
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didSelectTemperatureTypeTrigger = PublishRelay<TemperatureType>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WidgetBuilderTemperatureTypeView {
    func setup(temperatureType: TemperatureType) {
        self.temperatureType = temperatureType
        
        let value: String = {
            switch temperatureType {
            case .celsius:
                return "WidgetsBuilders.TemperatureType.Celsius".localized
            case .fahrenheit:
                return "WidgetsBuilders.TemperatureType.Fahrenheit".localized
            }
        }()
        valueLabel.attributedText = value.attributed(with: valueAttrs)
    }
    
    var didSelectTemperatureType: Signal<TemperatureType> {
        didSelectTemperatureTypeTrigger.asSignal()
    }
}

// MARK: Private
private extension WidgetBuilderTemperatureTypeView {
    func initialize() {
        backgroundColor = Appearance.color_2C2F39
        layer.cornerRadius = 10.scale
        
        let tapGesture = UITapGestureRecognizer()
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .bind(to: Binder(self) { base, event in
                guard let parentVC = base.parentVC, let temperatureType = base.temperatureType else { return }
                
                let selectVC = SelectTemperatureTypeViewController.make(temperatureType: temperatureType) { [weak self] temperatureType in
                    self?.didSelectTemperatureTypeTrigger.accept(temperatureType)
                }
                parentVC.present(selectVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make constraints
private extension WidgetBuilderTemperatureTypeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.scale),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.trailingAnchor.constraint(equalTo: arrowView.leadingAnchor, constant: -4.scale),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            arrowView.widthAnchor.constraint(equalToConstant: 24.scale),
            arrowView.heightAnchor.constraint(equalToConstant: 24.scale),
            arrowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.scale),
            arrowView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetBuilderTemperatureTypeView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.medium(size: 16.scale))
            .lineHeight(20.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "WidgetsBuilders.TemperatureType.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeArrowView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "WidgetsBuilders.Arrow")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
