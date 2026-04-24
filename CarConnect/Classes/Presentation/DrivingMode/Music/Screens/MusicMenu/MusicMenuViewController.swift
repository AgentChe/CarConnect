//
//  MusicMenuViewController.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 23.04.2026.
//

import UIKit

class MusicSourceMenuViewController: UIViewController {
    private lazy var mainView = MusicSourceMenuView()
    private let actionFrame: CGRect
    
    init(actionFrame: CGRect) {
        self.actionFrame = actionFrame
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
        mainView.setup(for: actionFrame)
        mainView.dropDownButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    

    @objc private func close(_ button: DropdownButtonView) {
        dismiss(animated: false)
    }
}
