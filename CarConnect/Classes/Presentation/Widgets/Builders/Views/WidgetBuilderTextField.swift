//
//  WidgetBuilderTextField.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.03.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetBuilderTextField: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var container = makeContainer()
    lazy var textField = makeTextField()
    lazy var limitLabel = makeLimitLabel()
    
    private let title: String
    private let text: String
    private let placeholder: String
    private let limit: Int
    
    private lazy var limitAttrs = TextAttributes()
        .textColor(Appearance.color_FFFFFF.withAlphaComponent(0.4))
        .font(Fonts.Inter.regular(size: 12.scale))
        .lineHeight(17.scale)
    
    private lazy var didChangeTextTrigger = BehaviorRelay<String>(value: text)
    
    init(
        title: String = "WidgetsBuilders.TextField.Title".localized,
        text: String,
        placeholder: String,
        limit: Int
    ) {
        self.title = title
        self.text = text
        self.placeholder = placeholder
        self.limit = limit
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        didEditingChanged()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WidgetBuilderTextField {
    var didChangeText: Signal<String> {
        didChangeTextTrigger.asSignal(onErrorSignalWith: .never())
    }
}

// MARK: UITextFieldDelegate
extension WidgetBuilderTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""

        guard let textRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        return updatedText.count <= limit
    }
}

// MARK: Private
private extension WidgetBuilderTextField {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    @objc
    func didEditingChanged() {
        let currentCount = textField.text?.count ?? 0
        let string = String(format: "%i/%i", currentCount, limit)
        limitLabel.attributedText = string.attributed(with: limitAttrs)
        
        didChangeTextTrigger.accept(textField.text ?? "")
    }
}

// MARK: Make constraints
private extension WidgetBuilderTextField {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 50.scale)
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: limitLabel.leadingAnchor),
            textField.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            limitLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            limitLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetBuilderTextField {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(22.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.color_2C2F39
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextField() -> PaddingTextField {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.regular(size: 16.scale))
            .lineHeight(24.scale)
            .textAlignment(.left)
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF.withAlphaComponent(0.4))
            .font(Fonts.Inter.regular(size: 16.scale))
            .lineHeight(24.scale)
            .textAlignment(.left)
        
        let view = PaddingTextField()
        view.textPadding = UIEdgeInsets(vertical: 13.scale, horizontal: 16.scale)
        view.attributedPlaceholder = placeholder.attributed(with: placeholderAttrs)
        view.text = text
        view.defaultTextAttributes = attrs.dictionary
        view.returnKeyType = .done
        view.backgroundColor = UIColor.clear
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.delegate = self
        view.addTarget(self, action: #selector(didEditingChanged), for: .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLimitLabel() -> UILabel {
        let view = UILabel()
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
