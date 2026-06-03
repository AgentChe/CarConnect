//
//  ContactsTableElement.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.06.2026.
//

struct ContactsTableElement {
    struct Phone {
        let number: String
        let label: String
    }

    let name: String
    let phones: [Phone]
}
