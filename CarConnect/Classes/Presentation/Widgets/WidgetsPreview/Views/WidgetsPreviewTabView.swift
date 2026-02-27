//
//  WidgetsPreviewTabView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.02.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetsPreviewTabView: UIView {
    enum TabItem {
        case oneWidget, twoWidgets, threeWidgets
    }
    
    lazy var oneWidgetButton = makeItemButton(title: "WidgetsPreview.Tab.OneWidget" .localized)
    lazy var twoWidgetButton = makeItemButton(title: "WidgetsPreview.Tab.TwoWidget" .localized)
    lazy var threeWidgetButton = makeItemButton(title: "WidgetsPreview.Tab.ThreeWidget" .localized)
    
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
extension WidgetsPreviewTabView {
    func select(tabItem: TabItem) {
        oneWidgetButton.backgroundColor = tabItem == .oneWidget ? Appearance.color_2C2F39 : UIColor.clear
        twoWidgetButton.backgroundColor = tabItem == .twoWidgets ? Appearance.color_2C2F39 : UIColor.clear
        threeWidgetButton.backgroundColor = tabItem == .threeWidgets ? Appearance.color_2C2F39 : UIColor.clear
    }
    
    var didTap: Signal<TabItem> {
        Signal
            .merge(
                oneWidgetButton.rx.tap
                    .map { TabItem.oneWidget }
                    .asSignal(onErrorSignalWith: .never()),
                twoWidgetButton.rx.tap
                    .map { TabItem.twoWidgets }
                    .asSignal(onErrorSignalWith: .never()),
                threeWidgetButton.rx.tap
                    .map { TabItem.threeWidgets }
                    .asSignal(onErrorSignalWith: .never())
            )
    }
}

// MARK: Private
private extension WidgetsPreviewTabView {
    func initialize() {
        backgroundColor = UIColor.clear
        layer.cornerRadius = 10.scale
        layer.borderWidth = 1.scale
        layer.borderColor = Appearance.color_2C2F39.cgColor
    }
}

// MARK: Make constraints
private extension WidgetsPreviewTabView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            oneWidgetButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4.scale),
            oneWidgetButton.topAnchor.constraint(equalTo: topAnchor, constant: 4.scale),
            oneWidgetButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4.scale),
            oneWidgetButton.widthAnchor.constraint(equalTo: twoWidgetButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            twoWidgetButton.leadingAnchor.constraint(equalTo: oneWidgetButton.trailingAnchor, constant: 2.scale),
            twoWidgetButton.topAnchor.constraint(equalTo: topAnchor, constant: 4.scale),
            twoWidgetButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4.scale),
            twoWidgetButton.widthAnchor.constraint(equalTo: threeWidgetButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            threeWidgetButton.leadingAnchor.constraint(equalTo: twoWidgetButton.trailingAnchor, constant: 2.scale),
            threeWidgetButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4.scale),
            threeWidgetButton.topAnchor.constraint(equalTo: topAnchor, constant: 4.scale),
            threeWidgetButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPreviewTabView {
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
