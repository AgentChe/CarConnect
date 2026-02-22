//
//  WidgetsHelperScrollImageView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 21.02.2026.
//

import UIKit

final class WidgetsHelperScrollImageView: UIImageView {
    init(imageName: String) {
        super.init(frame: .zero)
        
        contentMode = .scaleAspectFit
        image = UIImage(named: imageName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
