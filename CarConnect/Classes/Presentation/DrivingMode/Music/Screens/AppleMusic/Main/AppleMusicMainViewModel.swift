//
//  AppleMusicMainViewModel.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 12.03.2026.
//

import MusicKit

final class AppleMusicMainViewModel {
    @MainActor
    private(set) var recentElements: [CollectionType] = []
    
    let libraryItems: [AppleMusicLibraryCategory] = AppleMusicLibraryCategory.allCases
    
    @MainActor var onUpdate: (() -> Void)?
    
    private var offset: Int = 0
    private let pageSize: Int = 10
    private var hasMore: Bool = true
    private var isLoadingInProgress: Bool = false
    
    private let appleMusicService = AppleMusicService()
}

// MARK: Public
extension AppleMusicMainViewModel {
    struct Input {}
    
    struct Output {}
    
    func configure(input: Input) -> Output {
        Output()
    }
    
    func checkAuthorization() async -> Bool {
        await appleMusicService.requestAuthorization()
    }
    
    func loadInitial() {
        Task { await load() }
    }
    
    func loadNextPage() {
        Task { await load() }
    }
}

// MARK: Private
private extension AppleMusicMainViewModel {
    func loadInitialData() async {
        guard await appleMusicService.requestAuthorization() else { return }
        await load()
    }
    
    func load() async {
        guard !isLoadingInProgress, hasMore else { return }
        isLoadingInProgress = true
        
        do {
            let items = try await appleMusicService.fetchRecentlyPlayed(limit: pageSize, offset: offset)
            offset += pageSize
            hasMore = items.count >= pageSize && offset < 50
            // Эпл может вернуть дубли, из-за них крашится DiffableDataSource
            var containsIDs: Set<MusicItemID> = []
            
            let newItems = (recentElements + items)
                .compactMap { item -> CollectionType? in
                    guard !containsIDs.contains(item.id) else { return nil }
                    containsIDs.insert(item.id)
                    return item
                }
            
            await MainActor.run {
                recentElements = newItems
                onUpdate?()
            }
        } catch {
            await MainActor.run {
                onUpdate?()
            }
        }
        isLoadingInProgress = false
    }
}
