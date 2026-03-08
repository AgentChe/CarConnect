//
//  WidgetBuilderEnterNameView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 08.03.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetBuilderEnterNameView: UIView {
    enum Constants {
        static let containerHeight = 251.scale
    }
    
    lazy var dimmedView = makeDimmedView()
    lazy var container = makeContainer()
    lazy var titleLabel = makeTitleLabel()
    lazy var textField = makeTextField()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var saveButton = makeSaveButton()
    
    private lazy var containerBottomConstraint = NSLayoutConstraint()
    
    private lazy var didTapSaveTrigger = PublishRelay<String>()
    
    private let placeholder: String
    
    init(placeholder: String) {
        self.placeholder = placeholder
        
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
extension WidgetBuilderEnterNameView {
    func animateIn() {
        containerBottomConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut]) { [weak self] in
            self?.dimmedView.alpha = 1
            
            self?.layoutIfNeeded()
        }
    }
    
    func animateOut(completion: (() -> Void)? = nil) {
        containerBottomConstraint.constant = Constants.containerHeight
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn]) { [weak self] in
            self?.dimmedView.alpha = 0
            
            self?.layoutIfNeeded()
        } completion: { _ in
            completion?()
        }
    }
    
    var didTapSave: Signal<String> {
        Signal
            .merge(
                didTapSaveTrigger.asSignal(),
                saveButton.rx.tap
                    .compactMap { [weak self] in self?.textField.text }
                    .asSignal(onErrorSignalWith: .never())
            )
    }
}

// MARK: UITextFieldDelegate
extension WidgetBuilderEnterNameView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let empty = isEmpty()
        
        if !empty {
            didTapSaveTrigger.accept((textField.text ?? ""))
        }
        
        return !empty
    }
}

// MARK: Private
private extension WidgetBuilderEnterNameView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    @objc
    func didEditingChanged() {
        let empty = isEmpty()
        
        saveButton.alpha = empty ? 0.6 : 1
        saveButton.isUserInteractionEnabled = !empty
    }
    
    func isEmpty() -> Bool {
        (textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

// MARK: Make constraints
private extension WidgetBuilderEnterNameView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            dimmedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dimmedView.topAnchor.constraint(equalTo: topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        containerBottomConstraint = container.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: Constants.containerHeight)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerBottomConstraint,
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.containerHeight),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            textField.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            saveButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            saveButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20.scale),
            saveButton.heightAnchor.constraint(equalToConstant: 51.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetBuilderEnterNameView {
    func makeDimmedView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(integralRed: 3, green: 3, blue: 3, alpha: 0.5)
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.color_21232A
        view.layer.cornerRadius = 10.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.semiBold(size: 20.scale))
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "WidgetsBuilders.EnterName.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
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
        view.text = placeholder
        view.defaultTextAttributes = attrs.dictionary
        view.returnKeyType = .done
        view.backgroundColor = Appearance.color_2C2F39
        view.layer.cornerRadius = 10.scale
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.delegate = self
        view.addTarget(self, action: #selector(didEditingChanged), for: .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF.withAlphaComponent(0.6))
            .font(Fonts.Inter.regular(size: 14.scale))
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "WidgetsBuilders.EnterName.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeSaveButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.medium(size: 16.scale))
        
        let view = UIButton()
        view.backgroundColor = Appearance.color_4178F6
        view.layer.cornerRadius = 10.scale
        view.setAttributedTitle("Save".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
