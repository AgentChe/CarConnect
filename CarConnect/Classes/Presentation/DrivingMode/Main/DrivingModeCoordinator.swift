//
//  DrivingModeCoordinator.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 12.03.2026.
//

import UIKit

final class DrivingModeCoordinator {
    private lazy var mapVC = NavigatorViewController.make()
    private lazy var musicCoordinator = MusicPlayerCoordinator(navigationController: .init())
    private lazy var phoneVC = PhoneViewController.make()
    
    private weak var parentVC: UIViewController?
    private weak var container: UIView?
    
    private var currentItem: DrivingModeRouteItemButton.Item?
    private var previousVC: UIViewController?
    
    init(parentVC: UIViewController, container: UIView) {
        self.parentVC = parentVC
        self.container = container
    }
}

// MARK: Public
extension DrivingModeCoordinator {
    func tap(on item: DrivingModeRouteItemButton.Item) {
        guard currentItem != item else { return }
        
        currentItem = item 
        
        switch item {
        case .map:
            changeVC(on: mapVC)
        case .music:
            if let controller = musicCoordinator.navigationController {
                changeVC(on: controller)
                musicCoordinator.switchSource(source: nil)
            }
        case .phone:
            changeVC(on: phoneVC)
        }
    }
}

// MARK: Private
private extension DrivingModeCoordinator {
    func changeVC(on vc: UIViewController) {
        if let previousVC = self.previousVC {
            previousVC.willMove(toParent: nil)
            previousVC.view.removeFromSuperview()
            previousVC.removeFromParent()
        }
    
        self.previousVC = vc
        
        guard let parentVC, let container else { return }
    
        parentVC.addChild(vc)
        vc.view.frame = container.bounds
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        container.addSubview(vc.view)
        vc.didMove(toParent: parentVC)
    }
}
