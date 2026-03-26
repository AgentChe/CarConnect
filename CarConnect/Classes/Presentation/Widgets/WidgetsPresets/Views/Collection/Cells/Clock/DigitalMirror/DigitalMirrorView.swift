//
//  DigitalMirrorView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 25.03.2026.
//

import UIKit

final class DigitalMirrorView: ClockStyleView {
    enum Metrics {
        case small, large
    }
    
    lazy var backgroundColorView = makeBackgroundColorView()
    lazy var backgroundImageView = makeBackgroundImageView()
    lazy var weekdayLabel = makeTopLabels()
    lazy var timeFormatLabel = makeTopLabels()
    lazy var container = makeContainer()
    lazy var hoursAgoLabel = makeTimeLabel()
    lazy var minutesAgoLabel = makeTimeLabel()
    lazy var currentHoursLabel = makeTimeLabel()
    lazy var currentMinutesLabel = makeTimeLabel()
    lazy var hoursLaterLabel = makeTimeLabel()
    lazy var minutesLaterLabel = makeTimeLabel()
    lazy var gradientView = makeGradientView()
    
    private lazy var weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    private lazy var amPmFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter
    }()
    private lazy var hours24Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter
    }()
    private lazy var hours12Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh"
        return formatter
    }()
    private lazy var minutesFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
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
    
    override func setup(configuration: WidgetClockConfiguration) {
        updateDateTime(configuration: configuration)
        updateBackground(configuration: configuration)
    }
}

// MARK: Private
private extension DigitalMirrorView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    func updateDateTime(configuration: WidgetClockConfiguration) {
        let date = Date()
        let minuteAgoDate = Calendar.current.date(byAdding: .minute, value: -1, to: date) ?? date
        let minuteLaterDate = Calendar.current.date(byAdding: .minute, value: 1, to: date) ?? date
        
        let topLabelsFontSize: CGFloat = {
            switch metrics {
            case .small:
                return 21.scale
            case .large:
                return 42.scale
            }
        }()
        
        let weekday: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(configuration.textColor.wrappedValue)
                .font(configuration.font.uiFont(baseSize: topLabelsFontSize))
                .textAlignment(.left)
            
            let weekday = weekdayFormatter.string(from: date)
            return weekday.attributed(with: attrs)
        }()
        weekdayLabel.attributedText = weekday
        
        let timeFormat: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(configuration.textColor.wrappedValue)
                .font(configuration.font.uiFont(baseSize: topLabelsFontSize))
                .textAlignment(.right)
            
            switch configuration.timeFormat {
            case .twentyFourHour:
                return "".attributed(with: attrs)
            case .twelveHour:
                return amPmFormatter.string(from: date).attributed(with: attrs)
            }
        }()
        timeFormatLabel.attributedText = timeFormat
        
        let currentTimeAttrs = TextAttributes()
            .textColor(configuration.textColor.wrappedValue)
            .font(configuration.font.uiFont(baseSize: {
                switch metrics {
                case .small:
                    return 40.scale
                case .large:
                    return 80.scale
                }
            }()))
            .textAlignment(.center)
        let notCurrentTimeAttrs = TextAttributes()
            .textColor(configuration.textColor.wrappedValue)
            .font(configuration.font.uiFont(baseSize: {
                switch metrics {
                case .small:
                    return 25.scale
                case .large:
                    return 50.scale
                }
            }()))
        
        let hoursFormatter: DateFormatter = {
            switch configuration.timeFormat {
            case .twelveHour:
                return hours12Formatter
            case .twentyFourHour:
                return hours24Formatter
            }
        }()
        
        let hoursAgo = hoursFormatter.string(from: minuteAgoDate).attributed(with: notCurrentTimeAttrs)
        hoursAgoLabel.attributedText = hoursAgo
        
        let minutesAgo = minutesFormatter.string(from: minuteAgoDate).attributed(with: notCurrentTimeAttrs)
        minutesAgoLabel.attributedText = minutesAgo
        
        let currentHours = hoursFormatter.string(from: date).attributed(with: currentTimeAttrs)
        currentHoursLabel.attributedText = currentHours
        
        let currentMinutes = minutesFormatter.string(from: date).attributed(with: currentTimeAttrs)
        currentMinutesLabel.attributedText = currentMinutes
        
        let hoursLater = hoursFormatter.string(from: minuteLaterDate).attributed(with: notCurrentTimeAttrs)
        hoursLaterLabel.attributedText = hoursLater
        
        let minutesLater = minutesFormatter.string(from: minuteLaterDate).attributed(with: notCurrentTimeAttrs)
        minutesLaterLabel.attributedText = minutesLater
    }
    
    func updateBackground(configuration: WidgetClockConfiguration) {
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
private extension DigitalMirrorView {
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
        
        let topLabelsInset: CGFloat = {
            switch metrics {
            case .small:
                return 10.scale
            case .large:
                return 20.scale
            }
        }()
        
        NSLayoutConstraint.activate([
            weekdayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: topLabelsInset),
            weekdayLabel.topAnchor.constraint(equalTo: topAnchor, constant: topLabelsInset)
        ])
        
        NSLayoutConstraint.activate([
            timeFormatLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -topLabelsInset),
            timeFormatLabel.centerYAnchor.constraint(equalTo: weekdayLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor, constant: {
                switch metrics {
                case .small:
                    return 35.scale
                case .large:
                    return 70.scale
                }
            }()),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        let notCurrentTimeInset: CGFloat = {
            switch metrics {
            case .small:
                return 25.scale
            case .large:
                return 50.scale
            }
        }()
        
        let currentTimeInset: CGFloat = {
            switch metrics {
            case .small:
                return 15.scale
            case .large:
                return 30.scale
            }
        }()
        
        NSLayoutConstraint.activate([
            hoursAgoLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: notCurrentTimeInset),
            hoursAgoLabel.bottomAnchor.constraint(equalTo: currentHoursLabel.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            minutesAgoLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -notCurrentTimeInset),
            minutesAgoLabel.bottomAnchor.constraint(equalTo: currentMinutesLabel.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            currentHoursLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: currentTimeInset),
            currentHoursLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            currentMinutesLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -currentTimeInset),
            currentMinutesLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            hoursLaterLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: notCurrentTimeInset),
            hoursLaterLabel.topAnchor.constraint(equalTo: currentHoursLabel.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            minutesLaterLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -notCurrentTimeInset),
            minutesLaterLabel.topAnchor.constraint(equalTo: currentMinutesLabel.bottomAnchor)
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
private extension DigitalMirrorView {
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
    
    func makeTopLabels() -> UILabel {
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
    
    func makeTimeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
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
}
