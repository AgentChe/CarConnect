//
//  SelectTemperatureTypeCellButton.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 23.03.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class SelectTemperatureTypeCellButton: UIButton {
    lazy var label = makeLabel()
    lazy var iconView = makeIconView()
    
    private let temperatureType: TemperatureType
    
    init(temperatureType: TemperatureType) {
        self.temperatureType = temperatureType
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SelectTemperatureTypeCellButton {
    var didTap: Signal<TemperatureType> {
        rx.tap
            .compactMap { [weak self] in self?.temperatureType }
            .asSignal(onErrorSignalWith: .never())
    }
    
    func setup(selected: Bool) {
        iconView.isHidden = !selected
    }
}

// MARK: Private
private extension SelectTemperatureTypeCellButton {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension SelectTemperatureTypeCellButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SelectTemperatureTypeCellButton {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.regular(size: 16.scale))
            .textAlignment(.left)
        
        let title: String = {
            switch temperatureType {
            case .celsius:
                return "WidgetsBuilders.TemperatureType.Celsius".localized
            case .fahrenheit:
                return "WidgetsBuilders.TemperatureType.Fahrenheit".localized
            }
        }()
        
        let view = UILabel()
        view.attributedText = title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "WidgetsBuilders.ItemChecked")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
