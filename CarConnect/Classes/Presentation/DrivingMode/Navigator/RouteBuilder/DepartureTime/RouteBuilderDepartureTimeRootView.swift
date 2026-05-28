//
//  RouteBuilderDepartureTimeRootView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.05.2026.
//

import UIKit

final class RouteBuilderDepartureTimeRootView: UIView {
    lazy var blurView = makeBlurView()
    lazy var overlayView = makeOverlayView()
    lazy var titleLabel = makeTitleLabel()
    lazy var closeButton = makeCloseButton()
    lazy var datePicker = makeDatePicker()
    lazy var resetButton = makeResetButton()
    lazy var doneButton = makeDoneButton()
    
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
private extension RouteBuilderDepartureTimeRootView {
    func initialize() {
        layer.cornerRadius = 10.landscapeHScale
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension RouteBuilderDepartureTimeRootView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.landscapeHScale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.landscapeHScale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.landscapeVScale)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.landscapeHScale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.landscapeHScale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.landscapeHScale),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.landscapeVScale)
        ])

        NSLayoutConstraint.activate([
            resetButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.landscapeHScale),
            resetButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.landscapeVScale),
            resetButton.widthAnchor.constraint(equalToConstant: 140.landscapeHScale),
            resetButton.heightAnchor.constraint(equalToConstant: 48.landscapeVScale)
        ])
        
        NSLayoutConstraint.activate([
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.landscapeHScale),
            doneButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.landscapeVScale),
            doneButton.widthAnchor.constraint(equalToConstant: 140.landscapeHScale),
            doneButton.heightAnchor.constraint(equalToConstant: 48.landscapeVScale)
        ])
    }
}

// MARK: Lazy initialization
private extension RouteBuilderDepartureTimeRootView {
    func makeBlurView() -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialDark))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }

    func makeOverlayView() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.color_000000.withAlphaComponent(0.35)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.bold(size: 20.landscapeHScale))
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Navigator.RouteBuilderDepartureTime.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.dx = -10.landscapeHScale
        view.dy = -10.landscapeHScale
        view.setImage(UIImage(named: "Navigator.RouteBuilder.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDatePicker() -> UIDatePicker {
        let view = UIDatePicker()
        view.datePickerMode = .dateAndTime
        view.preferredDatePickerStyle = .wheels
        // en_GB forces 24-hour format — no AM/PM column
        view.locale = Locale(identifier: "en_GB")
        view.minimumDate = Date()
        view.backgroundColor = .clear
        view.overrideUserInterfaceStyle = .dark
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeResetButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.bold(size: 20.landscapeHScale))
        
        let view = UIButton()
        view.setAttributedTitle("Navigator.RouteBuilderDepartureTime.Reset".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.color_FFFFFF.withAlphaComponent(0.16)
        view.layer.cornerRadius = 10.landscapeHScale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDoneButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.bold(size: 20.landscapeHScale))
        
        let view = UIButton()
        view.setAttributedTitle("Done".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.color_4178F6
        view.layer.cornerRadius = 10.landscapeHScale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
