//
//  WidgetsPresetsTabView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.02.2026.
//

import UIKit
import RxSwift
import RxCocoa

// TODO: для saved реализовать количество сохраненных пресетов
final class WidgetsPresetsTabView: UIView {
    enum TabItem {
        case widgets, saved
    }
    
    lazy var widgetsButton = makeButton(title: "WidgetsPresets.Tab.Widgets".localized)
    lazy var savedButton = makeButton(title: "WidgetsPresets.Tab.Saved".localized)
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.color_FFFFFF)
        .font(Fonts.Inter.bold(size: 24.scale))
        .lineHeight(34.scale)
    
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
extension WidgetsPresetsTabView {
    func select(tabItem: TabItem) {
        widgetsButton.alpha = tabItem == .widgets ? 1 : 0.4
        savedButton.alpha = tabItem == .saved ? 1 : 0.4
    }
    
    var didSelect: Signal<TabItem> {
        Signal
            .merge(
                widgetsButton.rx.tap
                    .map { TabItem.widgets }
                    .asSignal(onErrorSignalWith: .never()),
                savedButton.rx.tap
                    .map { TabItem.saved }
                    .asSignal(onErrorSignalWith: .never())
            )
    }
}

// MARK: Private
private extension WidgetsPresetsTabView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension WidgetsPresetsTabView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            widgetsButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            widgetsButton.topAnchor.constraint(equalTo: topAnchor),
            widgetsButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            savedButton.leadingAnchor.constraint(equalTo: widgetsButton.trailingAnchor, constant: 16.scale),
            savedButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            savedButton.topAnchor.constraint(equalTo: topAnchor),
            savedButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPresetsTabView {
    func makeButton(title: String) -> UIButton {
        let view = UIButton()
        view.alpha = 0.4
        view.setAttributedTitle(title.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
