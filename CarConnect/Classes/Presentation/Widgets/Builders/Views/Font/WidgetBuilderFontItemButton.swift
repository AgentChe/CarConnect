//
//  WidgetBuilderFontItemButton.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 24.02.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetBuilderFontItemButton: UIButton {
    lazy var colorView = makeColorView()
    lazy var label = makeLabel()
    
    let font: WidgetsFonts
    
    init(font: WidgetsFonts) {
        self.font = font
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WidgetBuilderFontItemButton {
    func setup(selected: Bool) {
        layer.borderWidth = selected ? 2.scale : 0
        layer.borderColor = selected ? Appearance.color_4178F6.cgColor : UIColor.clear.cgColor
        backgroundColor = selected ? UIColor.clear : Appearance.color_868EB2.withAlphaComponent(0.1)
        
        colorView.isHidden = !selected
    }
    
    var didTap: Signal<WidgetsFonts> {
        rx.tap
            .compactMap { [weak self] in self?.font }
            .asSignal(onErrorSignalWith: .never())
    }
}

// MARK: Private
private extension WidgetBuilderFontItemButton {
    func initialize() {
        backgroundColor = Appearance.color_868EB2.withAlphaComponent(0.1)
        layer.cornerRadius = 10.scale
        layer.masksToBounds = true
        
        colorView.isHidden = true
    }
}

// MARK: Make constraints
private extension WidgetBuilderFontItemButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4.scale),
            colorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4.scale),
            colorView.topAnchor.constraint(equalTo: topAnchor, constant: 4.scale),
            colorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.scale),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetBuilderFontItemButton {
    func makeColorView() -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.layer.cornerRadius = 6.scale
        view.layer.masksToBounds = true
        view.backgroundColor = Appearance.color_868EB2.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(font.uiFont(baseSize: 16.scale))
            .textColor(Appearance.color_FFFFFF)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Monday".attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
