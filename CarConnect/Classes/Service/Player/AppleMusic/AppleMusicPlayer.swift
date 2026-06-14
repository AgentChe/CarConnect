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

final class AppleMusicPlayer: MusicPlayerProtocol {

    static let shared = AppleMusicPlayer()

    let trackPublisher = CurrentValueSubject<TrackModel?, Never>(nil)
    let playbackPublisher = CurrentValueSubject<PlaybackModel?, Never>(nil)

    private var player: ApplicationMusicPlayer { ApplicationMusicPlayer.shared }
    private var cancellables: Set<AnyCancellable> = []

    var isPlaying: Bool { player.state.playbackStatus == .playing }

    func isPlaying(track: Track) -> Bool {
        guard let item = player.queue.currentEntry?.item else { return false }
        switch item {
        case .song(let song):
            return track.artistName == song.artistName
                && track.title == song.title
                && track.albumTitle == song.albumTitle
        case .musicVideo(let mv):
            return track.artistName == mv.artistName
                && track.title == mv.title
                && track.albumTitle == mv.albumTitle
        @unknown default:
            return false
        }
    }

    private init() {
        setupObservers()
    }

    func togglePlaybackStatus() {
        if isPlaying {
            player.pause()
        } else {
            Task { try? await player.play() }
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

    func play(_ track: Track, in trackList: MusicItemCollection<Track>? = nil) {
        if let list = trackList {
            setQueue(for: list, startingAt: track)
        } else {
            setQueue(for: [track])
        }
        Task { try? await player.play() }
    }

    func pause() {
        player.pause()
    }

    func seek(to time: TimeInterval) {
        player.playbackTime = time
        emitPlaybackModel()
    }

    func skipToNextEntry() {
        Task { try? await player.skipToNextEntry() }
    }

    func skipToPreviousEntry() {
        Task { try? await player.skipToPreviousEntry() }
    }

    // MARK: - Private helpers

    private func setupObservers() {
        player.state.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.emitPlaybackModel() }
            .store(in: &cancellables)

        player.queue.objectWillChange
            .receive(on: DispatchQueue.main)
            .map { [weak self] in self?.makeTrackModel() }
            .subscribe(trackPublisher)
            .store(in: &cancellables)

        Timer.publish(every: 0.25, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self, self.isPlaying else { return }
                self.emitPlaybackModel()
            }
            .store(in: &cancellables)
    }

    private func makeTrackModel() -> TrackModel? {
        let entry = player.queue.currentEntry
        return TrackModel(
            title: entry?.title,
            subtitle: entry?.subtitle,
            artwork: entry?.item.flatMap { artworkSource(from: $0) }?.url(width: 120, height: 120)
        )
    }

    private func emitPlaybackModel() {
        let model = PlaybackModel(
            currentTime: player.playbackTime,
            duration: currentDuration(),
            isPlaying: player.state.playbackStatus == .playing,
            repeatMode: RepeatMode(appleMode: player.state.repeatMode),
            shuffleMode: ShuffleMode(appleMode: player.state.shuffleMode)
        )
        playbackPublisher.send(model)
    }

    private func setQueue<S: Sequence, T: PlayableMusicItem>(
        for items: S,
        startingAt startItem: S.Element? = nil
    ) where S.Element == T {
        player.queue = ApplicationMusicPlayer.Queue(for: items, startingAt: startItem)
    }

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

// MARK: - Mode mappings

extension ShuffleMode {
    init(appleMode: MusicPlayer.ShuffleMode?) {
        switch appleMode {
        case .songs:
            self = .on
        default:
            self = .off
        }
    }
}

extension RepeatMode {
    init(appleMode: MusicPlayer.RepeatMode?) {
        switch appleMode {
        case .one:
            self = .one
        case .all:
            self = .all
        default:
            self = .none
        }
    }
}
