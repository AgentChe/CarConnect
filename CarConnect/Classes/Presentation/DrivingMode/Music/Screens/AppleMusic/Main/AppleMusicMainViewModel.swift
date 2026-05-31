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
    private var cancellable: AnyCancellable?
    
    let categoriesSection = AppleMusicMainDataSource(
        section: .library,
        items: AppleMusicLibraryCategory.allCases.map { .category($0) }
    )
    
    private let (stateStream, stateContinuation) = AsyncStream<State>.makeStream()
    private let (nextStream, nextContinuation) = AsyncStream<Void>.makeStream()
    private var currentTask: Task<Void, Never>?
    
    private let appleMusicService = AppleMusicService()
    
    private var currentSearchText = ""
    
    deinit {
        stateContinuation.finish()
        nextContinuation.finish()
        cancellable?.cancel()
    }
}

// MARK: Public
extension AppleMusicMainViewModel {
    
    func loadInitial() {
        Task { await main() }
        Task { await start() }
        observePlayingTrack()
    }
    
    func loadNextPage() {
        nextContinuation.yield(())
    }
    
    func search(term: String, isEditing: Bool) {
        if isEditing || !term.isEmpty {
            isSearching = true
            guard term != currentSearchText else { return }
            currentSearchText = term
            onUpdate?()
            stateContinuation.yield(.search(term))
        } else {
            stateContinuation.yield(.main)
            currentSearchText = ""
            isSearching = false
            onUpdate?()
        }
    }
}

// MARK: Private
private extension AppleMusicMainViewModel {
    enum State {
        case search(String)
        case main
    }
    
    func observePlayingTrack() {
        cancellable = AppleMusicPlayer.shared.trackPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self, isSearching else { return }
                let items = searchElements.map { element in
                    guard case let .track(track, _) = element else { return element }
                    
                    return .track(track, isPlaying: AppleMusicPlayer.shared.isPlaying(track: track))
                }
                
                let section = AppleMusicMainDataSource(
                    section: .searchResult,
                    items: items.map { .searchResult(item: $0) }
                )
                dataSource = [section]
                onUpdate?()
            }
    }
    
    func search(term: String) async {
        do {
            guard term.count >= 0 else {
                await MainActor.run {
                    searchElements = []
                    dataSource = []
                    onUpdate?()
                }
                return
            }
            try Task.checkCancellation()
            await MainActor.run {
                isLoading = true
                onUpdate?()
            }
            
            let results = try await appleMusicService.search(term: term, limit: pageSize)
            var topResults = results.topResults
            
            let elements = topResults.compactMap(AppleMusicCollectionType.init(topResult:))
            let section = AppleMusicMainDataSource(section: .searchResult, items: elements.map { .searchResult(item: $0) })
            
            try Task.checkCancellation()
            
            await MainActor.run {
                searchElements = elements
                dataSource = [section]
                isLoading = false
                onUpdate?()
            }
            
            var isLoadingProgress = false
            
            for await _ in nextStream {
                try Task.checkCancellation()
                
                guard !isLoadingProgress, topResults.hasNextBatch else { return }
                isLoadingProgress = true
                guard let next = try await topResults.nextBatch(limit: pageSize) else { return }
                let elements = searchElements.merge(new: next.compactMap(AppleMusicCollectionType.init(topResult:)))
                
                let section = AppleMusicMainDataSource(section: .searchResult, items: elements.map { .searchResult(item: $0) })
                
                try Task.checkCancellation()
                
                await MainActor.run {
                    searchElements = elements
                    topResults = next
                    dataSource = [section]
                    onUpdate?()
                }
                
                isLoadingProgress = false
            }
        } catch {
            
        }
    }
    
    func main() async {
        guard recentElements.isEmpty else {
            let recentlySection = AppleMusicMainDataSource(
                section: .recently,
                items: recentElements.map { .recent(item: $0) }
            )
            
            await MainActor.run {
                dataSource = [recentlySection, categoriesSection]
                onUpdate?()
            }
            
            return
        }
        
        var offset = 0
        var isLoadingProgress = false
        var hasMore = true
        
        do {
            
            await MainActor.run {
                isLoading = true
                onUpdate?()
            }
            
            let items = try await appleMusicService.fetchRecentlyPlayed(limit: pageSize, offset: offset)
            try await mainSetup(items: items, offset: &offset, hasMore: &hasMore)
            
            await MainActor.run {
                isLoading = false
                onUpdate?()
            }
            
            for await _ in nextStream {
                try Task.checkCancellation()
                
                guard !isLoadingProgress, hasMore else { return }
                
                isLoadingProgress = true
                
                let items = try await appleMusicService.fetchRecentlyPlayed(limit: pageSize, offset: offset)
                try await mainSetup(items: items, offset: &offset, hasMore: &hasMore)
                
                isLoadingProgress = false
            }
        } catch { }
    }
    
    func mainSetup(items: [AppleMusicCollectionType], offset: inout Int, hasMore: inout Bool) async throws {
        offset += pageSize
        hasMore = items.count >= pageSize && offset < 50
        
        let newItems = recentElements.merge(new: items)
        
        let recentlySection = AppleMusicMainDataSource(
            section: .recently,
            items: newItems.map { .recent(item: $0) }
        )
        
        try Task.checkCancellation()
        
        await MainActor.run {
            recentElements = newItems
            dataSource = [recentlySection, categoriesSection]
            
            onUpdate?()
        }
    }
    
    func start() async {
        for await state in stateStream {
            currentTask?.cancel()
            
            currentTask = Task { [weak self] in
                guard let self else { return }
                switch state {
                case .search(let term):
                    guard term.count >= 3 else { return }
                    await search(term: term)
                case .main:
                    await main()
                }
            }
        }
    }
}

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
