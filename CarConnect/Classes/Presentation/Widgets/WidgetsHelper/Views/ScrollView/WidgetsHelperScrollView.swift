//
//  WidgetsHelperScrollView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 21.02.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetsHelperScrollView: UIView {
    enum Representation {
        case setup, carPlay, phone
    }
    
    lazy var scrollView = makeScrollView()
    lazy var container = makeContainer()
    
    private lazy var didTapAcceptTrigger = PublishRelay<Void>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WidgetsHelperScrollView {
    func accept(representation: Representation) {
        container.subviews.forEach { $0.removeFromSuperview() }
        
        switch representation {
        case .setup:
            makeSetupRepresentation()
        case .carPlay:
            makeCarPlayRepresentation()
        case .phone:
            makePhoneRepresentation()
        }
        
        layoutIfNeeded()
    }
    
    var didTapAccept: Signal<Void> {
        didTapAcceptTrigger.asSignal()
    }
}

// MARK: Private
private extension WidgetsHelperScrollView {
    func makeSetupRepresentation() {
        let step1TextView = WidgetsHelperScrollTextView(step: 1, subTitle: "WidgetsHelper.Setup.Step1.SubTitle".localized)
        step1TextView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(step1TextView)
        
        NSLayoutConstraint.activate([
            step1TextView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            step1TextView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            step1TextView.topAnchor.constraint(equalTo: container.topAnchor)
        ])
        
        let step1ImageView = WidgetsHelperScrollImageView(imageName: "WidgetsHelper.Setup.Step1")
        step1ImageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(step1ImageView)
        
        NSLayoutConstraint.activate([
            step1ImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            step1ImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            step1ImageView.topAnchor.constraint(equalTo: step1TextView.bottomAnchor, constant: 12.scale),
            step1ImageView.heightAnchor.constraint(equalToConstant: 343.scale)
        ])
        
        let step2TextView = WidgetsHelperScrollTextView(step: 2, subTitle: "WidgetsHelper.Setup.Step2.SubTitle".localized)
        step2TextView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(step2TextView)
        
        NSLayoutConstraint.activate([
            step2TextView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            step2TextView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            step2TextView.topAnchor.constraint(equalTo: step1ImageView.bottomAnchor, constant: 16.scale)
        ])
        
        let step2ImageView = WidgetsHelperScrollImageView(imageName: "WidgetsHelper.Setup.Step2")
        step2ImageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(step2ImageView)
        
        NSLayoutConstraint.activate([
            step2ImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            step2ImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            step2ImageView.topAnchor.constraint(equalTo: step2TextView.bottomAnchor, constant: 12.scale),
            step2ImageView.heightAnchor.constraint(equalToConstant: 307.scale)
        ])
        
        let step3TextView = WidgetsHelperScrollTextView(step: 3, subTitle: "WidgetsHelper.Setup.Step3.SubTitle".localized)
        step3TextView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(step3TextView)
        
        NSLayoutConstraint.activate([
            step3TextView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            step3TextView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            step3TextView.topAnchor.constraint(equalTo: step2ImageView.bottomAnchor, constant: 16.scale)
        ])
        
        let step3ImageView = WidgetsHelperScrollImageView(imageName: "WidgetsHelper.Setup.Step3")
        step3ImageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(step3ImageView)
        
        NSLayoutConstraint.activate([
            step3ImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            step3ImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            step3ImageView.topAnchor.constraint(equalTo: step3TextView.bottomAnchor, constant: 12.scale),
            step3ImageView.heightAnchor.constraint(equalToConstant: 243.scale)
        ])
        
        let step4TextView = WidgetsHelperScrollTextView(step: 4, subTitle: "WidgetsHelper.Setup.Step4.SubTitle".localized)
        step4TextView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(step4TextView)
        
        NSLayoutConstraint.activate([
            step4TextView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            step4TextView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            step4TextView.topAnchor.constraint(equalTo: step3ImageView.bottomAnchor, constant: 16.scale)
        ])
        
        let step4ImageView = WidgetsHelperScrollImageView(imageName: "WidgetsHelper.Setup.Step4")
        step4ImageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(step4ImageView)
        
        NSLayoutConstraint.activate([
            step4ImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            step4ImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            step4ImageView.topAnchor.constraint(equalTo: step4TextView.bottomAnchor, constant: 12.scale),
            step4ImageView.heightAnchor.constraint(equalToConstant: 446.scale)
        ])
        
        let acceptButton = WidgetsHelperScrollAcceptButton()
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(acceptButton)
        
        acceptButton.didTap = { [weak self] in
            self?.didTapAcceptTrigger.accept(Void())
        }
        
        NSLayoutConstraint.activate([
            acceptButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            acceptButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            acceptButton.topAnchor.constraint(equalTo: step4ImageView.bottomAnchor, constant: 16.scale),
            acceptButton.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            acceptButton.heightAnchor.constraint(equalToConstant: 50.scale)
        ])
    }
    
