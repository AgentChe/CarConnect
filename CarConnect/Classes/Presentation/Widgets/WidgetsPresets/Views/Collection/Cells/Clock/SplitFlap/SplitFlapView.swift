//
//  SplitFlapView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 25.03.2026.
//

import UIKit

final class SplitFlapView: ClockStyleView {
    enum Metrics {
        case small, large
    }
    
    lazy var backgroundColorView = makeBackgroundColorView()
    lazy var backgroundImageView = makeBackgroundImageView()
    lazy var weekdayLabel = makeTopLabels()
    lazy var timeFormatLabel = makeTopLabels()
    lazy var hoursView = makeItemView()
    lazy var divider = makeDivider()
    lazy var minutesView = makeItemView()
    
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
private extension SplitFlapView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    func updateDateTime(configuration: WidgetClockConfiguration) {
        let date = Date()
        
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
        
        let timeAttrs = TextAttributes()
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
        
        let hoursFormatter: DateFormatter = {
            switch configuration.timeFormat {
            case .twelveHour:
                return hours12Formatter
            case .twentyFourHour:
                return hours24Formatter
            }
        }()
        
        let currentHours = hoursFormatter.string(from: date).attributed(with: timeAttrs)
        hoursView.setup(title: currentHours)
        
        let currentMinutes = minutesFormatter.string(from: date).attributed(with: timeAttrs)
        minutesView.setup(title: currentMinutes)
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
private extension SplitFlapView {
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
        
        let inset: CGFloat = {
            switch metrics {
            case .small:
                return 10.scale
            case .large:
                return 20.scale
            }
        }()
        
        NSLayoutConstraint.activate([
            weekdayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            weekdayLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset)
        ])
        
        NSLayoutConstraint.activate([
            timeFormatLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            timeFormatLabel.centerYAnchor.constraint(equalTo: weekdayLabel.centerYAnchor)
        ])
        
        let itemWidth: CGFloat = {
            switch metrics {
            case .small:
                return 69.scale
            case .large:
                return 138.scale
            }
        }()
        
        let itemHeight: CGFloat = {
            switch metrics {
            case .small:
                return 112.scale
            case .large:
                return 224.scale
            }
        }()
        
        NSLayoutConstraint.activate([
            hoursView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            hoursView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
            hoursView.widthAnchor.constraint(equalToConstant: itemWidth),
            hoursView.heightAnchor.constraint(equalToConstant: itemHeight)
        ])
        
        NSLayoutConstraint.activate([
            divider.centerXAnchor.constraint(equalTo: centerXAnchor),
            divider.widthAnchor.constraint(equalToConstant: {
                switch metrics {
                case .small:
                    return 4.scale
                case .large:
                    return 8.scale
                }
            }()),
            divider.heightAnchor.constraint(equalToConstant: {
                switch metrics {
                case .small:
                    return 28.scale
                case .large:
                    return 56.scale
                }
            }()),
            divider.centerYAnchor.constraint(equalTo: hoursView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            minutesView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            minutesView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
            minutesView.widthAnchor.constraint(equalToConstant: itemWidth),
            minutesView.heightAnchor.constraint(equalToConstant: itemHeight)
        ])
    }
}

// MARK: Lazy initialization
private extension SplitFlapView {
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
    
    func makeItemView() -> SplitFlapItemView {
        let view = SplitFlapItemView(metrics: {
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
    
    func makeDivider() -> SplitFlapDividerView {
        let view = SplitFlapDividerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
