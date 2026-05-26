//
//  SearchPlaceTableView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 26.05.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchPlaceTableView: UITableView {
    private lazy var elements = [SearchPlaceTableElement]()
    
    private lazy var didSelectTrigger = PublishRelay<SearchPlaceTableElement>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SearchPlaceTableView {
    func setup(elements: [SearchPlaceTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<SearchPlaceTableElement> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension SearchPlaceTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .preset(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SearchPlaceTablePresetCell.self), for: indexPath) as! SearchPlaceTablePresetCell
            cell.setup(element: element)
            return cell
        case .place(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SearchPlaceTablePlaceCell.self), for: indexPath) as! SearchPlaceTablePlaceCell
            cell.setup(element: element.place)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension SearchPlaceTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension SearchPlaceTableView {
    func initialize() {
        register(SearchPlaceTablePresetCell.self, forCellReuseIdentifier: String(describing: SearchPlaceTablePresetCell.self))
        register(SearchPlaceTablePlaceCell.self, forCellReuseIdentifier: String(describing: SearchPlaceTablePlaceCell.self))
        
        dataSource = self
        delegate = self
        
        backgroundColor = UIColor.clear
        separatorStyle = .none
        showsVerticalScrollIndicator = false
        contentInset = UIEdgeInsets(vertical: 8.scale)
        setContentOffset(CGPoint(x: 0, y: -8.scale), animated: false)
    }
}
