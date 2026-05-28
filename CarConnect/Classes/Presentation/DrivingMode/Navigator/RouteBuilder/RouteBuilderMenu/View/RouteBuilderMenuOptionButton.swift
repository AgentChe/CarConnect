//
//  RouteBuilderMenuOptionButton.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.05.2026.
//

import UIKit

final class RouteBuilderMenuOptionButton: UIButton {
    lazy var label = makeLabel()
    lazy var separator = makeSeparator()
    
    private let title: String
    private let separatorHidden: Bool
    
    init(title: String, separatorHidden: Bool) {
        self.title = title
        self.separatorHidden = separatorHidden
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension RouteBuilderMenuOptionButton {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension RouteBuilderMenuOptionButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.landscapeHScale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.landscapeHScale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16.landscapeVScale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.landscapeVScale)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.landscapeVScale)
        ])
    }
}

// MARK: Lazy initialization
private extension RouteBuilderMenuOptionButton {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.medium(size: 18.landscapeHScale))
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = title.attributed(with: attrs)
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.isHidden = separatorHidden
        view.backgroundColor = Appearance.color_FFFFFF.withAlphaComponent(0.04)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
