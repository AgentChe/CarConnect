//
//  ContactsTableView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.06.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class ContactsTableView: UITableView {
    private lazy var elements = [ContactsTableElement]()
    
    private lazy var didSelectTrigger = PublishRelay<ContactsTableElement>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ContactsTableView {
    func setup(elements: [ContactsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<ContactsTableElement> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension ContactsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: ContactsTableCell.self), for: indexPath) as! ContactsTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension ContactsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension ContactsTableView {
    func initialize() {
        register(ContactsTableCell.self, forCellReuseIdentifier: String(describing: ContactsTableCell.self))
        
        dataSource = self
        delegate = self
        
        backgroundColor = UIColor.clear
        separatorStyle = .none
        showsVerticalScrollIndicator = false
        contentInset = UIEdgeInsets()
        setContentOffset(CGPoint(), animated: false)
    }
}
