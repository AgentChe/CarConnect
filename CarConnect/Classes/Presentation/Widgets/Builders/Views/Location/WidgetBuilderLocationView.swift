//
//  WidgetBuilderLocationView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 23.03.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetBuilderLocationView: UIView {
    weak var parentVC: UIViewController?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var valueLabel = makeLabel()
    lazy var arrowView = makeArrowView()
    
    private var location: Location?
    
    private lazy var valueAttrs = TextAttributes()
        .textColor(Appearance.color_FFFFFF)
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(20.scale)
        .textAlignment(.right)
        .lineBreakMode(.byTruncatingTail)
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didSelectLocationTrigger = PublishRelay<Location>()
    
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
extension WidgetBuilderLocationView {
    func setup(location: Location) {
        self.location = location
        
        valueLabel.attributedText = location.name.attributed(with: valueAttrs)
    }
    
    var didSelectLocation: Signal<Location> {
        didSelectLocationTrigger.asSignal()
    }
}

// MARK: Private
private extension WidgetBuilderLocationView {
    func initialize() {
        backgroundColor = Appearance.color_2C2F39
        layer.cornerRadius = 10.scale
        
        let tapGesture = UITapGestureRecognizer()
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .bind(to: Binder(self) { base, event in
                guard let parentVC = base.parentVC else { return }
                
                let selectVC = SelectLocationViewController.make(location: base.location) { [weak self] location in
                    self?.didSelectLocationTrigger.accept(location)
                }
                parentVC.present(selectVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make constraints
private extension WidgetBuilderLocationView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.scale),
            titleLabel.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: -8.scale),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.trailingAnchor.constraint(equalTo: arrowView.leadingAnchor, constant: -4.scale),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            arrowView.widthAnchor.constraint(equalToConstant: 24.scale),
            arrowView.heightAnchor.constraint(equalToConstant: 24.scale),
            arrowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.scale),
            arrowView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetBuilderLocationView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.medium(size: 16.scale))
            .lineHeight(20.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "WidgetsBuilders.Location.Title".localized.attributed(with: attrs)
        view.numberOfLines = 1
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 1
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeArrowView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "WidgetsBuilders.Arrow")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
