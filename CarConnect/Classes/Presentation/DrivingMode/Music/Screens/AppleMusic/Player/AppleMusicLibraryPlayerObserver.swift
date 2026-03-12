//
//  AppleMusicLibraryPlayerObserver.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 12.03.2026.
//

import MusicKit
import Combine
import SwiftUI
import UIKit

protocol AppleMusicLibraryPlayerObserverDelegate: AnyObject {
    func playerDidChange(state: AppleMusicPlayerState)
    func playerQueueChanged()
}

final class AppleMusicLibraryPlayerObserver {
    deinit {
        stateCancellable?.cancel()
        queueCancellable?.cancel()
    }
    
    private var stateCancellable: AnyCancellable?
    private var queueCancellable: AnyCancellable?
    
    private weak var delegate: AppleMusicLibraryPlayerObserverDelegate?
    
    init(delegate: AppleMusicLibraryPlayerObserverDelegate) {
        self.delegate = delegate
        
        stateCancellable = AppleMusicLibraryPlayer.shared.player.state
            .objectWillChange
            .sink(receiveValue: { [weak self] in
                self?.delegate?.playerDidChange(state: AppleMusicLibraryPlayer.shared.state)
            })
        
        queueCancellable = AppleMusicLibraryPlayer.shared.player.queue
            .objectWillChange
            .sink(receiveValue: { [weak self] in
                self?.delegate?.playerQueueChanged()
            })
    }
}
