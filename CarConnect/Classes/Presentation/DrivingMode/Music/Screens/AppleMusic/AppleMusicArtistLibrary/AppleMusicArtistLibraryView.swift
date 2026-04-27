//
//  AppleMusicArtistLibraryView.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 09.04.2026.
//

import UIKit
import MusicKit

protocol AppleMusicArtistLibraryDelegate: AnyObject {
    @MainActor func didSelectItem(_ item: Album)
    func visiblePath(indexPath: IndexPath)
}

final class AppleMusicArtistLibraryView: UIView {
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, Album>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Album>
    
    lazy var navigationView = makeNavigationView()
    private lazy var tableView = makeTableView()
    private lazy var emptyView = makeEmptyView()
    private lazy var footerSpinner = makeFooterSpinner()
    private lazy var loaderSpinner = makeLoadingSpinner()
    
    weak var delgate: AppleMusicArtistLibraryDelegate?
    
    private lazy var dataSource: DataSource = {
        return DataSource(collectionView: tableView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppleMusicCollectionCell.resuseID, for: indexPath) as? AppleMusicCollectionCell
            cell?.setup(album: item)
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

extension AppleMusicArtistLibraryView {
    func updateData(items: [Album]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
        emptyView.setup(for: .albums)
    }
}

// MARK: Private
private extension AppleMusicArtistLibraryView {
    func initialize() {
        backgroundColor = Appearance.color_080A0C
    }
}

// MARK: Make constraints
private extension AppleMusicArtistLibraryView {
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
private extension AppleMusicArtistLibraryView {
    func makeTableView() -> UICollectionView {
        let view = UICollectionView.makeList()
        
        view.register(AppleMusicCollectionCell.self, forCellWithReuseIdentifier: AppleMusicCollectionCell.resuseID)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.delegate = self
        addSubview(view)
        return view
    }
    
    func makeNavigationView() -> NavigationView {
        let view = NavigationView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
}

extension AppleMusicArtistLibraryView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        delgate?.didSelectItem(item)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delgate?.visiblePath(indexPath: indexPath)
    }
}

extension UICollectionView {
    static func makeList() -> UICollectionView {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        var separatorConfig = UIListSeparatorConfiguration(listAppearance: .plain)
        separatorConfig.topSeparatorVisibility = .hidden
        separatorConfig.bottomSeparatorVisibility = .hidden
        config.separatorConfiguration = separatorConfig
        config.backgroundColor = .clear
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }
}
