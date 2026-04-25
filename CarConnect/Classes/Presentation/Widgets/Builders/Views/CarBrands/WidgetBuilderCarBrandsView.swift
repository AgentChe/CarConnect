//
//  WidgetBuilderCarBrandsView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 02.04.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetBuilderCarBrandsView: UIView {
    weak var parentVC: UIViewController?
    
    lazy var label = makeLabel()
    lazy var seeAllButton = makeSeeAllButton()
    lazy var scrollView = makeScrollView()
    lazy var container = makeContainer()
    
    private lazy var didSelectTrigger = PublishRelay<WidgetCarLogoBrand>()
    
    private lazy var itemsButtons = [WidgetBuilderCarBrandItemButton]()
    
    private var selected: WidgetCarLogoBrand?
    
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
extension WidgetBuilderCarBrandsView {
    func setup(brands: [WidgetCarLogoBrand]) {
        itemsButtons.forEach { $0.removeFromSuperview() }
        itemsButtons = []
        
        var leftView = container
        
        brands.enumerated().forEach { index, brand in
            let button = WidgetBuilderCarBrandItemButton(brand: brand)
            button.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(button)
            
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: container.topAnchor),
                button.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                button.widthAnchor.constraint(equalTo: button.heightAnchor)
            ])
            
            if index == 0 {
                button.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
            } else {
                button.leadingAnchor.constraint(equalTo: leftView.trailingAnchor, constant: 8.scale).isActive = true
            }
            
            if (brands.count - 1) == index {
                button.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
            }
            
            leftView = button
            
            button.addTarget(self, action: #selector(brandButtonTapped(sender:)), for: .touchUpInside)
            
            itemsButtons.append(button)
        }
        
        if let selected {
            setup(selected: selected)
        }
    }
    
    func setup(selected: WidgetCarLogoBrand) {
        self.selected = selected
        
        itemsButtons.forEach { button in
            button.setup(selected: button.brand == selected)
        }
    }
    
    var didSelect: Signal<WidgetCarLogoBrand> {
        didSelectTrigger.asSignal()
    }
}

// MARK: Private
private extension WidgetBuilderCarBrandsView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    @objc
    func brandButtonTapped(sender: UIButton) {
        guard let brandButton = sender as? WidgetBuilderCarBrandItemButton else { return }
        
        didSelectTrigger.accept(brandButton.brand)
    }
    
    @objc
    func seeAllTapped() {
        guard let parentVC else { return }
        
        let vc = WidgetCarBrandsListViewController.make(brand: selected) { [weak self] brand in
            self?.didSelectTrigger.accept(brand)
        }
        parentVC.present(vc, animated: true)
    }
}

// MARK: Make constraints
private extension WidgetBuilderCarBrandsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            seeAllButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            seeAllButton.centerYAnchor.constraint(equalTo: label.centerYAnchor)
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
    }
}

// MARK: Lazy initialization
private extension WidgetBuilderCarBrandsView {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(22.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "WidgetsPresets.CarLogo.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSeeAllButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.color_6C99FF)
            .font(Fonts.Inter.semiBold(size: 16.scale))
        
        let view = TapAreaButton()
        view.setAttributedTitle("WidgetsBuilders.SeeAll".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(seeAllTapped), for: .touchUpInside)
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
}
