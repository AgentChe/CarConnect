//
//  DrivingModeViewController.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 12.03.2026.
//

import UIKit

final class DrivingModeViewController: UIViewController {
    private lazy var mainView = DrivingModeView()

    override func loadView() {
        view = mainView
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        [.landscapeLeft]
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        .landscapeLeft
    }

    override var shouldAutorotate: Bool {
        true
    }
}

// MARK: Public
extension DrivingModeViewController {
    static func make() -> DrivingModeViewController {
        DrivingModeViewController()
    }
}
