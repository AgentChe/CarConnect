//
//  Fonts.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

enum WidgetsFonts {
    case poppins
    case audiowide
    case orbitron
    case archivoBlack
    case rubik
    case abrilFatface
    case playfairDisplay
    case georgia
    case sora
    case spaceGrotesk
    case inter
    
    func uiFont(baseSize: CGFloat) -> UIFont {
        switch self {
        case .poppins:
            return Fonts.Poppins.extraBold(size: baseSize)
        case .audiowide:
            return Fonts.Audiowide.regular(size: baseSize)
        case .orbitron:
            return Fonts.Orbitron.regular(size: baseSize)
        case .archivoBlack:
            return Fonts.ArchivoBlack.regular(size: baseSize)
        case .rubik:
            return Fonts.Rubik.semiBold(size: baseSize)
        case .abrilFatface:
            return Fonts.AbrilFatface.regular(size: baseSize)
        case .playfairDisplay:
            return Fonts.PlayfairDisplay.semiBold(size: baseSize)
        case .georgia:
            return Fonts.Georgia.regular(size: baseSize)
        case .sora:
            return Fonts.Sora.semiBold(size: baseSize)
        case .spaceGrotesk:
            return Fonts.SpaceGrotesk.medium(size: baseSize)
        case .inter:
            return Fonts.Inter.regular(size: baseSize)
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
    
    // MARK: Poppins
    struct Poppins {
        static func extraBold(size: CGFloat) -> UIFont {
            UIFont(name: "Poppins-ExtraBold", size: size)!
        }
    }
    
    // MARK: Audiowide
    struct Audiowide {
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Audiowide-Regular", size: size)!
        }
    }
    
    // MARK: Orbitron
    struct Orbitron {
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Orbitron-Regular", size: size)!
        }
    }
    
    // MARK: ArchivoBlack
    struct ArchivoBlack {
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "ArchivoBlack-Regular", size: size)!
        }
    }
    
    // MARK: Rubik
    struct Rubik {
        static func semiBold(size: CGFloat) -> UIFont {
            UIFont(name: "Rubik-SemiBold", size: size)!
        }
    }
    
    // MARK: AbrilFatface
    struct AbrilFatface {
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "AbrilFatface-Regular", size: size)!
        }
    }
    
    // MARK: PlayfairDisplay
    struct PlayfairDisplay {
        static func semiBold(size: CGFloat) -> UIFont {
            UIFont(name: "PlayfairDisplay-SemiBold", size: size)!
        }
    }
    
    // MARK: Georgia
    struct Georgia {
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "georgia", size: size)!
        }
    }
    
    // MARK: Sora
    struct Sora {
        static func semiBold(size: CGFloat) -> UIFont {
            UIFont(name: "Sora-SemiBold", size: size)!
        }
    }
    
    // MARK: SpaceGrotesk
    struct SpaceGrotesk {
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "SpaceGrotesk-Medium", size: size)!
        }
    }
}
