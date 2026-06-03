//
//  ContactsView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.06.2026.
//

import UIKit
import RxSwift
import RxCocoa
import Contacts

final class ContactsView: UIView {
    private lazy var rootView = makeRootView()

    private lazy var store = CNContactStore()

    private var contacts = [ContactsTableElement]()
    private var searchQuery = ""

    private lazy var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)

        makeConstraints()
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ContactsView {
    func initialize() {
        backgroundColor = UIColor.clear

        rootView.unlockView.actionButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.requestAccess()
            })
            .disposed(by: disposeBag)
        
        rootView.listView.tableView.rx.willBeginDragging
            .bind(to: rx.hideKeyboardObserver)
            .disposed(by: disposeBag)

        rootView.listView.searchField.didEnterName
            .emit(onNext: { [weak self] name in
                self?.filterContacts(by: name)
            })
            .disposed(by: disposeBag)

        displayContactsState()
    }

    func displayContactsState() {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized, .limited:
            rootView.setup(state: .list)
            loadContacts()
        default:
            rootView.setup(state: .unlock)
        }
    }

    func requestAccess() {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .notDetermined:
            store.requestAccess(for: .contacts) { [weak self] _, _ in
                DispatchQueue.main.async {
                    self?.displayContactsState()
                }
            }
        default:
            openSettings()
        }
    }

    func loadContacts() {
        let keys = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName)
        ]

        let request = CNContactFetchRequest(keysToFetch: keys)

        // Перебор контактов — операция синхронная и может быть долгой, уводим её с главного потока.
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }

            var elements = [ContactsTableElement]()

            do {
                try self.store.enumerateContacts(with: request) { contact, _ in
                    guard let name = CNContactFormatter.string(from: contact, style: .fullName), !name.isEmpty else { return }

                    elements.append(ContactsTableElement(name: name))
                }
            } catch {
                elements = []
            }

            DispatchQueue.main.async {
                self.contacts = elements
                self.reloadList()
            }
        }
    }

    func filterContacts(by query: String) {
        searchQuery = query

        reloadList()
    }

    func reloadList() {
        let elements = searchQuery.isEmpty
            ? contacts
            : contacts.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }

        rootView.listView.tableView.setup(elements: elements)
    }

    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        DispatchQueue.main.async {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: Make constraints
private extension ContactsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            rootView.leadingAnchor.constraint(equalTo: leadingAnchor),
            rootView.trailingAnchor.constraint(equalTo: trailingAnchor),
            rootView.topAnchor.constraint(equalTo: topAnchor),
            rootView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ContactsView {
    func makeRootView() -> ContactsRootView {
        let view = ContactsRootView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
