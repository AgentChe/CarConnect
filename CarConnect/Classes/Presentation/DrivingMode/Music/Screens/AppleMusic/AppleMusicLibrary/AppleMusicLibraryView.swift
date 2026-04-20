//
//  AppleMusicLibraryView.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 28.03.2026.
//

import UIKit

protocol AppleMusicLibraryTableDelegate: AnyObject {
    @MainActor func didSelectItem(_ item: CollectionType)
    func visiblePath(indexPath: IndexPath)
}

final class AppleMusicLibraryView: UIView {
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, CollectionType>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, CollectionType>
    
    lazy var navigationView = makeNavigationView()
    private lazy var tableView = makeTableView()
    private lazy var emptyView = makeEmptyView()
    private lazy var footerSpinner = makeFooterSpinner()
    private lazy var loaderSpinner = makeLoadingSpinner()
    
    weak var delgate: AppleMusicLibraryTableDelegate?
    
    private lazy var dataSource: DataSource = {
        return DataSource(collectionView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withReuseIdentifier: AppleMusicCollectionCell.resuseID, for: indexPath) as? AppleMusicCollectionCell
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
    func updateData(items: [CollectionType], category: AppleMusicLibraryCategory) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
        emptyView.setup(for: category)
    }
    
    func updateLoadingState(isLoading: Bool, isEmpty: Bool) {
        if isEmpty && isLoading {
            loaderSpinner.startAnimating()
            // TODO: Добавить спиннер
//            tableView.tableFooterView = nil
            emptyView.isHidden = true
        } else if !isEmpty && isLoading {
            loaderSpinner.stopAnimating()
            footerSpinner.startAnimating()
            // TODO: Добавить спиннер
//            tableView.tableFooterView = footerSpinner
            emptyView.isHidden = true
        } else if isEmpty {
            tableView.isHidden = true
            emptyView.isHidden = false
        } else {
            tableView.isHidden = false
            emptyView.isHidden = true
            loaderSpinner.stopAnimating()
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
            tableView.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loaderSpinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            loaderSpinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension AppleMusicLibraryView {
    func makeTableView() -> UICollectionView {
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
    
    func makeFooterSpinner() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .medium)
        view.frame = .init(origin: .zero, size: .init(width: tableView.bounds.width, height: 52))
        return view
    }
    
    func makeLoadingSpinner() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .medium)
        view.hidesWhenStopped = true
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
