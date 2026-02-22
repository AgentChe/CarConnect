//
//  MainCoordinator.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 21.02.2026.
//

import UIKit

final class MainCoordinator {
    private lazy var garageVC = UIViewController()
    private lazy var widgetsVC = UIViewController()
    private lazy var drivingModeVC = UIViewController()
    
    private weak var parentVC: UIViewController?
    private weak var container: UIView?
    
    private var previousVC: UIViewController?
    
    init(parentVC: UIViewController, container: UIView) {
        self.parentVC = parentVC
        self.container = container
    }
}

// MARK: Public
extension MainCoordinator {
    func tap(on tab: TabView.TabItem) {
        switch tab {
        case .garage:
            changeVC(on: garageVC)
        case .widgets:
            changeVC(on: widgetsVC)
        case .drivingMode:
            // TODO:
//            parentVC?.present(drivingModeVC, animated: false)
            
            parentVC?.present(WidgetsHelperViewController.make(), animated: true)
        }
    }
}

// MARK: Private
private extension MainCoordinator {
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
        container.addSubview(vc.view)
        vc.willMove(toParent: parentVC)
    }
}
