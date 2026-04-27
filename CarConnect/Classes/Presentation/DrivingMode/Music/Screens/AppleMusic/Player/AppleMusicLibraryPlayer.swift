//
//  AppleMusicLibraryPlayer.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 12.03.2026.
//

import Foundation
import MusicKit
import Combine

final class AppleMusicLibraryPlayer {
    static let shared = AppleMusicLibraryPlayer()
    
    let player = ApplicationMusicPlayer.shared
    
    private init() {}
    
    var state: AppleMusicPlayerState {
        AppleMusicPlayerState(state: player.state)
    }
    
    var isPreparedToPlay: Bool {
        player.isPreparedToPlay
    }
    
    var isShuffling: Bool {
        player.state.shuffleMode == MusicPlayer.ShuffleMode.songs
    }
    
    var isRepeated: Bool {
        player.state.repeatMode == MusicPlayer.RepeatMode.one
    }
    
    func prepareToPlay(errorHandler: ((Error) -> Void)? = nil) {
        Task {
            do {
                try await player.prepareToPlay()
            } catch let error {
                errorHandler?(error)
            }
        }
    }
    
    func play(onPlay: (() -> Void)? = nil, errorHandler: ((Error) -> Void)? = nil) {
        Task {
            do {
                try await player.play()
                onPlay?()
            } catch let error {
                errorHandler?(error)
            }
        }
    }
    
    func pause() {
        player.pause()
    }
    
    func stop() {
        player.stop()
    }
    
    var playbackTime: TimeInterval {
        player.playbackTime
    }
    
    func skipToPreviousEntry(errorHandler: ((Error) -> Void)? = nil) {
        Task {
            do {
                try await player.skipToPreviousEntry()
            } catch let error {
                errorHandler?(error)
            }
        }
    }
    
    func skipToNextEntry(errorHandler: ((Error) -> Void)? = nil) {
        Task {
            do {
                try await player.skipToNextEntry()
            } catch let error {
                errorHandler?(error)
            }
        }
    }
    
    func restartCurrentEntry() {
        player.restartCurrentEntry()
    }
    
    func beginSeekingForward() {
        player.beginSeekingForward()
    }
    
    func beginSeekingBackward() {
        player.beginSeekingBackward()
    }
    
    func seek(to time: TimeInterval) {
        player.playbackTime = time
    }
    
    func endSeeking() {
        player.endSeeking()
    }

//    var queue: [MKQueueEntry] {
//        player.queue.entries.compactMap { entry -> MKQueueEntry? in
//            MKQueueEntry(entry: entry, position: player.queue.entries.firstIndex(of: entry))
//        }
//    }
//    
//    var currentEntry: MKQueueEntry? {
//        let currentEntry = player.queue.currentEntry
//        return currentEntry.map { MKQueueEntry(entry: $0, position: player.queue.entries.firstIndex(of: $0)) }
//    }
    
    func setRepeat() {
        if !isRepeated {
            player.state.repeatMode = MusicPlayer.RepeatMode.one
        } else {
            player.state.repeatMode = MusicPlayer.RepeatMode.none
        }
    }
    
    func setShuffle() {
        if !isShuffling {
            player.state.shuffleMode = MusicPlayer.ShuffleMode.songs
        } else {
            player.state.shuffleMode = MusicPlayer.ShuffleMode.off
        }
    }
}

// MARK: Fetch
extension AppleMusicLibraryPlayer {
    func fetch(albumId: String, willPlay: Bool = true, errorHandler: ((Error) -> Void)? = nil) {
        Task {
            var request = MusicLibraryRequest<Album>()
            request.limit = 0
            request.offset = 0

            do {
                guard
                    let album = try await request.response().items.filter({ $0.id.rawValue == albumId }).first,
                    let tracks = try await album.with([.tracks]).tracks
                else {
                    return
                }
                 
                player.queue = ApplicationMusicPlayer.Queue(for: tracks)

                if willPlay {
                    play(errorHandler: errorHandler)
                }
            } catch let error {
                errorHandler?(error)
            }
        }
    }
    
    func fetch(playlistId: String, willPlay: Bool = true, errorHandler: ((Error) -> Void)? = nil) {
        Task {
            var request = MusicLibraryRequest<Playlist>()
            request.limit = 0
            request.offset = 0

            do {
                guard
                    let playlist = try await request.response().items.filter({ $0.id.rawValue == playlistId }).first,
                    let tracks = try await playlist.with([.tracks]).tracks
                else {
                    return
                }
                
                let filteredTracks = tracks.compactMap { track -> Track? in
                    switch track {
                    case .song(let song):
                        return song.libraryAddedDate != nil ? track : nil
                    case .musicVideo(let video):
                        return video.libraryAddedDate != nil ? track : nil
                    @unknown default:
                        return nil
                    }
                }
                 
                player.queue = ApplicationMusicPlayer.Queue(for: filteredTracks)

                if willPlay {
                    play(errorHandler: errorHandler)
                }
            } catch let error {
                errorHandler?(error)
            }
        }
    }
    
    func fetch(songId: String, willPlay: Bool = true, errorHandler: ((Error) -> Void)? = nil) {
        Task {
            var request = MusicLibraryRequest<Song>()
            request.limit = 0
            request.offset = 0

            do {
                let song = try await request.response().items.filter { $0.id.rawValue == songId }
                player.queue = ApplicationMusicPlayer.Queue(for: song)
                
                if willPlay {
                    play(errorHandler: errorHandler)
                }
            } catch let error {
                errorHandler?(error)
            }
        }
    }
    
    func fetch(songsIds: [String], startWith: String, willPlay: Bool = true, onPlay: (([String: String]) -> Void)? = nil, errorHandler: ((Error) -> Void)? = nil) {
        Task {
            do {
                var request = MusicLibraryRequest<Song>()
                request.limit = 0
                request.offset = 0
                
                let librarySongs = try await request.response().items
                
                // Создаем словарь для быстрого поиска по ID
                let songsMap = Dictionary(uniqueKeysWithValues: librarySongs.map { ($0.id.rawValue, $0) })
                
                // Формируем список воспроизведения:
                // 1. Берем IDs из запроса (чтобы сохранить порядок)
                // 2. Ищем соответствующие песни в медиатеке
                // 3. Если песни нет в медиатеке (songsMap[$0] == nil), она просто пропускается (compactMap)
                let orderedSongs = songsIds.compactMap { songsMap[$0] }
                
                guard !orderedSongs.isEmpty else { return }
                
                let start = orderedSongs.first(where: { $0.id.rawValue == startWith })
                player.queue = ApplicationMusicPlayer.Queue(for: orderedSongs, startingAt: start)
                
                try await player.prepareToPlay()
                
                let bindSongIds = Dictionary(
                    player.queue.entries.compactMap { e in
                        let songId: String = orderedSongs.first(where: { $0.title == e.title && $0.artistName == e.subtitle })?.id.rawValue ?? ""
                        return (songId, e.id)
                    },
                    uniquingKeysWith: { (first, last) in last }
                )
                
                if willPlay {
                    play(onPlay: { onPlay?(bindSongIds) }, errorHandler: errorHandler)
                } else {
                    onPlay?(bindSongIds);
                }
            } catch let error {
                errorHandler?(error)
            }
        }
    }
}