    func makeCarPlayRepresentation() {
        let step1TextView = WidgetsHelperScrollTextView(step: 1, subTitle: "WidgetsHelper.CarPlay.Step1.SubTitle".localized)
        step1TextView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(step1TextView)
        
        NSLayoutConstraint.activate([
            step1TextView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            step1TextView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            step1TextView.topAnchor.constraint(equalTo: container.topAnchor)
        ])
        
        let step1ImageView = WidgetsHelperScrollImageView(imageName: "WidgetsHelper.CarPlay.Step1")
        step1ImageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(step1ImageView)
        
        NSLayoutConstraint.activate([
            step1ImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            step1ImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            step1ImageView.topAnchor.constraint(equalTo: step1TextView.bottomAnchor, constant: 12.scale),
            step1ImageView.heightAnchor.constraint(equalToConstant: 289.scale)
        ])
        
        let step2TextView = WidgetsHelperScrollTextView(step: 2, subTitle: "WidgetsHelper.CarPlay.Step2.SubTitle".localized)
        step2TextView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(step2TextView)
        
        NSLayoutConstraint.activate([
            step2TextView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            step2TextView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            step2TextView.topAnchor.constraint(equalTo: step1ImageView.bottomAnchor, constant: 16.scale)
        ])
        
        let step2ImageView = WidgetsHelperScrollImageView(imageName: "WidgetsHelper.CarPlay.Step2")
        step2ImageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(step2ImageView)
        
        NSLayoutConstraint.activate([
            step2ImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            step2ImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            step2ImageView.topAnchor.constraint(equalTo: step2TextView.bottomAnchor, constant: 12.scale),
            step2ImageView.heightAnchor.constraint(equalToConstant: 280.scale)
        ])
        
        let step3TextView = WidgetsHelperScrollTextView(step: 3, subTitle: "WidgetsHelper.CarPlay.Step3.SubTitle".localized)
        step3TextView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(step3TextView)
        
        NSLayoutConstraint.activate([
            step3TextView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            step3TextView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            step3TextView.topAnchor.constraint(equalTo: step2ImageView.bottomAnchor, constant: 16.scale)
        ])
        
        let step3ImageView = WidgetsHelperScrollImageView(imageName: "WidgetsHelper.CarPlay.Step3")
        step3ImageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(step3ImageView)
        
        NSLayoutConstraint.activate([
            step3ImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            step3ImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            step3ImageView.topAnchor.constraint(equalTo: step3TextView.bottomAnchor, constant: 12.scale),
            step3ImageView.heightAnchor.constraint(equalToConstant: 262.scale)
        ])
        
        let step4TextView = WidgetsHelperScrollTextView(step: 4, subTitle: "WidgetsHelper.CarPlay.Step4.SubTitle".localized)
        step4TextView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(step4TextView)
        
        NSLayoutConstraint.activate([
            step4TextView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            step4TextView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            step4TextView.topAnchor.constraint(equalTo: step3ImageView.bottomAnchor, constant: 16.scale)
        ])
        
        let step4ImageView = WidgetsHelperScrollImageView(imageName: "WidgetsHelper.CarPlay.Step4")
        step4ImageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(step4ImageView)
        
        NSLayoutConstraint.activate([
            step4ImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            step4ImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            step4ImageView.topAnchor.constraint(equalTo: step4TextView.bottomAnchor, constant: 12.scale),
            step4ImageView.heightAnchor.constraint(equalToConstant: 623.scale)
        ])
        
        let step5TextView = WidgetsHelperScrollTextView(step: 5, subTitle: "WidgetsHelper.CarPlay.Step5.SubTitle".localized)
        step5TextView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(step5TextView)
        
        NSLayoutConstraint.activate([
            step5TextView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            step5TextView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            step5TextView.topAnchor.constraint(equalTo: step4ImageView.bottomAnchor, constant: 16.scale)
        ])
        
        let step5ImageView = WidgetsHelperScrollImageView(imageName: "WidgetsHelper.CarPlay.Step5")
        step5ImageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(step5ImageView)
        
        NSLayoutConstraint.activate([
            step5ImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            step5ImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            step5ImageView.topAnchor.constraint(equalTo: step5TextView.bottomAnchor, constant: 12.scale),
            step5ImageView.heightAnchor.constraint(equalToConstant: 283.scale)
        ])
        
        let acceptButton = WidgetsHelperScrollAcceptButton()
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(acceptButton)
        
        acceptButton.didTap = { [weak self] in
            self?.didTapAcceptTrigger.accept(Void())
        }
        
        NSLayoutConstraint.activate([
            acceptButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            acceptButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            acceptButton.topAnchor.constraint(equalTo: step5ImageView.bottomAnchor, constant: 16.scale),
            acceptButton.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            acceptButton.heightAnchor.constraint(equalToConstant: 50.scale)
        ])
    }
    
