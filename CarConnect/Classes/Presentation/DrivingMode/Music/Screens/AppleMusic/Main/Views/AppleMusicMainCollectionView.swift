//
//  AppleMusicMainCollectionView.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 25.03.2026.
//

import UIKit

protocol AppleMusicMainCollectionViewDelegate: AnyObject {
    func didSelectRecentItem(_ item: AppleMusicLibraryItem)
    func loadNext()
}

final class AppleMusicMainCollectionView: UIView {
    private typealias Section = AppleMusicLibrarySection
    private typealias Item = AppleMusicLibraryItem
    
    weak var delegate: AppleMusicMainCollectionViewDelegate?
    
    private lazy var collectionView = makeCollectionView()
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Item> = {
        let dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            
            switch item {
            case let .recent(item):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppleMusicMainItemCell.reuseID, for: indexPath) as? AppleMusicMainItemCell
                let model = AppleMusicLibraryRecentItem(collection: item)
                cell?.setup(item: model)
                return cell
            case let .category(category):
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppleMusicMainCategoryItemCell.reuseID, for: indexPath) as? AppleMusicMainCategoryItemCell
                cell?.setup(category: category)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: AppleMusicMainSectionHeaderView.reuseID,
                for: indexPath
            ) as? AppleMusicMainSectionHeaderView
            
            guard let section = Section(rawValue: indexPath.section) else { return nil }
            
            header?.setup(section)
            return header
        }
        return dataSource
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AppleMusicMainCollectionView {
    func apply(recentItems: [CollectionType], categories: [AppleMusicLibraryCategory]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        let recenty: [Item] = recentItems.map { .recent(item: $0) }
        let library: [Item] = categories.map { .category($0) }
        
        snapshot.appendItems(recenty, toSection: .recently)
        snapshot.appendItems(library, toSection: .library)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: Private
private extension AppleMusicMainCollectionView {
    func initialize() {
        backgroundColor = .clear
    }
}

// MARK: Lazy initialization
private extension AppleMusicMainCollectionView {
    func makeCollectionView() -> UICollectionView {
        let view = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Make constraints
private extension AppleMusicMainCollectionView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

private extension AppleMusicMainCollectionView {
    func setupCollectionView() {
        collectionView.register(AppleMusicMainItemCell.self, forCellWithReuseIdentifier: AppleMusicMainItemCell.reuseID)
        collectionView.register(AppleMusicMainCategoryItemCell.self, forCellWithReuseIdentifier: AppleMusicMainCategoryItemCell.reuseID)
        collectionView.register(
            AppleMusicMainSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: AppleMusicMainSectionHeaderView.reuseID
        )
    }
}
// MARK: Layout
private extension AppleMusicMainCollectionView {
    func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] index, _ in
            guard let self, let section = Section(rawValue: index) else { return nil }
        
            switch section {
            case .recently:
                return makeRecentSection()
            case .library:
                return makeGridSection()
            }
        }
    }
    
    func makeRecentSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(100.landscapeHScale),
            heightDimension: .estimated(150.landscapeVScale)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(100.landscapeHScale),
            heightDimension: .estimated(150.landscapeVScale)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 12.landscapeHScale
        section.contentInsets = .init(top: 16.landscapeVScale, leading: 0, bottom: 12.landscapeVScale, trailing: 0)
        
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, _, _ in
            guard let dataSource = self?.dataSource else { return }
            let total = dataSource.snapshot().itemIdentifiers(inSection: .recently).count
            if let last = visibleItems.last, last.indexPath.item >= total - 5 {
                self?.delegate?.loadNext()
            }
        }
        
        section.boundarySupplementaryItems = [makeHeader()]
        return section
    }
    
    func makeGridSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension:  .fractionalWidth(0.5),
            heightDimension: .estimated(50.landscapeVScale)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension:  .fractionalWidth(1.0),
            heightDimension: .estimated(50.landscapeVScale)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item, item]
        )
        group.interItemSpacing = .fixed(12.landscapeHScale)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12.landscapeHScale
        section.contentInsets = .init(top: 16.landscapeVScale, leading: 0, bottom: 12.landscapeVScale, trailing: 0)
        section.boundarySupplementaryItems = [makeHeader()]
        return section
    }

    private func makeHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let size = NSCollectionLayoutSize(
            widthDimension:  .fractionalWidth(1.0),
            heightDimension: .estimated(34.landscapeVScale)
        )
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: size,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
}

extension AppleMusicMainCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        delegate?.didSelectRecentItem(item)
    }
}
