//
//  MonthAbbrevAndDayNumberLargeView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 07.03.2026.
//

import UIKit

final class MonthAbbrevAndDayNumberLargeView: CalendarStyleView {
    enum Metrics {
        case small, large
    }
    
    lazy var backgroundColorView = makeBackgroundColorView()
    lazy var backgroundImageView = makeBackgroundImageView()
    lazy var container = makeContainer()
    lazy var weekdayMonthLabel = makeLabel()
    lazy var dayLabel = makeLabel()
    
    private lazy var weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "EEE"
        return formatter
    }()
    private lazy var monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "MMM"
        return formatter
    }()
    private lazy var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "d"
        return formatter
    }()
    
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
    
    override func setup(configuration: WidgetCalendarCongifuration) {
        updateDate(configuration: configuration)
        updateBackground(configuration: configuration)
    }
}

// MARK: Private
private extension MonthAbbrevAndDayNumberLargeView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    func updateDate(configuration: WidgetCalendarCongifuration) {
        let date = Date()
        
        let weekdayAttrs = TextAttributes()
            .textColor(configuration.fontColor)
            .font(configuration.font.uiFont(baseSize: {
                switch metrics {
                case .small:
                    return 28.scale
                case .large:
                    return 56.scale
                }
            }()))
            .textAlignment(.center)
       let weekday = weekdayFormatter.string(from: date).attributed(with: weekdayAttrs)
        
        let monthAttrs = TextAttributes()
            .textColor(configuration.fontColor.withAlphaComponent(0.6))
            .font(configuration.font.uiFont(baseSize: {
                switch metrics {
                case .small:
                    return 28.scale
                case .large:
                    return 56.scale
                }
            }()))
            .textAlignment(.center)
        let month = monthFormatter.string(from: date).attributed(with: monthAttrs)
        
        let weekdayMonth = NSMutableAttributedString()
        weekdayMonth.append(weekday)
        weekdayMonth.append(" ".attributed(with: weekdayAttrs))
        weekdayMonth.append(month)
        weekdayMonthLabel.attributedText = weekdayMonth
        
        let dayAttrs = TextAttributes()
            .textColor(configuration.fontColor)
            .font(configuration.font.uiFont(baseSize: {
                switch metrics {
                case .small:
                    return 70.scale
                case .large:
                    return 140.scale
                }
            }()))
            .textAlignment(.center)
        dayLabel.attributedText = dayFormatter.string(from: date).attributed(with: dayAttrs)
    }
    
    func updateBackground(configuration: WidgetCalendarCongifuration) {
        switch configuration.background {
        case .color(let codableColor):
            backgroundImageView.isHidden = true
            backgroundImageView.image = nil

            backgroundColorView.backgroundColor = codableColor.wrappedValue
            
            backgroundColorView.gradientLayer.colors = nil
        case .gradient(let codableColors):
            backgroundImageView.isHidden = true
            backgroundImageView.image = nil

            backgroundColorView.backgroundColor = .clear
            
            backgroundColorView.gradientLayer.colors = codableColors.map { $0.wrappedValue.cgColor }
            backgroundColorView.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            backgroundColorView.gradientLayer.endPoint   = CGPoint(x: 0.5, y: 1.0)
            backgroundColorView.gradientLayer.locations = [NSNumber(value: 0), NSNumber(value: 1)]
        case .fileName(let fileName):
            backgroundImageView.isHidden = false
            backgroundImageView.image = SharedImageFileStore.shared.loadImage(fileName: fileName)

            backgroundColorView.backgroundColor = .clear
            backgroundColorView.gradientLayer.colors = nil
        case .photoAssetId(let assetId):
            backgroundImageView.isHidden = false
            backgroundImageView.image = nil

            backgroundColorView.backgroundColor = .clear
            backgroundColorView.gradientLayer.colors = nil
            
            PhotoAssetImageLoader.shared.loadImage(
                assetId: assetId,
                targetSize: {
                    let scale = UIScreen.main.scale
                    return CGSize(
                        width: bounds.width * scale,
                        height: bounds.height * scale
                    )
                }()
            ) { [weak self] image in
                self?.backgroundImageView.image = image
            }
        }
    }
}

// MARK: Make constraints
private extension MonthAbbrevAndDayNumberLargeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundColorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundColorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundColorView.topAnchor.constraint(equalTo: topAnchor),
            backgroundColorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            weekdayMonthLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            weekdayMonthLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            weekdayMonthLabel.topAnchor.constraint(equalTo: container.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            dayLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            dayLabel.topAnchor.constraint(equalTo: weekdayMonthLabel.bottomAnchor),
            dayLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension MonthAbbrevAndDayNumberLargeView {
    func makeBackgroundColorView() -> GradientView {
        let view = GradientView()
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBackgroundImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
