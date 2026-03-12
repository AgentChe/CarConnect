//
//  NursingNavigationController.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apply(settings: .default())
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let presentedViewController {
            return presentedViewController.supportedInterfaceOrientations
        }
        return topViewController?.supportedInterfaceOrientations ?? .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let presentedViewController {
            return presentedViewController.preferredInterfaceOrientationForPresentation
        }
        return topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }

    override var shouldAutorotate: Bool {
        if let presentedViewController {
            return presentedViewController.shouldAutorotate
        }
        return topViewController?.shouldAutorotate ?? true
    }
}

// MARK: API
extension NavigationController {
    func apply(settings: NavigationControllerSettings) {
        navigationBar.setBackgroundImage(settings.backgroundImage, for: .default)
        navigationBar.shadowImage = settings.shadowImage
        navigationBar.isTranslucent = settings.isTranslucent
        navigationBar.tintColor = settings.tintColor
        navigationBar.titleTextAttributes = settings.titleTextAttrributes
    }
}
