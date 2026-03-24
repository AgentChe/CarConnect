//
//  SelectLocationSearchField.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 23.03.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class SelectLocationSearchField: UIView {
    lazy var iconView = makeIconView()
    lazy var textField = makeTextField()
    
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
extension SelectLocationSearchField {
    var didEnterName: Signal<String> {
        textField.rx.text.orEmpty
            .asSignal(onErrorSignalWith: .empty())
    }
}

// MARK: UITextFieldDelegate
extension SelectLocationSearchField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Private
private extension SelectLocationSearchField {
    func initialize() {
        backgroundColor = Appearance.color_2C2F39
        layer.cornerRadius = 10.scale
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension SelectLocationSearchField {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44.scale),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SelectLocationSearchField {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "WidgetsBuilders.Search")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextField() -> PaddingTextField {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.regular(size: 16.scale))
            .textAlignment(.left)
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF.withAlphaComponent(0.4))
            .font(Fonts.Inter.regular(size: 16.scale))
            .textAlignment(.left)
        
        let view = PaddingTextField()
        view.defaultTextAttributes = attrs.dictionary
        view.attributedPlaceholder = "WidgetsBuilders.Location.Search".localized.attributed(with: placeholderAttrs)
        view.keyboardType = .default
        view.delegate = self
        view.textPadding = UIEdgeInsets(vertical: 16.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
