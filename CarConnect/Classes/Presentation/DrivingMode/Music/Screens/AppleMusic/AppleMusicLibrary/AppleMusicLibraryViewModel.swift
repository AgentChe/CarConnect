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
    
    @MainActor private(set) var items: [CollectionType] = []
    @MainActor private(set) var isLoading = false
    @MainActor private(set) var error: Error?
    
    @MainActor  var onUpdate: (() -> Void)?
    
//    private let appleMusicService = AppleMusicService()
    private let appleMusicService = AppleMusicCollectionService()
    
    let category: AppleMusicLibraryCategory
    
    private let limit = 10
    private var offset: Int = 0
    private var hasMore = true
    private var isLoadingInProgress = false
    
    init(category: AppleMusicLibraryCategory) {
        self.category = category
    }
    
    func loadInitialData() async {
        await load(reset: true)
    }

    func loadNextPage() async {
        await load(reset: false)
    }

    func refresh() async {
        await load(reset: true)
    }

    // MARK: - Private

    private func load(reset: Bool) async {
        guard !isLoadingInProgress, hasMore else { return }
        isLoadingInProgress = true

        if reset {
            offset = 0
            hasMore = true
            await MainActor.run {
                items = []
                onUpdate?()
            }
        }

        await MainActor.run {
            isLoading = true
            onUpdate?()
        }

        do {
            let elements = try await appleMusicService.fetchLibraryContent(
                category: category,
                limit: limit,
                offset: offset
            )
        
            await MainActor.run {
                offset += limit
                hasMore = elements.count == limit
                items += elements
                isLoading = false
                onUpdate?()
            }
        } catch {
            await MainActor.run {
                self.error = error
                isLoading = false
                onUpdate?()
            }
        }

        isLoadingInProgress = false
    }
}
