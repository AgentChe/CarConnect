//
//  AuthorizationRequiredViewController.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 24.05.2026.
//

import Foundation
import UIKit

protocol AuthorizationRequiredViewControllerDelegate: AnyObject {
    func didTapButton()
}

final class AuthorizationRequiredViewController: UIViewController {
    private lazy var mainView = AuthorizationRequiredView()
    private let source: MusicSource
    weak var delegate: AuthorizationRequiredViewControllerDelegate?
    
    init(source: MusicSource) {
        self.source = source
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.setup(source: source)
        mainView.actionButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    @objc private func buttonAction() {
        delegate?.didTapButton()
    }
}
