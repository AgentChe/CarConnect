//
//  SelectLocationTableElement.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 23.03.2026.
//

enum SelectLocationTableElement {
    case myGeo(Location)
    case enterName
    case location(SelectLocationElement)
}

struct SelectLocationElement {
    let location: Location
    let checked: Bool
    let corneredTop: Bool
    let corneredBottom: Bool
    let separatorHidden: Bool
}
