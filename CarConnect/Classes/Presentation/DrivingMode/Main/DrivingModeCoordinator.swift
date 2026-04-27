//
//  DrivingModeCoordinator.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 12.03.2026.
//

import UIKit

final class DrivingModeCoordinator {
    private lazy var mapVC = UIViewController()
    private lazy var musicVC = AppleMusicMainViewController.make()
    private lazy var phoneVC = UIViewController()
    
    private weak var parentVC: UIViewController?
    private weak var container: UIView?
    
    private var previousVC: UIViewController?
    
    init(parentVC: UIViewController, container: UIView) {
        self.parentVC = parentVC
        self.container = container
    }
}

// MARK: Public
extension DrivingModeCoordinator {
    // TODO: Добавить логику переключения
    func testInitial() {
        changeVC(on: musicVC)
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
        vc.willMove(toParent: parentVC)
    }
}
