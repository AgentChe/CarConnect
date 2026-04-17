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
    private typealias DataSource = UITableViewDiffableDataSource<Int, TrackItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, TrackItem>
    
    private lazy var tableView = makeTableView()
    private lazy var emptyView = makeEmptyView()
    private lazy var footerSpinner = makeFooterSpinner()
    private lazy var loaderSpinner = makeLoadingSpinner()
    
    weak var delgate: AppleMusicTrackListTableDelegate?
    
    private lazy var dataSource: DataSource = {
        return DataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: AppleMusicCollectionCell.resuseID, for: indexPath) as? AppleMusicCollectionCell
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

extension AppleMusicTrackListView {
    func updateData(items: [TrackItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
        emptyView.setup(for: .songs)
    }
}

// MARK: Private
private extension AppleMusicTrackListView {
    func initialize() {
        backgroundColor = .black
    }
}

// MARK: Make constraints
private extension AppleMusicTrackListView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
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
private extension AppleMusicTrackListView {
    func makeTableView() -> UITableView {
        let view = UITableView()
        view.register(AppleMusicCollectionCell.self, forCellReuseIdentifier: AppleMusicCollectionCell.resuseID)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.separatorStyle = .none
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
}

extension AppleMusicTrackListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        delgate?.didSelectItem(item.track)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        delgate?.visiblePath(indexPath: indexPath)
    }
}
