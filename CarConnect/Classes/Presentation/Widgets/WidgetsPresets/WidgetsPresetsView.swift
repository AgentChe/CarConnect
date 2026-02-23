//
//  WidgetsPresetsView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.02.2026.
//

import UIKit

final class WidgetsPresetsView: UIView {
    lazy var headerView = makeHeaderView()
    lazy var presetsTypesView = makePresetsTypesView()
    lazy var collectionView = makeCollectionView()
    
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
private extension WidgetsPresetsView {
    func initialize() {
        backgroundColor = Appearance.color_21232A
    }
}

// MARK: Make constraints
private extension WidgetsPresetsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            presetsTypesView.leadingAnchor.constraint(equalTo: leadingAnchor),
            presetsTypesView.trailingAnchor.constraint(equalTo: trailingAnchor),
            presetsTypesView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            presetsTypesView.heightAnchor.constraint(equalToConstant: 59.scale)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            collectionView.topAnchor.constraint(equalTo: presetsTypesView.bottomAnchor, constant: 2.scale),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(TabView.Constants.tabBarHeight + TabView.Constants.tabBarBottomInset))
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPresetsView {
    func makeHeaderView() -> WidgetsPresetsHeaderView {
        let view = WidgetsPresetsHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePresetsTypesView() -> WidgetsPresetsTypesView {
        let view = WidgetsPresetsTypesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCollectionView() -> WidgetsPresetsTemplatesCollectionView {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 165.scale, height: 165.scale)
        layout.minimumLineSpacing = 12.scale
        layout.minimumInteritemSpacing = 10.scale
        
        let view = WidgetsPresetsTemplatesCollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
