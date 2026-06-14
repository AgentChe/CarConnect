//
//  NavigatorMusicEmptyView.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 13.06.2026.
//

import UIKit

protocol NavigatorMusicSelection: AnyObject {
    func didSelectSource(_ source: MusicSource)
}

class NavigatorMusicEmptyView: UIView {
    private lazy var containerView = makeContainer()
    private lazy var buttonsStack = makeButtonsStack()
    private lazy var label = makeLabel()
    
    private var disposeBag = DisposeBag()
    
    weak var delegate: NavigatorMusicSelection?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import RxSwift
import RxCocoa

// MARK: Private
private extension NavigatorMusicEmptyView {
    func initialize() {
        backgroundColor = .clear
        
        let actions = [MusicSource.spotify, .appleMusic, .radio]
            .map { source in
                let button = makeButton(source: source)
                buttonsStack.addArrangedSubview(button)
                return button.rx.tap.asSignal().map { _ in source }
            }
        
        Signal.merge(actions)
            .emit(to: Binder(self) {
                $0.delegate?.didSelectSource($1)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make constraints
private extension NavigatorMusicEmptyView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            buttonsStack.topAnchor.constraint(equalTo: containerView.topAnchor),
            buttonsStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            buttonsStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: buttonsStack.bottomAnchor, constant: 12.landscapeVScale),
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension NavigatorMusicEmptyView {
    private func makeContainer() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        addSubview(view)
        return view
    }
    
    private func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.Inter.medium(size: 18.landscapeVScale))
            .textColor(Appearance.color_FFFFFF)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "MiniPlayer.Empty".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    private func makeButtonsStack() -> UIStackView {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 20.landscapeHScale
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    private func makeButton(source: MusicSource) -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: source.iconName), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 56.landscapeVScale).isActive = true
        view.widthAnchor.constraint(equalToConstant: 56.landscapeVScale).isActive = true
        return view
    }
}
