//
//  Fonts.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

// TODO: заменить шрифты
enum WidgetsFonts {
    case bebasNeue
    case jaro
    case pacifico
    case caveatBrush
    case dmSerifDisplay
    case kalnia
    case zenDots
    case dseg7Classic
    case holtwoodOneSC
    case gravitasOne
    case inter
    
    var sizeMultiplier: CGFloat {
        switch self {
        case .zenDots, .dseg7Classic, .holtwoodOneSC, .gravitasOne:
            return 0.8
        default:
            return 1.0
        }
    }
    
    func uiFont(baseSize: CGFloat) -> UIFont {
        let finalSize = baseSize * sizeMultiplier
        
        switch self {
        case .bebasNeue:
            return Fonts.BebasNeue.regular(size: finalSize)
        case .jaro:
            return Fonts.Jaro.regular(size: finalSize)
        case .pacifico:
            return Fonts.Pacifico.regular(size: finalSize)
        case .caveatBrush:
            return Fonts.CaveatBrush.regular(size: finalSize)
        case .dmSerifDisplay:
            return Fonts.DMSerifDisplay.regular(size: finalSize)
        case .kalnia:
            return Fonts.Kalnia.regular(size: finalSize)
        case .zenDots:
            return Fonts.ZenDots.regular(size: finalSize)
        case .dseg7Classic:
            return Fonts.DSEG7Classic.regular(size: finalSize)
        case .holtwoodOneSC:
            return Fonts.HoltwoodOneSC.regular(size: finalSize)
        case .gravitasOne:
            return Fonts.GravitasOne.regular(size: finalSize)
        case .inter:
            return Fonts.Inter.regular(size: finalSize)
        }
    }
}

struct Fonts {
    // MARK: Inter
    struct Inter {
        static func semiBold(size: CGFloat) -> UIFont {
            UIFont(name: "Inter-SemiBold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Inter-Regular", size: size)!
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "Inter-Medium", size: size)!
        }
        
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "Inter-Bold", size: size)!
        }
        
        static func extraBold(size: CGFloat) -> UIFont {
            UIFont(name: "Inter-ExtraBold", size: size)!
        }
    }
    
    // MARK: BebasNeue
    struct BebasNeue {
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "BebasNeue-Regular", size: size)!
        }
    }
    
    // MARK: Jaro
    struct Jaro {
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Jaro-Regular", size: size)!
        }
    }
    
    // MARK: Pacifico
    struct Pacifico {
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Pacifico-Regular", size: size)!
        }
    }
    
    // MARK: CaveatBrush
    struct CaveatBrush {
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "CaveatBrush-Regular", size: size)!
        }
    }
    
    // MARK: DMSerifDisplay
    struct DMSerifDisplay {
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "DMSerifDisplay-Regular", size: size)!
        }
    }
    
    // MARK: Kalnia
    struct Kalnia {
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Kalnia-Regular", size: size)!
        }
    }
    
    // MARK: ZenDots
    struct ZenDots {
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "ZenDots-Regular", size: size)!
        }
    }
    
    // MARK: DSEG7Classic
    struct DSEG7Classic {
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "DSEG7Classic-Regular", size: size)!
        }
    }
    
    // MARK: HoltwoodOneSC
    struct HoltwoodOneSC {
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "HoltwoodOneSC-Regular", size: size)!
        }
    }
    
    // MARK: GravitasOne
    struct GravitasOne {
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Gravitas One", size: size)!
        }
    }
}
