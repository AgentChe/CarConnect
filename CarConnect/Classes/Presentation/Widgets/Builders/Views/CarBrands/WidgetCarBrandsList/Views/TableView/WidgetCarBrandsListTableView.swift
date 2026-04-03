//
//  WidgetCarBrandsListTableView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 03.04.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetCarBrandsListTableView: UITableView {
    private lazy var elements = [WidgetCarBrandsListTableElement]()
    
    private lazy var didSelectTrigger = PublishRelay<WidgetCarBrandsListTableElement>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WidgetCarBrandsListTableView {
    func setup(elements: [WidgetCarBrandsListTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<WidgetCarBrandsListTableElement> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension WidgetCarBrandsListTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: WidgetCarBrandsListTableCell.self), for: indexPath) as! WidgetCarBrandsListTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension WidgetCarBrandsListTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64.scale
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension WidgetCarBrandsListTableView {
    func initialize() {
        register(WidgetCarBrandsListTableCell.self, forCellReuseIdentifier: String(describing: WidgetCarBrandsListTableCell.self))
        
        dataSource = self
        delegate = self
        
        backgroundColor = UIColor.clear
        separatorStyle = .none
        showsVerticalScrollIndicator = false
        contentInset = UIEdgeInsets(vertical: 12.scale)
        setContentOffset(CGPoint(x: 0, y: -12.scale), animated: false)
    }
}
