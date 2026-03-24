//
//  SelectLocationTableView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 23.03.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class SelectLocationTableView: UITableView {
    private lazy var elements = [SelectLocationTableElement]()
    
    private lazy var didScrollToBottomTrigger = PublishRelay<Void>()
    private lazy var didSelectTrigger = PublishRelay<SelectLocationTableElement>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SelectLocationTableView {
    func setup(elements: [SelectLocationTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didScrollToBottom: Signal<Void> {
        didScrollToBottomTrigger.asSignal()
    }
    
    var didSelect: Signal<SelectLocationTableElement> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension SelectLocationTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .myGeo(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SelectLocationMyGeoCell.self), for: indexPath) as! SelectLocationMyGeoCell
            cell.setup(element: element)
            return cell
        case .enterName:
            return dequeueReusableCell(withIdentifier: String(describing: SelectLocationEnterNameCell.self), for: indexPath)
        case .location(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SelectLocationCell.self), for: indexPath) as! SelectLocationCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension SelectLocationTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .myGeo:
            return 92.scale
        case .enterName:
            return 230.scale
        case .location:
            return 64.scale
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard (elements.count - 1) == indexPath.row else { return }
        
        didScrollToBottomTrigger.accept(Void())
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension SelectLocationTableView {
    func initialize() {
        register(SelectLocationMyGeoCell.self, forCellReuseIdentifier: String(describing: SelectLocationMyGeoCell.self))
        register(SelectLocationEnterNameCell.self, forCellReuseIdentifier: String(describing: SelectLocationEnterNameCell.self))
        register(SelectLocationCell.self, forCellReuseIdentifier: String(describing: SelectLocationCell.self))
        
        dataSource = self
        delegate = self
        
        backgroundColor = UIColor.clear
        separatorStyle = .none
        showsVerticalScrollIndicator = false
        contentInset = UIEdgeInsets(vertical: 12.scale)
        setContentOffset(CGPoint(x: 0, y: -12.scale), animated: false)
    }
}
