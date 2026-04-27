//
//  AppleMusicLibraryView.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 28.03.2026.
//

import UIKit

protocol AppleMusicLibraryTableDelegate: AnyObject {
    @MainActor func didSelectItem(_ item: AppleMusicCollectionType)
    func visiblePath(indexPath: IndexPath)
}

final class AppleMusicLibraryView: UIView {
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, AppleMusicCollectionType>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, AppleMusicCollectionType>
    
    lazy var navigationView = makeNavigationView()
    private lazy var collectionView = makeCollectionView()
    private lazy var emptyView = makeEmptyView()
    private lazy var loaderView = makeLoaderView()
    
    weak var delgate: AppleMusicLibraryTableDelegate?
    
    private lazy var dataSource: DataSource = {
        return DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppleMusicCollectionCell.resuseID, for: indexPath) as? AppleMusicCollectionCell
            cell?.setup(for: item)
            return cell
        }
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AppleMusicLibraryView {
    func updateData(items: [AppleMusicCollectionType], category: AppleMusicLibraryCategory) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
        emptyView.setup(for: category)
    }
    
    func updateState(isLoading: Bool, isEmpty: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.collectionView.isHidden = isLoading || isEmpty
            self.emptyView.isHidden = isLoading || !isEmpty
            
            if isLoading {
                self.loaderView.startSpinningAnimation()
            } else  {
                self.loaderView.stopSpinningAnimation()
            }
        }
    }

}

// MARK: Private
private extension AppleMusicLibraryView {
    func initialize() {
        backgroundColor = Appearance.color_080A0C
    }
}

// MARK: Make constraints
private extension AppleMusicLibraryView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: topAnchor),
            navigationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension AppleMusicLibraryView {
    func makeCollectionView() -> UICollectionView {
        let view = UICollectionView.makeList()
        
        view.register(AppleMusicCollectionCell.self, forCellWithReuseIdentifier: AppleMusicCollectionCell.resuseID)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.delegate = self
        addSubview(view)
        return view
    }
    
    func makeEmptyView() -> AppleMusicLibraryEmptyView {
        let view = AppleMusicLibraryEmptyView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNavigationView() -> NavigationView {
        let view = NavigationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    
    func makeLoaderView() -> AppleMusicLoaderView {
        let view = AppleMusicLoaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

extension AppleMusicLibraryView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        delgate?.didSelectItem(item)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delgate?.visiblePath(indexPath: indexPath)
    }
}
