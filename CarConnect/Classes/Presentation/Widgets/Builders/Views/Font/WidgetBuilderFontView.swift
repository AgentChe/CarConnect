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
    lazy var bebasNeueButton = makeFontButton(widgetsFonts: .bebasNeue)
    lazy var jaroButton = makeFontButton(widgetsFonts: .jaro)
    lazy var pacificoButton = makeFontButton(widgetsFonts: .pacifico)
    lazy var caveatBrushButton = makeFontButton(widgetsFonts: .caveatBrush)
    lazy var dmSerifDisplayButton = makeFontButton(widgetsFonts: .dmSerifDisplay)
    lazy var kalniaButton = makeFontButton(widgetsFonts: .kalnia)
    lazy var zenDotsButton = makeFontButton(widgetsFonts: .zenDots)
    lazy var dseg7ClassicButton = makeFontButton(widgetsFonts: .dseg7Classic)
    lazy var holtwoodOneSCButton = makeFontButton(widgetsFonts: .holtwoodOneSC)
    lazy var gravitasOneButton = makeFontButton(widgetsFonts: .gravitasOne)
    lazy var interButton = makeFontButton(widgetsFonts: .inter)
    
    private lazy var fontsButtons = [
        bebasNeueButton,
        jaroButton,
        pacificoButton,
        caveatBrushButton,
        dmSerifDisplayButton,
        kalniaButton,
        zenDotsButton,
        dseg7ClassicButton,
        holtwoodOneSCButton,
        gravitasOneButton,
        interButton
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
                bebasNeueButton.didTap,
                jaroButton.didTap,
                pacificoButton.didTap,
                caveatBrushButton.didTap,
                dmSerifDisplayButton.didTap,
                kalniaButton.didTap,
                zenDotsButton.didTap,
                dseg7ClassicButton.didTap,
                holtwoodOneSCButton.didTap,
                gravitasOneButton.didTap,
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
            bebasNeueButton.leadingAnchor.constraint(equalTo: resetButton.trailingAnchor, constant: 8.scale),
            bebasNeueButton.topAnchor.constraint(equalTo: container.topAnchor),
            bebasNeueButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            jaroButton.leadingAnchor.constraint(equalTo: bebasNeueButton.trailingAnchor, constant: 8.scale),
            jaroButton.topAnchor.constraint(equalTo: container.topAnchor),
            jaroButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            pacificoButton.leadingAnchor.constraint(equalTo: jaroButton.trailingAnchor, constant: 8.scale),
            pacificoButton.topAnchor.constraint(equalTo: container.topAnchor),
            pacificoButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            caveatBrushButton.leadingAnchor.constraint(equalTo: pacificoButton.trailingAnchor, constant: 8.scale),
            caveatBrushButton.topAnchor.constraint(equalTo: container.topAnchor),
            caveatBrushButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dmSerifDisplayButton.leadingAnchor.constraint(equalTo: caveatBrushButton.trailingAnchor, constant: 8.scale),
            dmSerifDisplayButton.topAnchor.constraint(equalTo: container.topAnchor),
            dmSerifDisplayButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            kalniaButton.leadingAnchor.constraint(equalTo: dmSerifDisplayButton.trailingAnchor, constant: 8.scale),
            kalniaButton.topAnchor.constraint(equalTo: container.topAnchor),
            kalniaButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            zenDotsButton.leadingAnchor.constraint(equalTo: kalniaButton.trailingAnchor, constant: 8.scale),
            zenDotsButton.topAnchor.constraint(equalTo: container.topAnchor),
            zenDotsButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dseg7ClassicButton.leadingAnchor.constraint(equalTo: zenDotsButton.trailingAnchor, constant: 8.scale),
            dseg7ClassicButton.topAnchor.constraint(equalTo: container.topAnchor),
            dseg7ClassicButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            holtwoodOneSCButton.leadingAnchor.constraint(equalTo: dseg7ClassicButton.trailingAnchor, constant: 8.scale),
            holtwoodOneSCButton.topAnchor.constraint(equalTo: container.topAnchor),
            holtwoodOneSCButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            gravitasOneButton.leadingAnchor.constraint(equalTo: holtwoodOneSCButton.trailingAnchor, constant: 8.scale),
            gravitasOneButton.topAnchor.constraint(equalTo: container.topAnchor),
            gravitasOneButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            interButton.leadingAnchor.constraint(equalTo: gravitasOneButton.trailingAnchor, constant: 8.scale),
            interButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            interButton.topAnchor.constraint(equalTo: container.topAnchor),
            interButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
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
