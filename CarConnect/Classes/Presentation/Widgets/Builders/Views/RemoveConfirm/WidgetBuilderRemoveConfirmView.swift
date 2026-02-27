//
//  WidgetBuilderRemoveConfirmView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.02.2026.
//

import UIKit

final class WidgetBuilderRemoveConfirmView: UIView {
    enum Constants {
        static let containerHeight = 280.scale
    }
    
    lazy var dimmedView = makeDimmedView()
    lazy var container = makeContainer()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var removeButton = makeRemoveButton()
    lazy var cancelButton = makeCancelButton()
    
    private lazy var containerBottomConstraint = NSLayoutConstraint()
    
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
extension WidgetBuilderRemoveConfirmView {
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
}

// MARK: Private
private extension WidgetBuilderRemoveConfirmView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension WidgetBuilderRemoveConfirmView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            dimmedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dimmedView.topAnchor.constraint(equalTo: topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        containerBottomConstraint = container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.containerHeight)
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
            subTitleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            removeButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            removeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            removeButton.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            cancelButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            cancelButton.topAnchor.constraint(equalTo: removeButton.bottomAnchor, constant: 10.scale),
            cancelButton.bottomAnchor.constraint(equalTo: container.safeAreaLayoutGuide.bottomAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetBuilderRemoveConfirmView {
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
            .lineHeight(28.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "WidgetsBuilders.RemoveWidget.Confirm.Title".localized.attributed(with: attrs)
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF.withAlphaComponent(0.6))
            .font(Fonts.Inter.regular(size: 16.scale))
            .lineHeight(24.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "WidgetsBuilders.RemoveWidget.Confirm.SubTitle".localized.attributed(with: attrs)
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeRemoveButton() -> UIButton {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = Appearance.color_4178F6
        config.cornerStyle = .fixed
        config.background.cornerRadius = 10.scale
        config.contentInsets = NSDirectionalEdgeInsets(top: 16.scale, leading: 16.scale, bottom: 16.scale, trailing: 16.scale)
        
        let attrs = AttributeContainer([
            .foregroundColor: Appearance.color_FFFFFF,
            .font: Fonts.Inter.medium(size: 16.scale)
        ])
        
        config.attributedTitle = AttributedString("WidgetsBuilders.RemoveWidget.Confirm.Accept".localized, attributes: attrs)
        
        let view = UIButton(configuration: config)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeCancelButton() -> UIButton {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor.clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 16.scale, leading: 16.scale, bottom: 16.scale, trailing: 16.scale)
        
        let attrs = AttributeContainer([
            .foregroundColor: Appearance.color_6C99FF,
            .font: Fonts.Inter.medium(size: 16.scale)
        ])
        
        config.attributedTitle = AttributedString("Cancel".localized, attributes: attrs)
        
        let view = UIButton(configuration: config)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
