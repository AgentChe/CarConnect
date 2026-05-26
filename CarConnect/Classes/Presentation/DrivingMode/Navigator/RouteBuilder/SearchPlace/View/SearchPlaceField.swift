//
//  SearchPlaceField.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 26.05.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchPlaceField: UIView {
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
extension SearchPlaceField {
    var didEnterAddress: Signal<String> {
        textField.rx.controlEvent(.editingChanged)
            .withLatestFrom(textField.rx.text.orEmpty)
            .asSignal(onErrorSignalWith: .empty())
    }
}

// MARK: UITextFieldDelegate
extension SearchPlaceField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Private
private extension SearchPlaceField {
    func initialize() {
        backgroundColor = Appearance.color_FFFFFF.withAlphaComponent(0.1)
        layer.cornerRadius = 10.landscapeHScale
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension SearchPlaceField {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.landscapeHScale),
            iconView.heightAnchor.constraint(equalToConstant: 24.landscapeHScale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.landscapeHScale)
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44.landscapeHScale),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.landscapeHScale),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SearchPlaceField {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Navigator.RouteBuilder.Search")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextField() -> PaddingTextField {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.regular(size: 16.landscapeHScale))
            .textAlignment(.left)
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF.withAlphaComponent(0.4))
            .font(Fonts.Inter.regular(size: 16.landscapeHScale))
            .textAlignment(.left)
        
        let view = PaddingTextField()
        view.defaultTextAttributes = attrs.dictionary
        view.attributedPlaceholder = "Navigator.RouteBuilder.Search".localized.attributed(with: placeholderAttrs)
        view.keyboardType = .default
        view.delegate = self
        view.textPadding = UIEdgeInsets(vertical: 10.landscapeVScale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
