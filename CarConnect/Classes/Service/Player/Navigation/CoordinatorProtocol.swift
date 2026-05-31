//
//  CoordinatorProtocol.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 30.05.2026.
//

import Foundation
import UIKit

protocol Routable {
    func pop()
    func dismiss()
}

protocol CoordinatorProtocol: AnyObject {
    var childCoordinator: [CoordinatorProtocol] { get set }
}

protocol CoordinatorBaseProtocol: CoordinatorProtocol {
    var navigationController: UINavigationController? { get set }
    func start()
}
