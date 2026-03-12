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
    var landscapeHScale: Self { get }
    var landscapeVScale: Self { get }
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
    
    var landscapeHScale: CGFloat {
        let designWidth: CGFloat = 812
        let size = UIScreen.main.bounds.size
        let actualWidth = CGFloat.maximum(size.width, size.height)
        return self * actualWidth / designWidth
    }

    var landscapeVScale: CGFloat {
        let designHeight: CGFloat = 375
        let size = UIScreen.main.bounds.size
        let actualHeight = CGFloat.minimum(size.width, size.height)
        return self * actualHeight / designHeight
    }
}

extension Int {
    var scale: CGFloat {
        CGFloat(self).scale
    }
    
    var vScale: CGFloat {
        CGFloat(self).vScale
    }
    
    var landscapeHScale: CGFloat {
        CGFloat(self).landscapeHScale
    }
    
    var landscapeVScale: CGFloat {
        CGFloat(self).landscapeVScale
    }
}

extension Double {
    var scale: CGFloat {
        CGFloat(self).scale
    }
    
    var vScale: CGFloat {
        CGFloat(self).vScale
    }
    
    var landscapeHScale: CGFloat {
        CGFloat(self).landscapeHScale
    }
    
    var landscapeVScale: CGFloat {
        CGFloat(self).landscapeVScale
    }
}
