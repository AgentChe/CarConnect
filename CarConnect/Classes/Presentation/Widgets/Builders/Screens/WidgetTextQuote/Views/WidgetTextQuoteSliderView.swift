//
//  WidgetTextQuoteSliderView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 25.02.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetTextQuoteSliderView: UIView {
    lazy var viewsContainer = makeViewsContainer()
    lazy var pageControl = makePageControl()
    
    private let initialQuote: WidgetTextQuote
    
    private lazy var views = [(Int, WidgetQuoteSliderItemView)]()
    
    private lazy var currentIndex = 0
    
    private lazy var didChangedQuoteTrigger = PublishRelay<WidgetTextQuote>()
    
    init(quote: WidgetTextQuote) {
        self.initialQuote = quote
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        createViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WidgetTextQuoteSliderView {
    func setup(configuration: WidgetTextQuoteConfiguration) {
        views.forEach { _, view in
            view.setup(configuration: configuration)
        }
    }
    
    func canRigthSwipe() -> Bool {
        currentIndex > 0
    }
    
    func makeSnapshotCurrentView() -> UIImage? {
        guard let currentView = views.first(where: { $0.0 == currentIndex })?.1 else {
            return nil
        }

        let targetBounds = currentView.bounds
        guard targetBounds.width > 0, targetBounds.height > 0 else { return nil }

        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        format.opaque = currentView.isOpaque

        let renderer = UIGraphicsImageRenderer(size: targetBounds.size, format: format)

        if currentView.window != nil {
            return renderer.image { _ in
                currentView.drawHierarchy(in: targetBounds, afterScreenUpdates: true)
            }
        } else {
            return renderer.image { ctx in
                currentView.layer.render(in: ctx.cgContext)
            }
        }
    }
    
    var didChangedQuote: Signal<WidgetTextQuote> {
        didChangedQuoteTrigger.asSignal()
    }
}

// MARK: Private
private extension WidgetTextQuoteSliderView {
    func initialize() {
        backgroundColor = UIColor.clear
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe))
        leftSwipeGesture.direction = .left
        viewsContainer.addGestureRecognizer(leftSwipeGesture)
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipe))
        rightSwipeGesture.direction = .right
        viewsContainer.addGestureRecognizer(rightSwipeGesture)
    }
    
    func createViews() {
        let views: [WidgetQuoteSliderItemView] = {
            switch initialQuote {
            case .ambitionDrive:
                return WidgetTextQuoteAmbitionDrive.templates().map { template -> WidgetQuoteSliderItemView in
                    WidgetQuoteSliderAmbitionDriveView(quote: template)
                }
            case .mindsetGrowth:
                return WidgetTextQuoteMindsetGrowth.templates().map { template -> WidgetQuoteSliderItemView in
                    WidgetQuoteSliderMindsetGrowthView(quote: template)
                }
            case .leadershipImpact:
                return WidgetTextQuoteLeadershipImpact.templates().map { template -> WidgetQuoteSliderItemView in
                    WidgetQuoteSliderLeadershipImpactView(quote: template)
                }
            case .lifeMeaning:
                return WidgetTextQuoteLifeMeaning.templates().map { template -> WidgetQuoteSliderItemView in
                    WidgetQuoteSliderLifeMeaningView(quote: template)
                }
            }
        }()
        
        let cardSize = CGSize(width: 343.scale, height: 343.scale)
        let pageWidth = UIScreen.main.bounds.width
        let insetX = (pageWidth - cardSize.width) / 2.0
        
        views.enumerated().forEach { index, view in
            view.frame.size = cardSize
            view.frame.origin = CGPoint(x: CGFloat(index) * pageWidth + insetX, y: 0)
            viewsContainer.addSubview(view)
        }
        
        self.views = views.enumerated().map { ($0, $1) }
        
        pageControl.numberOfPages = views.count
        pageControl.currentPage = currentIndex
    }
    
    @objc
    func leftSwipe() {
        move(incrementIndex: 1)
    }
    
    @objc
    func rightSwipe() {
        move(incrementIndex: -1)
    }
    
    func move(incrementIndex: Int) {
        let moveToIndex = currentIndex + incrementIndex

        guard views.contains(where: { $0.0 == moveToIndex }) else { return }

        currentIndex = moveToIndex

        let pageWidth = UIScreen.main.bounds.width
        let cardWidth = views.first?.1.frame.width ?? 0
        let insetX = (pageWidth - cardWidth) / 2.0

        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: [.curveEaseInOut, .beginFromCurrentState, .allowUserInteraction],
            animations: { [weak self] in
                guard let self else { return }
                
                self.views.forEach { index, view in
                    view.frame.origin.x = CGFloat(index - self.currentIndex) * pageWidth + insetX
                }
                
                self.pageControl.currentPage = currentIndex
            },
            completion: { [weak self] _ in
                guard let self, let view = views.first(where: { $0.0 == self.currentIndex })?.1 else { return }
                
                didChangedQuoteTrigger.accept(view.getQuote())
            }
        )
    }
}

// MARK: Make constraints
private extension WidgetTextQuoteSliderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            viewsContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewsContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewsContainer.topAnchor.constraint(equalTo: topAnchor),
            viewsContainer.heightAnchor.constraint(equalToConstant: 343.scale)
        ])
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: viewsContainer.bottomAnchor, constant: 16.scale),
            pageControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetTextQuoteSliderView {
    func makeViewsContainer() -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePageControl() -> UIPageControl {
        let view = UIPageControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.currentPageIndicatorTintColor = Appearance.color_4178F6
        view.pageIndicatorTintColor = Appearance.color_2C2F39
        addSubview(view)
        return view
    }
}
