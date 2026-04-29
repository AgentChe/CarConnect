//
//  AppleMusicLibraryViewModel.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 28.03.2026.
//

import Foundation
import MusicKit

final class AppleMusicLibraryViewModel {
    typealias ContentType = MusicItem
    
    let category: AppleMusicLibraryCategory
    @MainActor private(set) var items: [AppleMusicCollectionType] = []
    @MainActor private(set) var isLoading = false
    @MainActor private(set) var error: Error?
    
    @MainActor  var onUpdate: (() -> Void)?
    
    private let appleMusicService = AppleMusicService()
    
    private let (nextStream, nextContinuation) = AsyncStream<Void>.makeStream()
    
    init(category: AppleMusicLibraryCategory) {
        self.category = category
    }
    
    deinit {
        nextContinuation.finish()
    }
    
    func loadInitialData() async {
        do {
            try await start()
        } catch {
            await MainActor.run {
                onUpdate?()
            }
        }
    }

    func loadNextPage() async {
        nextContinuation.yield()
    }

    private func start() async throws {
        let limit = 10
        var offset = 0
        var hasMore = true
        var isPaginationLoading = false
        
        await MainActor.run {
            isLoading = true
            onUpdate?()
        }
        
        let elements = try await appleMusicService.fetchLibraryContent(
            category: category,
            limit: limit,
            offset: offset
        )
        
        await MainActor.run {
            offset += limit
            hasMore = elements.count == limit
            items = elements
            isLoading = false
            onUpdate?()
        }
    
        for await _ in nextStream {
            guard !isPaginationLoading else { continue }
            guard hasMore else { return }
            
            isPaginationLoading = true
            let elements = try await appleMusicService.fetchLibraryContent(
                category: category,
                limit: limit,
                offset: offset
            )
            
            let newItems = items.merge(new: elements)
        
            await MainActor.run {
                offset += limit
                hasMore = elements.count == limit
                items = newItems
                isPaginationLoading = false
                onUpdate?()
            }
        }
    }
}
