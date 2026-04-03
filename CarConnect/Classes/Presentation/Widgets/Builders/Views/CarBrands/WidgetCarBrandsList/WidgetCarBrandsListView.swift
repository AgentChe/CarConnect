//
//  WidgetCarBrandsListView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 02.04.2026.
//

import UIKit

final class WidgetCarBrandsListView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var closeButton = makeCloseButton()
    lazy var searchField = makeSearchField()
    lazy var tableView = makeTableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension WidgetCarBrandsListView {
    func initialize() {
        backgroundColor = Appearance.color_21232A
    }
}

// MARK: Make constraints
private extension WidgetCarBrandsListView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 18.scale)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            searchField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            searchField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 34.scale),
            searchField.heightAnchor.constraint(equalToConstant: 50.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 2.scale),
            tableView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetCarBrandsListView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(19.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "WidgetsBuilders.CarLogo.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "WidgetsBuilders.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSearchField() -> SelectBrandSearchField {
        let view = SelectBrandSearchField()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> WidgetCarBrandsListTableView {
        let view = WidgetCarBrandsListTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
