//
//  SignalBarsView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 12.03.2026.
//

import UIKit

final class SignalBarsView: UIView {
    lazy var bar1View = makeBarView()
    lazy var bar2View = makeBarView()
    lazy var bar3View = makeBarView()
    lazy var bar4View = makeBarView()
    
    private lazy var barViews = [
        bar1View, bar2View, bar3View, bar4View
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
extension SignalBarsView {
    func update(strength: Int) {
        let clampedStrength = max(0, min(4, strength))
        
        for (index, view) in barViews.enumerated() {
            let isActive = index < clampedStrength
            view.backgroundColor = isActive ? .white : UIColor.white.withAlphaComponent(0.3)
        }
    }
}

// MARK: Private
private extension SignalBarsView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension SignalBarsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            bar1View.leadingAnchor.constraint(equalTo: leadingAnchor),
            bar1View.bottomAnchor.constraint(equalTo: bottomAnchor),
            bar1View.heightAnchor.constraint(equalToConstant: 5.landscapeHScale),
            bar1View.widthAnchor.constraint(equalToConstant: 3.landscapeHScale)
        ])
        
        NSLayoutConstraint.activate([
            bar2View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5.landscapeHScale),
            bar2View.bottomAnchor.constraint(equalTo: bottomAnchor),
            bar2View.heightAnchor.constraint(equalToConstant: 8.landscapeHScale),
            bar2View.widthAnchor.constraint(equalToConstant: 3.landscapeHScale)
        ])
        
        NSLayoutConstraint.activate([
            bar3View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11.landscapeHScale),
            bar3View.bottomAnchor.constraint(equalTo: bottomAnchor),
            bar3View.heightAnchor.constraint(equalToConstant: 11.landscapeHScale),
            bar3View.widthAnchor.constraint(equalToConstant: 3.landscapeHScale)
        ])
        
        NSLayoutConstraint.activate([
            bar4View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.landscapeHScale),
            bar4View.trailingAnchor.constraint(equalTo: trailingAnchor),
            bar4View.bottomAnchor.constraint(equalTo: bottomAnchor),
            bar4View.topAnchor.constraint(equalTo: topAnchor),
            bar4View.heightAnchor.constraint(equalToConstant: 14.landscapeHScale),
            bar4View.widthAnchor.constraint(equalToConstant: 3.landscapeHScale)
        ])
    }
}

// MARK: Lazy initialization
private extension SignalBarsView {
    func makeBarView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 1.landscapeHScale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
