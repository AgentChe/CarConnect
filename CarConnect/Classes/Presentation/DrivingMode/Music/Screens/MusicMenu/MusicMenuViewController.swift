//
//  MusicMenuViewController.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 23.04.2026.
//

import UIKit

protocol MusicSourceSelectionDelegate: AnyObject {
    func selectedSource(_ source: MusicSource)
    func close()
}

class MusicSourceMenuViewController: UIViewController {
    private lazy var mainView = MusicSourceMenuView()
    private let actionFrame: CGRect?
    private let current: MusicSource?
    
    weak var delegate: MusicSourceSelectionDelegate?
    
    init(current: MusicSource?, actionFrame: CGRect?) {
        self.actionFrame = actionFrame
        self.current = current
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
        mainView.setup(for: actionFrame, current: current) { [weak self] source in
            self?.delegate?.selectedSource(source)
        }
        if current != nil {
            mainView.dropDownButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        }
    }

    @objc private func close(_ button: DropdownButtonView) {
        delegate?.close()
    }
}
