//
//  WidgetsPresetsHeaderView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.02.2026.
//

import UIKit

final class WidgetsPresetsHeaderView: UIView {
    lazy var tabView = makeTabView()
    lazy var helperButton = makeHelperButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension WidgetsPresetsHeaderView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension WidgetsPresetsHeaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tabView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            tabView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            helperButton.widthAnchor.constraint(equalToConstant: 36.scale),
            helperButton.heightAnchor.constraint(equalToConstant: 36.scale),
            helperButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            helperButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPresetsHeaderView {
    func makeTabView() -> WidgetsPresetsTabView {
        let view = WidgetsPresetsTabView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeHelperButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "WidgetsPresents.Helper"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
