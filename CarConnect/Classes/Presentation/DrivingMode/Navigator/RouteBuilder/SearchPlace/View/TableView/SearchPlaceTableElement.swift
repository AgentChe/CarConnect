//
//  SearchPlaceTableElement.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 26.05.2026.
//

enum SearchPlaceTableElement {
    case preset(NavigatorPreset)
    case place(SearchPlaceTablePlaceElement)
}

enum SearchPlaceTablePlaceElement {
    case searched(NavigatorPlace)
    case fromPreset(NavigatorPlace)
    
    var place: NavigatorPlace {
        switch self {
        case .searched(let navigatorPlace):
            return navigatorPlace
        case .fromPreset(let navigatorPlace):
            return navigatorPlace
        }
    }
}
