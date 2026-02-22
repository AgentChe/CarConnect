//
//  WidgetsHelperTabView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 21.02.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetsHelperTabView: UIView {
    enum TabItem {
        case setup, carPlay, phone
    }
    
    lazy var setupButton = makeItemButton(title: "WidgetsHelper.Tab.Setup".localized)
    lazy var carPlayButton = makeItemButton(title: "WidgetsHelper.Tab.CarPlay".localized)
    lazy var phoneButton = makeItemButton(title: "WidgetsHelper.Tab.Phone".localized)
    
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
extension WidgetsHelperTabView {
    func select(tabItem: TabItem) {
        setupButton.backgroundColor = tabItem == .setup ? Appearance.color_2C2F39 : UIColor.clear
        carPlayButton.backgroundColor = tabItem == .carPlay ? Appearance.color_2C2F39 : UIColor.clear
        phoneButton.backgroundColor = tabItem == .phone ? Appearance.color_2C2F39 : UIColor.clear
    }
    
    var didTap: Signal<TabItem> {
        Signal
            .merge(
                setupButton.rx.tap
                    .map { TabItem.setup }
                    .asSignal(onErrorSignalWith: .never()),
                carPlayButton.rx.tap
                    .map { TabItem.carPlay }
                    .asSignal(onErrorSignalWith: .never()),
                phoneButton.rx.tap
                    .map { TabItem.phone }
                    .asSignal(onErrorSignalWith: .never())
            )
    }
}

// MARK: Private
private extension WidgetsHelperTabView {
    func initialize() {
        backgroundColor = UIColor.clear
        layer.cornerRadius = 10.scale
        layer.borderWidth = 1.scale
        layer.borderColor = Appearance.color_2C2F39.cgColor
    }
}

// MARK: Make constraints
private extension WidgetsHelperTabView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            setupButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4.scale),
            setupButton.topAnchor.constraint(equalTo: topAnchor, constant: 4.scale),
            setupButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4.scale),
            setupButton.widthAnchor.constraint(equalTo: carPlayButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            carPlayButton.leadingAnchor.constraint(equalTo: setupButton.trailingAnchor, constant: 2.scale),
            carPlayButton.topAnchor.constraint(equalTo: topAnchor, constant: 4.scale),
            carPlayButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4.scale),
            carPlayButton.widthAnchor.constraint(equalTo: phoneButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            phoneButton.leadingAnchor.constraint(equalTo: carPlayButton.trailingAnchor, constant: 2.scale),
            phoneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4.scale),
            phoneButton.topAnchor.constraint(equalTo: topAnchor, constant: 4.scale),
            phoneButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsHelperTabView {
    func makeItemButton(title: String) -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.regular(size: 16.scale))
        
        let view = TapAreaButton()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 8.scale
        view.layer.masksToBounds = true
        view.setAttributedTitle(title.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
