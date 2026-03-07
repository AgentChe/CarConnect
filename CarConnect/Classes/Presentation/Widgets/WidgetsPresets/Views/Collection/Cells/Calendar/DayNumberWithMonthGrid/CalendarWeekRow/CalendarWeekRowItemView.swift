//
//  CalendarWeekRowItemView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 06.03.2026.
//

import UIKit

final class CalendarWeekRowItemView: UIView {
    enum Metrics {
        case small, large
    }
    
    struct Item {
        let day: String
        let weekday: String
        let isHighlight: Bool
    }
    
    lazy var highlightView = makeHighlightView()
    lazy var dayLabel = makeLabel()
    lazy var weekdayLabel = makeLabel()
    
    private let metrics: Metrics
    
    init(metrics: Metrics) {
        self.metrics = metrics
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CalendarWeekRowItemView {
    func setup(item: Item, configuration: WidgetCalendarCongifuration) {
        highlightView.isHidden = !item.isHighlight
        
        let fontSize: CGFloat = {
            switch metrics {
            case .small:
                return 16.scale
            case .large:
                return 33.scale
            }
        }()
        
        let dayTextColor = item.isHighlight ? Appearance.color_FF4539 : configuration.fontColor
        let dayAttrs = TextAttributes()
            .textColor(dayTextColor)
            .font(configuration.font.uiFont(baseSize: fontSize))
            .textAlignment(.center)
        dayLabel.attributedText = item.day.attributed(with: dayAttrs)
        
        let weekdayAttrs = TextAttributes()
            .textColor(configuration.fontColor.withAlphaComponent(0.6))
            .font(configuration.font.uiFont(baseSize: fontSize))
            .textAlignment(.center)
        weekdayLabel.attributedText = item.weekday.attributed(with: weekdayAttrs)
    }
}

// MARK: Private
private extension CalendarWeekRowItemView {
    func initialize() {
        backgroundColor = UIColor.clear
        layer.masksToBounds = false
    }
}

// MARK: Make constraints
private extension CalendarWeekRowItemView {
    func makeConstraints() {
        let highlightSize: CGFloat = {
            switch metrics {
            case .small:
                return 24.scale
            case .large:
                return 50.scale
            }
        }()
        
        NSLayoutConstraint.activate([
            highlightView.widthAnchor.constraint(equalToConstant: highlightSize),
            highlightView.heightAnchor.constraint(equalToConstant: highlightSize),
            highlightView.centerXAnchor.constraint(equalTo: dayLabel.centerXAnchor),
            highlightView.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dayLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            weekdayLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            weekdayLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CalendarWeekRowItemView {
    func makeHighlightView() -> UIView {
        let corner: CGFloat = {
            switch metrics {
            case .small:
                return 12.scale
            case .large:
                return 25.scale
            }
        }()
        
        let view = UIView()
        view.layer.cornerRadius = corner
        view.backgroundColor = Appearance.color_FFFFFF
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
