//
//  Scalable.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

protocol Scalable {
    var scale: Self { get }
    var vScale: Self { get }
}

extension CGFloat: Scalable {
    var scale: CGFloat {
        let designScreenWidth: CGFloat = 375
        let currentScreenWidth = UIScreen.main.bounds.size.width
        return self * currentScreenWidth / designScreenWidth
    }
    
    var vScale: CGFloat {
        let designScreenHeight: CGFloat = 812
        let currentScreenHeight = UIScreen.main.bounds.size.height
        return self * currentScreenHeight / designScreenHeight
    }
}

extension Int {
    var scale: CGFloat {
        CGFloat(self).scale
    }
    
    var vScale: CGFloat {
        CGFloat(self).vScale
    }
}

extension Double {
    var scale: CGFloat {
        CGFloat(self).scale
    }
    
    var vScale: CGFloat {
        CGFloat(self).vScale
    }
}
