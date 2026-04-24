//
//  AppleMusicTrackListView.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 31.03.2026.
//

import UIKit
import MusicKit

protocol AppleMusicTrackListTableDelegate: AnyObject {
    @MainActor func didSelectItem(_ item: Track)
    func visiblePath(indexPath: IndexPath)
}

final class AppleMusicTrackListView: UIView {
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, TrackItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, TrackItem>
    
    lazy var navigationView = makeNavigationView()
    private lazy var loaderView = makeLoaderView()
    private lazy var collectionView = makeCollectionView()
    private lazy var emptyView = makeEmptyView()
    
    weak var delgate: AppleMusicTrackListTableDelegate?
    
    private lazy var dataSource: DataSource = {
        return DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppleMusicCollectionCell.resuseID, for: indexPath) as? AppleMusicCollectionCell
            cell?.setup(track: item.track, isPlaying: item.isPlaying)
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

// MARK: Public
extension AppleMusicTrackListView {
    func updateData(items: [TrackItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
        emptyView.setup(for: .songs)
    }
    
    func setLoadingState(isLoading: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.collectionView.isHidden = isLoading
            if isLoading {
                self.loaderView.startSpinningAnimation()
            } else {
                self.loaderView.stopSpinningAnimation()
            }
        }
    }
}

// MARK: Private
private extension AppleMusicTrackListView {
    func initialize() {
        backgroundColor = Appearance.color_080A0C
    }
}

// MARK: Make constraints
private extension AppleMusicTrackListView {
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
            emptyView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
        ])
    }
}

// MARK: Lazy initialization
private extension AppleMusicTrackListView {
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

extension AppleMusicTrackListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        delgate?.didSelectItem(item.track)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delgate?.visiblePath(indexPath: indexPath)
    }
}

private extension TextAttributes {
    static let title = TextAttributes()
        .font(Fonts.Inter.bold(size: 24.landscapeVScale))
        .textAlignment(.center)
        .textColor(Appearance.color_FFFFFF)
}
