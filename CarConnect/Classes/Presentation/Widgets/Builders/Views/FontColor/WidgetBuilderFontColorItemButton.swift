//
//  WidgetBuilderFontColorItemButton.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 24.02.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetBuilderFontColorItemButton: UIButton {
    lazy var colorView = makeColorView()
    
    let color: UIColor
    
    init(color: UIColor) {
        self.color = color
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WidgetBuilderFontColorItemButton {
    func setup(selected: Bool) {
        layer.borderWidth = selected ? 2.scale : 0
        layer.borderColor = selected ? Appearance.color_4178F6.cgColor : UIColor.clear.cgColor
        backgroundColor = selected ? UIColor.clear : color
    }
    
    var didTap: Signal<UIColor> {
        rx.tap
            .compactMap { [weak self] in self?.color }
            .asSignal(onErrorSignalWith: .never())
    }
}

// MARK: Private
private extension WidgetBuilderFontColorItemButton {
    func initialize() {
        backgroundColor = color
        layer.cornerRadius = 10.scale
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension WidgetBuilderFontColorItemButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4.scale),
            colorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4.scale),
            colorView.topAnchor.constraint(equalTo: topAnchor, constant: 4.scale),
            colorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetBuilderFontColorItemButton {
    func makeColorView() -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false 
        view.layer.cornerRadius = 6.scale
        view.layer.masksToBounds = true
        view.backgroundColor = color
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
