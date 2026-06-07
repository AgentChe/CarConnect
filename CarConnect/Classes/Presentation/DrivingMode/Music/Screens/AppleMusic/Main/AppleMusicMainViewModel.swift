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

    private var stateContinuation: AsyncStream<Mode>.Continuation?
    private var nextContinuation: AsyncStream<Void>.Continuation?

    private var currentTask: Task<Void, Never>?
    private var stateTask: Task<Void, Never>?

    private let appleMusicService = AppleMusicService()
    private var currentSearchText = ""

    deinit {
        teardown()
    }
}

// MARK: - Public

extension AppleMusicMainViewModel {

    func loadInitial() {
        let (stateStream, stateCont) = AsyncStream<Mode>.makeStream()
        stateContinuation = stateCont

        stateTask = Task { [weak self] in
            guard let self else { return }
            await self.listenForModeChanges(stateStream: stateStream)
        }

        stateContinuation?.yield(.main)
        observePlayingTrack()
    }

    func invalidate() {
        teardown()
    }

    func loadNextPage() {
        nextContinuation?.yield(())
    }

    func search(term: String, isEditing: Bool) {
        let isActive = isEditing || !term.isEmpty

        if isActive {
            Task { @MainActor in self.isSearching = true }
            guard term != currentSearchText else { return }
            currentSearchText = term
            Task { @MainActor in self.onUpdate?() }
            stateContinuation?.yield(.search(term))
        } else {
            currentSearchText = ""
            Task { @MainActor in
                self.isSearching = false
                self.onUpdate?()
            }
            stateContinuation?.yield(.main)
        }
    }
}

// MARK: - Private

private extension AppleMusicMainViewModel {

    enum Mode {
        case search(String)
        case main
    }

    func teardown() {
        stateContinuation?.finish()
        nextContinuation?.finish()
        stateContinuation = nil
        nextContinuation = nil
        currentTask?.cancel()
        stateTask?.cancel()
        currentTask = nil
        stateTask = nil
        cancellable?.cancel()
    }

    func makeNextStream() -> AsyncStream<Void> {
        nextContinuation?.finish()
        let (stream, continuation) = AsyncStream<Void>.makeStream()
        nextContinuation = continuation
        return stream
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

                self.dataSource = [AppleMusicMainDataSource(
                    section: .searchResult,
                    items: updated.map { .searchResult(item: $0) }
                )]
                self.onUpdate?()
            }
    }

    // MARK: Mode switching

    func listenForModeChanges(stateStream: AsyncStream<Mode>) async {
        for await mode in stateStream {
            currentTask?.cancel()
            
            let nextStream = makeNextStream()

            currentTask = Task { [weak self] in
                guard let self else { return }
                switch mode {
                case .search(let term) where term.count >= 3:
                    await self.performSearch(term: term, nextStream: nextStream)
                case .main:
                    await self.main(nextStream: nextStream)
                default:
                    break
                }
            }
        }
    }

    // MARK: Search

    func performSearch(term: String, nextStream: AsyncStream<Void>) async {
        do {
            try Task.checkCancellation()
            await setLoading(true)

            let results = try await appleMusicService.search(term: term, limit: pageSize)
            var topResults = results.topResults
            var elements = topResults.compactMap(AppleMusicCollectionType.init(topResult:))

            try Task.checkCancellation()
            updateSearchResults(elements)

            for await _ in nextStream {
                try Task.checkCancellation()
                guard topResults.hasNextBatch else { continue }
                guard let next = try await topResults.nextBatch(limit: pageSize) else { continue }

                elements = elements.merge(new: next.compactMap(AppleMusicCollectionType.init(topResult:)))
                try Task.checkCancellation()
                topResults = next
                updateSearchResults(elements)
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

    func main(nextStream: AsyncStream<Void>) async {
        if recentElements.isEmpty {
            do {
                await setLoading(true)
                let items = try await appleMusicService.fetchRecentlyPlayed(limit: pageSize, offset: 0)
                try await appendRecentlyPlayed(items, offset: 0)
                await setLoading(false)
            } catch {
                return
            }
        } else {
            showRecentlyPlayed(recentElements)
        }

        var offset = recentElements.count
        var hasMore = offset < recentlyPlayedLimit

        do {
            for await _ in nextStream {
                try Task.checkCancellation()
                guard hasMore else { continue }

                let items = try await appleMusicService.fetchRecentlyPlayed(limit: pageSize, offset: offset)
                try await appendRecentlyPlayed(items, offset: offset)

                offset += pageSize
                hasMore = items.count >= pageSize && offset < recentlyPlayedLimit
            }
        } catch {}
    }

    func appendRecentlyPlayed(
        _ items: [AppleMusicCollectionType],
        offset: Int
    ) async throws {
        try Task.checkCancellation()
        showRecentlyPlayed(recentElements.merge(new: items))
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
