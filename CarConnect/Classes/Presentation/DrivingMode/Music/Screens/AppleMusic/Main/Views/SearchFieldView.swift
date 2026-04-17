//
//  SearchFieldView.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 17.04.2026.
//

import UIKit

final class SearchFieldView: UITextField {
    private let iconImageView = UIImageView()
    private let rightButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let iconSize: CGFloat = 24.landscapeVScale
        let leftMargin: CGFloat = 10.landscapeHScale
        
        return CGRect(
            x: leftMargin,
            y: (bounds.height - iconSize) / 2,
            width: iconSize,
            height: iconSize
        )
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let iconSize: CGFloat = 24.landscapeVScale
        let rightMargin: CGFloat = 8.landscapeHScale
        
        return CGRect(
            x: bounds.width - iconSize - rightMargin,
            y: (bounds.height - iconSize) / 2,
            width: iconSize,
            height: iconSize
        )
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let leftViewRect = self.leftViewRect(forBounds: bounds)
        let rightViewRect = self.rightViewRect(forBounds: bounds)
        
        let leftInset = leftViewRect.maxX + 10.landscapeHScale
        let rightInset = bounds.width - rightViewRect.minX + 10.landscapeHScale
        
        return CGRect(
            x: leftInset,
            y: 0,
            width: bounds.width - leftInset - rightInset,
            height: bounds.height
        )
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return editingRect(forBounds: bounds)
    }
}

private extension SearchFieldView {
    func initialize() {
        let attrs = TextAttributes()
            .font(Fonts.Inter.medium(size: 16.landscapeVScale))
            .textColor(Appearance.color_FFFFFF.withAlphaComponent(0.6))
            .textAlignment(.left)
        tintColor = Appearance.color_FFFFFF.withAlphaComponent(0.6)
        textColor = Appearance.color_FFFFFF
        attributedPlaceholder = "Поиск...".attributed(with: attrs)
        layer.cornerRadius = 10.landscapeVScale
        backgroundColor = Appearance.color_FFFFFF.withAlphaComponent(0.1)
        
        setupLeftView()
        setupRightView()
    }
    
    func setupRightView() {
        rightButton.setImage(UIImage(systemName: "multiply.circle.fill"), for: .normal)
        let size = 24.landscapeVScale
        rightButton.frame = .init(origin: .zero, size: .init(width: size, height: size))
        rightView = rightButton
        rightViewMode = .whileEditing
    }
    
    func setupLeftView() {
        iconImageView.contentMode = .scaleAspectFit
        let size = 24.landscapeVScale
        iconImageView.frame = .init(origin: .zero, size: .init(width: size, height: size))
        iconImageView.image = UIImage(systemName: "magnifyingglass")
        leftView = iconImageView
        leftViewMode = .always
    }
}
