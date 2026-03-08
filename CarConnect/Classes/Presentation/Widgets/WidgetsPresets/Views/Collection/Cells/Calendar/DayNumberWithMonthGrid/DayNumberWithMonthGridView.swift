//
//  DayNumberWithMonthGridView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 06.03.2026.
//

import UIKit

final class DayNumberWithMonthGridView: CalendarStyleView {
    enum Metrics {
        case small, large
    }
    
    lazy var backgroundColorView = makeBackgroundColorView()
    lazy var backgroundImageView = makeBackgroundImageView()
    lazy var container = makeContainer()
    lazy var dayLabel = makeLabel()
    lazy var weekdayLabel = makeLabel()
    lazy var monthLabel = makeLabel()
    lazy var calendarWeekRowView = makeCalendarWeekRowView()
    
    private lazy var weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "EEE"
        return formatter
    }()
    
    private lazy var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "d"
        return formatter
    }()
    
    private lazy var monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "MMMM"
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
        let date = Date()
        
        let dayFontSize: CGFloat = {
            switch metrics {
            case .small:
                return 50.scale
            case .large:
                return 100.scale
            }
        }()
        let dayAttrs = TextAttributes()
            .textColor(configuration.fontColor)
            .font(configuration.font.uiFont(baseSize: dayFontSize))
            .textAlignment(.center)
        dayLabel.attributedText = dayFormatter.string(from: date).attributed(with: dayAttrs)
        
        let weekdayFontSize: CGFloat = {
            switch metrics {
            case .small:
                return 12.scale
            case .large:
                return 24.scale
            }
        }()
        
        let weekdayAttrs = TextAttributes()
            .textColor(configuration.fontColor)
            .font(configuration.font.uiFont(baseSize: weekdayFontSize))
            .textAlignment(.left)
        weekdayLabel.attributedText = weekdayFormatter.string(from: date).attributed(with: weekdayAttrs)
        
        let monthAttrs = TextAttributes()
            .textColor(configuration.fontColor.withAlphaComponent(0.6))
            .font(configuration.font.uiFont(baseSize: weekdayFontSize))
            .textAlignment(.left)
        monthLabel.attributedText = monthFormatter.string(from: date).attributed(with: monthAttrs)
        
        calendarWeekRowView.setup(date: date, configuration: configuration)
        updateBackground(configuration: configuration)
    }
}

// MARK: Private
private extension DayNumberWithMonthGridView {
    func initialize() {
        backgroundColor = UIColor.clear
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
private extension DayNumberWithMonthGridView {
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
        
        let insets: CGFloat = {
            switch metrics {
            case .small:
                return 10.scale
            case .large:
                return 20.scale
            }
        }()
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets),
            container.topAnchor.constraint(equalTo: topAnchor, constant: insets),
            container.heightAnchor.constraint(equalToConstant: {
                switch metrics {
                case .small:
                    return 87.scale
                case .large:
                    return 180.scale
                }
            }())
        ])
        
        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: container.leadingAnchor, constant: {
                switch metrics {
                case .small:
                    return 40.scale
                case .large:
                    return 83.scale
                }
            }()),
            dayLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            weekdayLabel.leadingAnchor.constraint(equalTo: container.centerXAnchor, constant: {
                switch metrics {
                case .small:
                    return 5.scale
                case .large:
                    return 10.scale
                }
            }()),
            weekdayLabel.bottomAnchor.constraint(equalTo: container.centerYAnchor, constant: {
                switch metrics {
                case .small:
                    return -1.scale
                case .large:
                    return -2.scale
                }
            }())
        ])
        
        NSLayoutConstraint.activate([
            monthLabel.leadingAnchor.constraint(equalTo: container.centerXAnchor, constant: {
                switch metrics {
                case .small:
                    return 5.scale
                case .large:
                    return 10.scale
                }
            }()),
            monthLabel.topAnchor.constraint(equalTo: container.centerYAnchor, constant: {
                switch metrics {
                case .small:
                    return 1.scale
                case .large:
                    return 2.scale
                }
            }())
        ])
        
        NSLayoutConstraint.activate([
            calendarWeekRowView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets),
            calendarWeekRowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets),
            calendarWeekRowView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets),
            calendarWeekRowView.heightAnchor.constraint(equalToConstant: {
                switch metrics {
                case .small:
                    return 46.scale
                case .large:
                    return 96.scale
                }
            }())
        ])
    }
}

// MARK: Lazy initialization
private extension DayNumberWithMonthGridView {
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
        view.layer.cornerRadius = 8.scale
        view.layer.masksToBounds = true
        view.backgroundColor = Appearance.color_FFFFFF.withAlphaComponent(0.04)
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
    
    func makeCalendarWeekRowView() -> CalendarWeekRowView {
        let view = CalendarWeekRowView(metrics: {
            switch metrics {
            case .small:
                return .small
            case .large:
                return .large
            }
        }())
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
