//
//  WidgetBuilderTimeFormatView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 23.03.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetBuilderTimeFormatView: UIView {
    lazy var label = makeLabel()
    lazy var switchView = makeSwitchView()
    
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
extension WidgetBuilderTimeFormatView {
    func setup(isTwentyFourHour: Bool) {
        switchView.setOn(isTwentyFourHour, animated: false)
    }
    
    var didChangeIsOn: Signal<Bool> {
        switchView.rx
            .controlEvent(.valueChanged)
            .withLatestFrom(switchView.rx.isOn.asObservable())
            .asSignal(onErrorSignalWith: .never())
    }
}

// MARK: Private
private extension WidgetBuilderTimeFormatView {
    func initialize() {
        backgroundColor = Appearance.color_2C2F39
        layer.cornerRadius = 10.scale
    }
}

// MARK: Make constraints
private extension WidgetBuilderTimeFormatView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.scale),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            switchView.centerYAnchor.constraint(equalTo: centerYAnchor),
            switchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetBuilderTimeFormatView {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.medium(size: 16.scale))
            .lineHeight(20.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "WidgetsBuilders.TimeFormat.TwentyFourHour".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSwitchView() -> UISwitch {
        let view = UISwitch()
        view.thumbTintColor = Appearance.color_FFFFFF
        view.tintColor = Appearance.color_373B47
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
