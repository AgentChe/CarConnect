//
//  WidgetsPresetsTemplatesCollectionView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.02.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetsPresetsTemplatesCollectionView: UICollectionView {
    private lazy var elements = [WidgetsPresetsTemplatesCollectionElement]()
    
    private lazy var didTapOpenHelperTrigger = PublishRelay<Void>()
    private lazy var didSelectTrigger = PublishRelay<WidgetsPresetsTemplatesCollectionElement>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WidgetsPresetsTemplatesCollectionView {
    func setup(elements: [WidgetsPresetsTemplatesCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didTapOpenHelper: Signal<Void> {
        didTapOpenHelperTrigger.asSignal()
    }
    
    var didSelect: Signal<WidgetsPresetsTemplatesCollectionElement> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension WidgetsPresetsTemplatesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch elements[indexPath.row] {
        case .openHelper:
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsCollectionHelperCell.self), for: indexPath) as! WidgetsPresetsCollectionHelperCell
            cell.didTapOpenHelper = { [weak self] in
                self?.didTapOpenHelperTrigger.accept(Void())
            }
            return cell
        case .textManually(_, let configuration):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateTextManuallyCell.self), for: indexPath) as! WidgetsPresetsTemplateTextManuallyCell
            cell.setup(configuration: configuration)
            return cell
        case .quoteAmbitionDrive(_, let element, let configuration):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateQuoteAmbitionDriveCell.self), for: indexPath) as! WidgetsPresetsTemplateQuoteAmbitionDriveCell
            cell.setup(element: element, configuration: configuration)
            return cell
        case .quoteMindsetGrowth(_, let element, let configuration):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateQuoteMindsetGrowthCell.self), for: indexPath) as! WidgetsPresetsTemplateQuoteMindsetGrowthCell
            cell.setup(element: element, configuration: configuration)
            return cell
        case .quoteLeadershipImpact(_, let element, let configuration):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateQuoteLeadershipImpactCell.self), for: indexPath) as! WidgetsPresetsTemplateQuoteLeadershipImpactCell
            cell.setup(element: element, configuration: configuration)
            return cell
        case .quoteLifeMeaning(_, let element, let configuration):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateQuoteLifeMeaningCell.self), for: indexPath) as! WidgetsPresetsTemplateQuoteLifeMeaningCell
            cell.setup(element: element, configuration: configuration)
            return cell
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension WidgetsPresetsTemplatesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch elements[indexPath.row] {
        case .openHelper:
            return CGSize(width: 343.scale, height: 149.scale)
        default:
            return CGSize(width: 165.scale, height: 165.scale)
        }
    }
}

// MARK: Private
private extension WidgetsPresetsTemplatesCollectionView {
    func initialize() {
        // Text
        register(WidgetsPresetsTemplateQuoteAmbitionDriveCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateQuoteAmbitionDriveCell.self))
        register(WidgetsPresetsTemplateQuoteMindsetGrowthCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateQuoteMindsetGrowthCell.self))
        register(WidgetsPresetsTemplateQuoteLeadershipImpactCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateQuoteLeadershipImpactCell.self))
        register(WidgetsPresetsTemplateQuoteLifeMeaningCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateQuoteLifeMeaningCell.self))
        register(WidgetsPresetsTemplateTextManuallyCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateTextManuallyCell.self))
        
        // Helper
        register(WidgetsPresetsCollectionHelperCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsCollectionHelperCell.self))
        
        dataSource = self
        delegate = self
        
        backgroundColor = UIColor.clear
        contentInset = UIEdgeInsets(vertical: 12.scale)
        setContentOffset(CGPoint(x: 0, y: -12.scale), animated: false)
        showsVerticalScrollIndicator = false 
    }
}
