//
//  ContactDetailViewController.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.06.2026.
//

import UIKit

final class ContactDetailViewController: UIViewController {
    private lazy var mainView = ContactDetailView()

    private let contact: ContactsTableElement

    init(contact: ContactsTableElement) {
        self.contact = contact

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

        mainView.backButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
        mainView.didSelectPhone = { [weak self] phone in
            self?.call(phone)
        }
        mainView.setup(contact: contact)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

// MARK: Private
private extension ContactDetailViewController {
    @objc
    func pop() {
        navigationController?.popViewController(animated: true)
    }

    func call(_ phone: ContactsTableElement.Phone) {
        let allowed = CharacterSet(charactersIn: "+0123456789")
        let sanitized = phone.number.components(separatedBy: allowed.inverted).joined()

        guard !sanitized.isEmpty, let url = URL(string: "tel://\(sanitized)") else {
            return
        }

        UIApplication.shared.open(url)
    }
}
