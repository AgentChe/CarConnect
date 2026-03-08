//
//  WidgetBuilderFontView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 24.02.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetBuilderFontView: UIView {
    lazy var label = makeLabel()
    lazy var scrollView = makeScrollView()
    lazy var container = makeContainer()
    lazy var resetButton = makeResetButton()
    lazy var interButton = makeFontButton(widgetsFonts: .inter)
    lazy var poppinsButton = makeFontButton(widgetsFonts: .poppins)
    lazy var audiowideButton = makeFontButton(widgetsFonts: .audiowide)
    lazy var orbitronButton = makeFontButton(widgetsFonts: .orbitron)
    lazy var archivoBlackButton = makeFontButton(widgetsFonts: .archivoBlack)
    lazy var rubikButton = makeFontButton(widgetsFonts: .rubik)
    lazy var abrilFatfaceButton = makeFontButton(widgetsFonts: .abrilFatface)
    lazy var playfairDisplayButton = makeFontButton(widgetsFonts: .playfairDisplay)
    lazy var georgiaButton = makeFontButton(widgetsFonts: .georgia)
    lazy var soraButton = makeFontButton(widgetsFonts: .sora)
    lazy var spaceGroteskButton = makeFontButton(widgetsFonts: .spaceGrotesk)
    
    private lazy var fontsButtons = [
        interButton,
        poppinsButton,
        audiowideButton,
        orbitronButton,
        archivoBlackButton,
        rubikButton,
        abrilFatfaceButton,
        playfairDisplayButton,
        georgiaButton,
        soraButton,
        spaceGroteskButton
    ]
    
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
extension WidgetBuilderFontView {
    func setup(selectedFont: WidgetsFonts, defaultFont: WidgetsFonts) {
        resetButton.setup(enable: selectedFont != defaultFont)
        
        fontsButtons.forEach {
            $0.setup(selected: $0.font == selectedFont)
        }
    }
    
    var didReset: Signal<Void> {
        resetButton.rx.tap.asSignal()
    }
    
    var didSelect: Signal<WidgetsFonts> {
        Signal<WidgetsFonts>
            .merge(
                poppinsButton.didTap,
                audiowideButton.didTap,
                orbitronButton.didTap,
                archivoBlackButton.didTap,
                rubikButton.didTap,
                abrilFatfaceButton.didTap,
                playfairDisplayButton.didTap,
                georgiaButton.didTap,
                soraButton.didTap,
                spaceGroteskButton.didTap,
                interButton.didTap
            )
    }
}

// MARK: Private
private extension WidgetBuilderFontView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension WidgetBuilderFontView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 48.scale)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            container.topAnchor.constraint(equalTo: scrollView.topAnchor),
            container.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 48.scale)
        ])
        
        NSLayoutConstraint.activate([
            resetButton.widthAnchor.constraint(equalToConstant: 48.scale),
            resetButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            resetButton.topAnchor.constraint(equalTo: container.topAnchor),
            resetButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            interButton.leadingAnchor.constraint(equalTo: resetButton.trailingAnchor, constant: 8.scale),
            interButton.topAnchor.constraint(equalTo: container.topAnchor),
            interButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            poppinsButton.leadingAnchor.constraint(equalTo: interButton.trailingAnchor, constant: 8.scale),
            poppinsButton.topAnchor.constraint(equalTo: container.topAnchor),
            poppinsButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            audiowideButton.leadingAnchor.constraint(equalTo: poppinsButton.trailingAnchor, constant: 8.scale),
            audiowideButton.topAnchor.constraint(equalTo: container.topAnchor),
            audiowideButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            orbitronButton.leadingAnchor.constraint(equalTo: audiowideButton.trailingAnchor, constant: 8.scale),
            orbitronButton.topAnchor.constraint(equalTo: container.topAnchor),
            orbitronButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            archivoBlackButton.leadingAnchor.constraint(equalTo: orbitronButton.trailingAnchor, constant: 8.scale),
            archivoBlackButton.topAnchor.constraint(equalTo: container.topAnchor),
            archivoBlackButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rubikButton.leadingAnchor.constraint(equalTo: archivoBlackButton.trailingAnchor, constant: 8.scale),
            rubikButton.topAnchor.constraint(equalTo: container.topAnchor),
            rubikButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            abrilFatfaceButton.leadingAnchor.constraint(equalTo: rubikButton.trailingAnchor, constant: 8.scale),
            abrilFatfaceButton.topAnchor.constraint(equalTo: container.topAnchor),
            abrilFatfaceButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            playfairDisplayButton.leadingAnchor.constraint(equalTo: abrilFatfaceButton.trailingAnchor, constant: 8.scale),
            playfairDisplayButton.topAnchor.constraint(equalTo: container.topAnchor),
            playfairDisplayButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            georgiaButton.leadingAnchor.constraint(equalTo: playfairDisplayButton.trailingAnchor, constant: 8.scale),
            georgiaButton.topAnchor.constraint(equalTo: container.topAnchor),
            georgiaButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            soraButton.leadingAnchor.constraint(equalTo: georgiaButton.trailingAnchor, constant: 8.scale),
            soraButton.topAnchor.constraint(equalTo: container.topAnchor),
            soraButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            spaceGroteskButton.leadingAnchor.constraint(equalTo: soraButton.trailingAnchor, constant: 8.scale),
            spaceGroteskButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            spaceGroteskButton.topAnchor.constraint(equalTo: container.topAnchor),
            spaceGroteskButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetBuilderFontView {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(22.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "WidgetsBuilders.Font".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.contentInset = UIEdgeInsets(horizontal: 16.scale)
        view.setContentOffset(CGPoint(x: 16.scale, y: 0), animated: false)
        view.showsHorizontalScrollIndicator = false
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
    
    func makeResetButton() -> WidgetBuilderResetItemButton {
        let view = WidgetBuilderResetItemButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeFontButton(widgetsFonts: WidgetsFonts) -> WidgetBuilderFontItemButton {
        let view = WidgetBuilderFontItemButton(font: widgetsFonts)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
