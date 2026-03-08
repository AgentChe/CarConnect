//
//  MonthDayAndWeekdayTextView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 07.03.2026.
//

import UIKit

final class MonthDayAndWeekdayTextView: CalendarStyleView {
    enum Metrics {
        case small, large
    }
    
    lazy var backgroundColorView = makeBackgroundColorView()
    lazy var backgroundImageView = makeBackgroundImageView()
    lazy var topGlowView = makeTopGlowView()
    lazy var bottomGlowView = makeBottomGlowView()
    lazy var monthDayLabel = makeLabel()
    lazy var weekdayLabel = makeLabel()
    
    private lazy var weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "EEEE"
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
private extension MonthDayAndWeekdayTextView {
    func initialize() {
        backgroundColor = UIColor.clear
        layer.masksToBounds = true
    }
    
    func updateDate(configuration: WidgetCalendarCongifuration) {
        let date = Date()
        
        let dayMonthAttrs = TextAttributes()
            .textColor(configuration.fontColor)
            .font(configuration.font.uiFont(baseSize: {
                switch metrics {
                case .small:
                    return 42.scale
                case .large:
                    return 84.scale
                }
            }()))
            .textAlignment(.left)
        let month = monthFormatter.string(from: date).attributed(with: dayMonthAttrs)
        let day = dayFormatter.string(from: date).attributed(with: dayMonthAttrs)
        
        let monthDay = NSMutableAttributedString()
        monthDay.append(month)
        monthDay.append(" ".attributed(with: dayMonthAttrs))
        monthDay.append(day)
        monthDayLabel.attributedText = monthDay
        
        let weekdayAttrs = TextAttributes()
            .textColor(configuration.fontColor.withAlphaComponent(0.8))
            .font(configuration.font.uiFont(baseSize: {
                switch metrics {
                case .small:
                    return 22.scale
                case .large:
                    return 44.scale
                }
            }()))
            .textAlignment(.left)
        weekdayLabel.attributedText = weekdayFormatter.string(from: date).attributed(with: weekdayAttrs)
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
private extension MonthDayAndWeekdayTextView {
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
        
        let glowInsets: CGFloat = {
            switch metrics {
            case .small:
                return 20.scale
            case .large:
                return 40.scale
            }
        }()
        
        let glowSize: CGFloat = {
            switch metrics {
            case .small:
                return 160.scale
            case .large:
                return 320.scale
            }
        }()
        
        NSLayoutConstraint.activate([
            topGlowView.centerXAnchor.constraint(equalTo: trailingAnchor, constant: -glowInsets),
            topGlowView.centerYAnchor.constraint(equalTo: topAnchor, constant: glowInsets),
            topGlowView.widthAnchor.constraint(equalToConstant: glowSize),
            topGlowView.heightAnchor.constraint(equalToConstant: glowSize)
        ])
        
        NSLayoutConstraint.activate([
            bottomGlowView.centerXAnchor.constraint(equalTo: leadingAnchor, constant: glowInsets),
            bottomGlowView.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -glowInsets),
            bottomGlowView.widthAnchor.constraint(equalToConstant: glowSize),
            bottomGlowView.heightAnchor.constraint(equalToConstant: glowSize)
        ])
        
        let insets: CGFloat = {
            switch metrics {
            case .small:
                return 16.scale
            case .large:
                return 32.scale
            }
        }()
        
        NSLayoutConstraint.activate([
            monthDayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets),
            monthDayLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets),
            monthDayLabel.topAnchor.constraint(equalTo: topAnchor, constant: insets)
        ])
        
        NSLayoutConstraint.activate([
            weekdayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets),
            weekdayLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets),
            weekdayLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets)
        ])
    }
}

// MARK: Lazy initialization
private extension MonthDayAndWeekdayTextView {
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
    
    func makeTopGlowView() -> GradientView {
        let view = GradientView()
        view.backgroundColor = .clear
        view.gradientLayer.type = .radial
        view.gradientLayer.colors = [
            Appearance.color_4178F6.withAlphaComponent(0.42).cgColor,
            Appearance.color_4178F6.withAlphaComponent(0.16).cgColor,
            Appearance.color_4178F6.withAlphaComponent(0.0).cgColor
        ]
        view.gradientLayer.locations = [0.0, 0.45, 1.0]
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        view.gradientLayer.endPoint = CGPoint(x: 0, y: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBottomGlowView() -> GradientView {
        let view = GradientView()
        view.backgroundColor = .clear
        view.gradientLayer.type = .radial
        view.gradientLayer.colors = [
            Appearance.color_DB7690.withAlphaComponent(0.42).cgColor,
            Appearance.color_DB7690.withAlphaComponent(0.16).cgColor,
            Appearance.color_DB7690.withAlphaComponent(0.0).cgColor
        ]
        view.gradientLayer.locations = [0.0, 0.45, 1.0]
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        view.gradientLayer.endPoint = CGPoint(x: 1.0, y: 0)
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
