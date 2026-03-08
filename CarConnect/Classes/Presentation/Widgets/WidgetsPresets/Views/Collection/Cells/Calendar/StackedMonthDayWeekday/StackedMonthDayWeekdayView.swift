//
//  StackedMonthDayWeekdayView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 07.03.2026.
//

import UIKit

final class StackedMonthDayWeekdayView: CalendarStyleView {
    enum Metrics {
        case small, large
    }
    
    lazy var backgroundColorView = makeBackgroundColorView()
    lazy var backgroundImageView = makeBackgroundImageView()
    lazy var monthLabel = makeMonthLabel()
    lazy var container = makeContainer()
    lazy var yesterdayLabel = makeLabel()
    lazy var todayLabel = makeLabel()
    lazy var tomorrowLabel = makeLabel()
    lazy var gradientView = makeGradientView()
    
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
private extension StackedMonthDayWeekdayView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    func updateDate(configuration: WidgetCalendarCongifuration) {
        let date = Date()
        
        let monthAttrs = TextAttributes()
            .textColor(configuration.fontColor)
            .font(configuration.font.uiFont(baseSize: {
                switch metrics {
                case .small:
                    return 24.scale
                case .large:
                    return 48.scale
                }
            }()))
            .textAlignment(.center)
        let month = monthFormatter.string(from: date)
        monthLabel.attributedText = month.attributed(with: monthAttrs)
        
        let notTodayAttrs = TextAttributes()
            .textColor(configuration.fontColor)
            .font(configuration.font.uiFont(baseSize: {
                switch metrics {
                case .small:
                    return 30.scale
                case .large:
                    return 60.scale
                }
            }()))
            .textAlignment(.center)
        
        let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: date) ?? date
        let yesterdayString = dayFormatter.string(from: yesterdayDate)
        yesterdayLabel.attributedText = yesterdayString.attributed(with: notTodayAttrs)
        
        let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? date
        let tomorrowString = dayFormatter.string(from: tomorrowDate)
        tomorrowLabel.attributedText = tomorrowString.attributed(with: notTodayAttrs)
        
        let todayAttrs = TextAttributes()
            .textColor(configuration.fontColor)
            .font(configuration.font.uiFont(baseSize: {
                switch metrics {
                case .small:
                    return 40.scale
                case .large:
                    return 80.scale
                }
            }()))
            .textAlignment(.center)
        let today = dayFormatter.string(from: date)
        let weekday = weekdayFormatter.string(from: date)
        
        let todayWeekdayResult = NSMutableAttributedString()
        todayWeekdayResult.append(today.attributed(with: todayAttrs))
        todayWeekdayResult.append(" ".attributed(with: todayAttrs))
        todayWeekdayResult.append(weekday.attributed(with: todayAttrs))
        
        todayLabel.attributedText = todayWeekdayResult
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
private extension StackedMonthDayWeekdayView {
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
            monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: {
                switch metrics {
                case .small:
                    return 10.scale
                case .large:
                    return 20.scale
                }
            }()),
            monthLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor, constant: {
                switch metrics {
                case .small:
                    return 39.scale
                case .large:
                    return 80.scale
                }
            }()),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            yesterdayLabel.bottomAnchor.constraint(equalTo: todayLabel.topAnchor),
            yesterdayLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            todayLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            todayLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tomorrowLabel.topAnchor.constraint(equalTo: todayLabel.bottomAnchor),
            tomorrowLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            gradientView.topAnchor.constraint(equalTo: container.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension StackedMonthDayWeekdayView {
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
    
    func makeMonthLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeGradientView() -> GradientView {
        let view = GradientView()
        view.backgroundColor = UIColor.clear
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        view.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.gradientLayer.locations = [0, 0.15, 0.5, 0.85, 1]
        view.gradientLayer.colors = [
            Appearance.color_353844.cgColor,
            Appearance.color_343743.withAlphaComponent(0.9).cgColor,
            Appearance.color_30343F.withAlphaComponent(0).cgColor,
            Appearance.color_2D303A.withAlphaComponent(0.9).cgColor,
            Appearance.color_2C2F39.cgColor
        ]
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
