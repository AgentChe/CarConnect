//
//  AppleMusicViewController.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 12.03.2026.
//

import UIKit
import RxSwift

final class AppleMusicViewController: UIViewController {
    private lazy var mainView = AppleMusicView()
    
    private lazy var viewModel = AppleMusicViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: AppleMusicViewModel.Input())
    }
}

// MARK: Public
extension AppleMusicViewController {
    static func make() -> AppleMusicViewController {
        AppleMusicViewController()
    }
}
