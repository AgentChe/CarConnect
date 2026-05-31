//
//  AppleMusicMainViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 12.03.2026.
//

import Foundation
import MusicKit
import Combine

nonisolated struct AppleMusicMainDataSource {
    let section: AppleMusicLibrarySection
    let items: [AppleMusicLibraryItem]
}

final class AppleMusicMainViewModel {
    @MainActor private(set) var dataSource: [AppleMusicMainDataSource] = []
    @MainActor private(set) var isLoading: Bool = false
    @MainActor private(set) var isSearching: Bool = false
    @MainActor var onUpdate: (() -> Void)?

    @MainActor private var searchElements: [AppleMusicCollectionType] = []
    @MainActor private var recentElements: [AppleMusicCollectionType] = []

    private let pageSize: Int = 10
    private let recentlyPlayedLimit: Int = 50
    private var cancellable: AnyCancellable?

    let categoriesSection = AppleMusicMainDataSource(
        section: .library,
        items: AppleMusicLibraryCategory.allCases.map { .category($0) }
    )

    private let (stateStream, stateContinuation) = AsyncStream<Mode>.makeStream()
    private let (nextStream, nextContinuation) = AsyncStream<Void>.makeStream()
    private var currentTask: Task<Void, Never>?
    private var stateTask: Task<Void, Never>?

    private let appleMusicService = AppleMusicService()
    private var currentSearchText = ""

    deinit {
        
    }
}

// MARK: - Public

extension AppleMusicMainViewModel {
    
    func invalidate() {
        stateContinuation.finish()
        nextContinuation.finish()
        currentTask?.cancel()
        stateTask?.cancel()
        cancellable?.cancel()
    }

    func loadInitial() {
        currentTask = Task { await self.main() }
        stateTask = Task { await self.listenForModeChanges() }
        observePlayingTrack()
    }

    func loadNextPage() {
        nextContinuation.yield(())
    }

    func search(term: String, isEditing: Bool) {
        let isActive = isEditing || !term.isEmpty

        if isActive {
            Task { @MainActor in isSearching = true }
            guard term != currentSearchText else { return }
            currentSearchText = term
            Task { @MainActor in onUpdate?() }
            stateContinuation.yield(.search(term))
        } else {
            currentSearchText = ""
            Task { @MainActor in
                isSearching = false
                onUpdate?()
            }
            stateContinuation.yield(.main)
        }
    }
}

// MARK: - Private

private extension AppleMusicMainViewModel {

    enum Mode {
        case search(String)
        case main
    }

    // MARK: Observation

    func observePlayingTrack() {
        cancellable = AppleMusicPlayer.shared.trackPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self, self.isSearching else { return }

                let updated = self.searchElements.map { element -> AppleMusicCollectionType in
                    guard case let .track(track, _) = element else { return element }
                    return .track(track, isPlaying: AppleMusicPlayer.shared.isPlaying(track: track))
                }

                let section = AppleMusicMainDataSource(
                    section: .searchResult,
                    items: updated.map { .searchResult(item: $0) }
                )
                self.dataSource = [section]
                self.onUpdate?()
            }
    }

    // MARK: Mode switching

    func listenForModeChanges() async {
        for await mode in stateStream {
            currentTask?.cancel()
            currentTask = Task { [weak self] in
                guard let self else { return }
                switch mode {
                case .search(let term) where term.count >= 3:
                    await self.performSearch(term: term)
                case .main:
                    await self.main()
                default:
                    break
                }
            }
        }
    }

    // MARK: Search

    func performSearch(term: String) async {
        do {
            try Task.checkCancellation()
            await setLoading(true)

            let results = try await appleMusicService.search(term: term, limit: pageSize)
            var topResults = results.topResults
            var elements = topResults.compactMap(AppleMusicCollectionType.init(topResult:))

            try Task.checkCancellation()
            await updateSearchResults(elements)

            for await _ in nextStream {
                try Task.checkCancellation()
                guard topResults.hasNextBatch else { return }

                guard let next = try await topResults.nextBatch(limit: pageSize) else { return }
                elements = elements.merge(new: next.compactMap(AppleMusicCollectionType.init(topResult:)))

                try Task.checkCancellation()

                await MainActor.run {
                    topResults = next
                }
                await updateSearchResults(elements)
            }
        } catch {}
    }

    @MainActor
    func updateSearchResults(_ elements: [AppleMusicCollectionType]) {
        searchElements = elements
        dataSource = [AppleMusicMainDataSource(
            section: .searchResult,
            items: elements.map { .searchResult(item: $0) }
        )]
        isLoading = false
        onUpdate?()
    }

    // MARK: Recently Played

    func main() async {
        let existing = await MainActor.run { recentElements }

        if !existing.isEmpty {
            await showRecentlyPlayed(existing)
            return
        }

        var offset = 0
        var hasMore = true

        do {
            await setLoading(true)

            let items = try await appleMusicService.fetchRecentlyPlayed(limit: pageSize, offset: offset)
            (offset, hasMore) = try await appendRecentlyPlayed(items, offset: offset)
            await setLoading(false)

            for await _ in nextStream {
                try Task.checkCancellation()
                guard hasMore else { return }

                let items = try await appleMusicService.fetchRecentlyPlayed(limit: pageSize, offset: offset)
                (offset, hasMore) = try await appendRecentlyPlayed(items, offset: offset)
            }
        } catch {}
    }

    /// Appends new items to `recentElements`, updates data source, returns new offset and hasMore flag.
    @discardableResult
    func appendRecentlyPlayed(
        _ items: [AppleMusicCollectionType],
        offset: Int
    ) async throws -> (newOffset: Int, hasMore: Bool) {
        let newOffset = offset + pageSize
        let hasMore = items.count >= pageSize && newOffset < recentlyPlayedLimit

        try Task.checkCancellation()

        let existing = await MainActor.run { recentElements }
        let merged = existing.merge(new: items)
        await showRecentlyPlayed(merged)

        return (newOffset, hasMore)
    }

    @MainActor
    func showRecentlyPlayed(_ items: [AppleMusicCollectionType]) {
        recentElements = items
        dataSource = [
            AppleMusicMainDataSource(
                section: .recently,
                items: items.map { .recent(item: $0) }
            ),
            categoriesSection
        ]
        onUpdate?()
    }

    // MARK: Helpers

    func setLoading(_ value: Bool) async {
        await MainActor.run {
            isLoading = value
            onUpdate?()
        }
    }
}

// MARK: - AppleMusicCollectionType + MusicCatalogSearchResponse

private extension AppleMusicCollectionType {
    init?(topResult: MusicCatalogSearchResponse.TopResult) {
        switch topResult {
        case .album(let album):
            self = .album(album)
        case .artist(let artist):
            self = .artist(artist)
        case .song(let song):
            let track = Track.song(song)
            self = .track(track, isPlaying: AppleMusicPlayer.shared.isPlaying(track: track))
        case .musicVideo(let musicVideo):
            let track = Track.musicVideo(musicVideo)
            self = .track(track, isPlaying: AppleMusicPlayer.shared.isPlaying(track: track))
        default:
            return nil
        }
    }
}
