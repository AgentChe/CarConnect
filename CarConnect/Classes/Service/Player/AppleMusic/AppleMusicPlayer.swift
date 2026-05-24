//
//  AppleMusicPlayer.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 07.04.2026.
//

import Foundation
import Combine
import MusicKit
import UIKit

// MARK: - Supporting types

enum RepeatMode {
    case none, one, all
}

enum ShuffleMode {
    case off, on
}

/// Метаданные текущего трека — меняется только при смене трека.
struct TrackModel: Equatable {
    let title: String?
    let subtitle: String?
    let artwork: URL?
}

/// Состояние воспроизведения — меняется при паузе/плее и каждые 0.5 с для прогрессбара.
struct PlaybackModel {
    let currentTime: TimeInterval
    let duration: TimeInterval
    let isPlaying: Bool
    let repeatMode: RepeatMode
    let shuffleMode: ShuffleMode
}

// MARK: - AppleMusicPlayer

final class AppleMusicPlayer {

    static let shared = AppleMusicPlayer()

    // MARK: Streams

    /// Публикует метаданные трека. Новый подписчик сразу получает текущее значение.
    let trackPublisher = CurrentValueSubject<TrackModel?, Never>(nil)

    /// Публикует состояние воспроизведения. Новый подписчик сразу получает текущее значение.
    let playbackPublisher = CurrentValueSubject<PlaybackModel?, Never>(nil)
    
    private var cancellable: [AnyCancellable] = []

    // MARK: Computed

    private var player: ApplicationMusicPlayer { ApplicationMusicPlayer.shared }

    var isPlaying: Bool { player.state.playbackStatus == .playing }

    func isPlaying(track: Track) -> Bool {
        guard let item = player.queue.currentEntry?.item else { return false }
        switch item {
        case .song(let song):
            return track.artistName == song.artistName && track.title == song.title && track.albumTitle == song.albumTitle
        case .musicVideo(let musicVideo):
            return track.artistName == musicVideo.artistName && track.title == musicVideo.title && track.albumTitle == musicVideo.albumTitle
        @unknown default:
            return false
        }
        
    }
    // MARK: Init

    private init() {
        setupObserver()
    }

    /// Воспроизвести / поставить на паузу текущий трек.
    func togglePlaybackStatus() {
        if isPlaying {
            player.pause()
        } else {
            Task {
                try? await player.play()
            }
        }
    }
    
    func toggleShuffleMode() {
        let current = ShuffleMode(appleMode: player.state.shuffleMode)
        player.state.shuffleMode = current == .on ? .off : .songs
    }
    
    func toggleRepeatMode() {
        let current = RepeatMode(appleMode: player.state.repeatMode)
        player.state.repeatMode = current == .all ? nil : .all
    }

    /// Воспроизвести трек из коллекции.
    func play(_ track: Track, in trackList: MusicItemCollection<Track>?, with parentCollectionID: MusicItemID?) {
        if let list = trackList {
            setQueue(for: list, startingAt: track)
        } else {
            setQueue(for: [track])
        }
        
        Task {
            try? await player.play()
        }
    }

    /// Перемотать на заданную позицию (секунды).
    func seek(to time: TimeInterval) {
        player.playbackTime = time
        emitPlaybackModel()
    }

    /// Следующий трек.
    func skipToNextEntry() {
        Task {
            try? await player.skipToNextEntry()
        }
    }

    /// Предыдущий трек.
    func skipToPreviousEntry() {
        Task {
            try? await player.skipToPreviousEntry()
        }
    }

    // MARK: - Private helpers

    private func setupObserver() {
        player.state.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.emitPlaybackModel()
            }
            .store(in: &cancellable)
        
        player.queue.objectWillChange
            .receive(on: DispatchQueue.main)
            .map { [weak self] in
                let entry = self?.player.queue.currentEntry

                let title = entry?.title
                let subtitle = entry?.subtitle
                let artworkItem = entry?.item.flatMap { self?.artworkSource(from: $0) }

                return TrackModel(
                    title: title,
                    subtitle: subtitle,
                    artwork: artworkItem?.url(width: 120, height: 120)
                )
                
            }
            .subscribe(trackPublisher)
            .store(in: &cancellable)
        
        Timer.publish(every: 0.25, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self, self.isPlaying else { return }
                self.emitPlaybackModel()
            }
            .store(in: &cancellable)
    }

    private func emitPlaybackModel() {
        let model = PlaybackModel(
            currentTime: player.playbackTime,
            duration: currentDuration(),
            isPlaying: player.state.playbackStatus == .playing,
            repeatMode: .init(appleMode: player.state.repeatMode),
            shuffleMode: .init(appleMode: player.state.shuffleMode)
        )
        
        playbackPublisher.send(model)
    }

    // MARK: - Queue

    private func setQueue<S: Sequence, T: PlayableMusicItem>(
        for items: S,
        startingAt startItem: S.Element? = nil
    ) where S.Element == T {
        player.queue = ApplicationMusicPlayer.Queue(for: items, startingAt: startItem)
    }

    // MARK: - Mapping helpers

    private func currentDuration() -> TimeInterval {
        switch player.queue.currentEntry?.item {
        case .song(let song):
            return song.duration ?? 0
        case .musicVideo(let mv):
            return mv.duration ?? 0
        default:
            return 0
        }
    }
    
    // MARK: - Artwork
    
    private func artworkSource(from item: MusicPlayer.Queue.Entry.Item) -> Artwork? {
        switch item {
        case .song(let song):
            return song.artwork
        case .musicVideo(let mv):
            return mv.artwork
        @unknown default:
            return nil
        }
    }
}


extension ShuffleMode {
    init(appleMode: MusicPlayer.ShuffleMode?) {
        switch appleMode {
        case .off:
            self = .off
        case .songs:
            self = .on
        case .none:
            self = .off
        @unknown default:
            self = .off
        }
    }
}

extension RepeatMode {
    init(appleMode: MusicPlayer.RepeatMode?) {
        guard let appleMode else {
            self = .none
            return
        }
        
        switch appleMode {
        case .none:
            self = .none
        case .one:
            self = .one
        case .all:
            self = .all
        @unknown default:
            self = .none
        }
    }
}
