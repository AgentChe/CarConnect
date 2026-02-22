//
//  WidgetsHelperScrollAcceptButton.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 21.02.2026.
//

import UIKit

final class WidgetsHelperScrollAcceptButton: UIButton {
    var didTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension WidgetsHelperScrollAcceptButton {
    func initialize() {
        backgroundColor = Appearance.color_4178F6
        layer.cornerRadius = 10.scale
        
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.medium(size: 16.scale))
        setAttributedTitle("WidgetsHelper.AcceptButton".localized.attributed(with: attrs), for: .normal)
        
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    @objc
    func tapped() {
        didTap?()
    }
}