    func makePhoneRepresentation() {
        let step1TextView = WidgetsHelperScrollTextView(step: 1, subTitle: "WidgetsHelper.Phone.Step1.SubTitle".localized)
        step1TextView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(step1TextView)
        
        NSLayoutConstraint.activate([
            step1TextView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            step1TextView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            step1TextView.topAnchor.constraint(equalTo: container.topAnchor)
        ])
        
        let step1ImageView = WidgetsHelperScrollImageView(imageName: "WidgetsHelper.Phone.Step1")
        step1ImageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(step1ImageView)
        
        NSLayoutConstraint.activate([
            step1ImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            step1ImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            step1ImageView.topAnchor.constraint(equalTo: step1TextView.bottomAnchor, constant: 12.scale),
            step1ImageView.heightAnchor.constraint(equalToConstant: 188.scale)
        ])
        
        let step2TextView = WidgetsHelperScrollTextView(step: 2, subTitle: "WidgetsHelper.Phone.Step2.SubTitle".localized)
        step2TextView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(step2TextView)
        
        NSLayoutConstraint.activate([
            step2TextView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            step2TextView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            step2TextView.topAnchor.constraint(equalTo: step1ImageView.bottomAnchor, constant: 16.scale)
        ])
        
        let step2ImageView = WidgetsHelperScrollImageView(imageName: "WidgetsHelper.Phone.Step2")
        step2ImageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(step2ImageView)
        
        NSLayoutConstraint.activate([
            step2ImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            step2ImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            step2ImageView.topAnchor.constraint(equalTo: step2TextView.bottomAnchor, constant: 12.scale),
            step2ImageView.heightAnchor.constraint(equalToConstant: 230.scale)
        ])
        
        let step3TextView = WidgetsHelperScrollTextView(step: 3, subTitle: "WidgetsHelper.Phone.Step3.SubTitle".localized)
        step3TextView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(step3TextView)
        
        NSLayoutConstraint.activate([
            step3TextView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            step3TextView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            step3TextView.topAnchor.constraint(equalTo: step2ImageView.bottomAnchor, constant: 16.scale)
        ])
        
        let step3ImageView = WidgetsHelperScrollImageView(imageName: "WidgetsHelper.Phone.Step3")
        step3ImageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(step3ImageView)
        
        NSLayoutConstraint.activate([
            step3ImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            step3ImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            step3ImageView.topAnchor.constraint(equalTo: step3TextView.bottomAnchor, constant: 12.scale),
            step3ImageView.heightAnchor.constraint(equalToConstant: 262.scale)
        ])
        
        let step4TextView = WidgetsHelperScrollTextView(step: 4, subTitle: "WidgetsHelper.Phone.Step4.SubTitle".localized)
        step4TextView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(step4TextView)
        
        NSLayoutConstraint.activate([
            step4TextView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            step4TextView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            step4TextView.topAnchor.constraint(equalTo: step3ImageView.bottomAnchor, constant: 16.scale)
        ])
        
        let step4ImageView = WidgetsHelperScrollImageView(imageName: "WidgetsHelper.Phone.Step4")
        step4ImageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(step4ImageView)
        
        NSLayoutConstraint.activate([
            step4ImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            step4ImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            step4ImageView.topAnchor.constraint(equalTo: step4TextView.bottomAnchor, constant: 12.scale),
            step4ImageView.heightAnchor.constraint(equalToConstant: 623.scale)
        ])
        
        let acceptButton = WidgetsHelperScrollAcceptButton()
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(acceptButton)
        
        acceptButton.didTap = { [weak self] in
            self?.didTapAcceptTrigger.accept(Void())
        }
        
        NSLayoutConstraint.activate([
            acceptButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            acceptButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            acceptButton.topAnchor.constraint(equalTo: step4ImageView.bottomAnchor, constant: 16.scale),
            acceptButton.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            acceptButton.heightAnchor.constraint(equalToConstant: 50.scale)
        ])
    }
}

// MARK: Make constraints
private extension WidgetsHelperScrollView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            container.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: scrollView.topAnchor),
            container.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsHelperScrollView {
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(vertical: 16.scale)
        view.setContentOffset(CGPoint(x: 0, y: -16.scale), animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
}
