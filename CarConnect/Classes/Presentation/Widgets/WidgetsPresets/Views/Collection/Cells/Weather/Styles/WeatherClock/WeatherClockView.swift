//
//  WeatherClockView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 18.03.2026.
//

import UIKit
 
final class WeatherClockView: WeatherStyleView {
    enum Metrics {
        case small, large
    }
    
    lazy var backgroundView = makeBackgroundView()
    lazy var timeLabel = makeTimeLabel()
    lazy var dateContainer = makeDateContainer()
    lazy var dateLabel = makeDateLabel()
    lazy var dateSeparator = makeDateSeparator()
    lazy var weekdayLabel = makeDateLabel()
    lazy var temperatureContainer = makeTemperatureContainer()
    lazy var kindIconView = makeKindView()
    lazy var temperatureLabel = makeTemperatureLabel()
    
    private lazy var twelveHourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
    private lazy var twentyFourHourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    private lazy var weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    
    private let metrics: Metrics
    
    init(metrics: Metrics) {
        self.metrics = metrics
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup(configuration: WidgetWeatherConfiguration, weatherData: WeatherData) {
        backgroundView.setup(background: weatherData.current.condition)
        kindIconView.setup(icon: weatherData.current.condition)
        
        let date = Date()
        
        let time: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(configuration.textColor)
                .font(configuration.font.uiFont(baseSize: {
                    switch metrics {
                    case .small:
                        return 32.scale
                    case .large:
                        return 32.scale
                    }
                }()))
            let formatter: DateFormatter = {
                switch configuration.timeFormat {
                case .twelveHour:
                    return twelveHourFormatter
                case .twentyFourHour:
                    return twentyFourHourFormatter
                }
            }()
            
            return formatter.string(from: date).attributed(with: attrs)
        }()
        timeLabel.attributedText = time
        
        let dateFormatted: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(configuration.textColor)
                .font(configuration.font.uiFont(baseSize: {
                    switch metrics {
                    case .small:
                        return 14.scale
                    case .large:
                        return 14.scale
                    }
                }()))
            
            return dateFormatter.string(from: date).attributed(with: attrs)
        }()
        dateLabel.attributedText = dateFormatted
        
        dateSeparator.backgroundColor = configuration.textColor.withAlphaComponent(0.6)
        
        let weekdayFormatted: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(configuration.textColor)
                .font(configuration.font.uiFont(baseSize: {
                    switch metrics {
                    case .small:
                        return 14.scale
                    case .large:
                        return 14.scale
                    }
                }()))
            
            return weekdayFormatter.string(from: date).attributed(with: attrs)
        }()
        weekdayLabel.attributedText = weekdayFormatted
        
        let temperature: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(configuration.textColor)
                .font(configuration.font.uiFont(baseSize: {
                    switch metrics {
                    case .small:
                        return 32.scale
                    case .large:
                        return 32.scale
                    }
                }()))
                .textAlignment(.left)
            let temperature: String = {
                let temperature = weatherData.current.temperature
                
                switch configuration.temperatureType {
                case .celsius:
                    return "\(Int(temperature.celsius.rounded()))°C"
                case .fahrenheit:
                    return "\(Int(temperature.fahrenheit.rounded()))°F"
                }
            }()
            return temperature.attributed(with: attrs)
        }()
        temperatureLabel.attributedText = temperature
    }
}

// MARK: Private
private extension WeatherClockView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension WeatherClockView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: {
                switch metrics {
                case .small:
                    return 10.scale
                case .large:
                    return 10.scale
                }
            }())
        ])
        
        NSLayoutConstraint.activate([
            dateContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: {
                switch metrics {
                case .small:
                    return 10.scale
                case .large:
                    return 10.scale
                }
            }()),
            dateContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: {
                switch metrics {
                case .small:
                    return -10.scale
                case .large:
                    return -10.scale
                }
            }()),
            dateContainer.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: {
                switch metrics {
                case .small:
                    return 16.scale
                case .large:
                    return 16.scale
                }
            }())
        ])
        
        let dateContainerInsideInsets: CGFloat = {
            switch metrics {
            case .small:
                return 11.scale
            case .large:
                return 11.scale
            }
        }()
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: dateContainer.contentView.leadingAnchor, constant: dateContainerInsideInsets),
            dateLabel.topAnchor.constraint(equalTo: dateContainer.contentView.topAnchor, constant: dateContainerInsideInsets),
            dateLabel.bottomAnchor.constraint(equalTo: dateContainer.contentView.bottomAnchor, constant: -dateContainerInsideInsets)
        ])
        
        NSLayoutConstraint.activate([
            dateSeparator.centerYAnchor.constraint(equalTo: dateContainer.contentView.centerYAnchor),
            dateSeparator.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: {
                switch metrics {
                case .small:
                    return 10.scale
                case .large:
                    return 10.scale
                }
            }()),
            dateSeparator.widthAnchor.constraint(equalToConstant: 1.scale),
            dateSeparator.heightAnchor.constraint(equalToConstant: {
                switch metrics {
                case .small:
                    return 7.scale
                case .large:
                    return 7.scale
                }
            }())
        ])
        
        NSLayoutConstraint.activate([
            weekdayLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: {
                switch metrics {
                case .small:
                    return 22.scale
                case .large:
                    return 22.scale
                }
            }()),
            weekdayLabel.trailingAnchor.constraint(equalTo: dateContainer.contentView.trailingAnchor, constant: -dateContainerInsideInsets),
            weekdayLabel.topAnchor.constraint(equalTo: dateContainer.contentView.topAnchor, constant: dateContainerInsideInsets),
            weekdayLabel.bottomAnchor.constraint(equalTo: dateContainer.contentView.bottomAnchor, constant: -dateContainerInsideInsets)
        ])
        
        NSLayoutConstraint.activate([
            temperatureContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            temperatureContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: {
                switch metrics {
                case .small:
                    return -10.scale
                case .large:
                    return -10.scale
                }
            }())
        ])
        
        let kindSize: CGFloat = {
            switch metrics {
            case .small:
                return 36.scale
            case .large:
                return 36.scale
            }
        }()
        
        NSLayoutConstraint.activate([
            kindIconView.widthAnchor.constraint(equalToConstant: kindSize),
            kindIconView.heightAnchor.constraint(equalToConstant: kindSize),
            kindIconView.centerYAnchor.constraint(equalTo: temperatureContainer.centerYAnchor),
            kindIconView.leadingAnchor.constraint(equalTo: temperatureContainer.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            temperatureLabel.leadingAnchor.constraint(equalTo: temperatureContainer.leadingAnchor, constant: {
                switch metrics {
                case .small:
                    return kindSize + 10.scale
                case .large:
                    return kindSize + 10.scale
                }
            }()),
            temperatureLabel.trailingAnchor.constraint(equalTo: temperatureContainer.trailingAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: temperatureContainer.topAnchor),
            temperatureLabel.bottomAnchor.constraint(equalTo: temperatureContainer.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WeatherClockView {
    func makeBackgroundView() -> WeatherKindImageView {
        let view = WeatherKindImageView()
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTimeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDateContainer() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let view = UIVisualEffectView(effect: blurEffect)
        view.layer.cornerRadius = 8.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDateLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        dateContainer.contentView.addSubview(view)
        return view
    }
    
    func makeDateSeparator() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        dateContainer.contentView.addSubview(view)
        return view
    }
    
    func makeTemperatureContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeKindView() -> WeatherKindImageView {
        let view = WeatherKindImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        temperatureContainer.addSubview(view)
        return view
    }
    
    func makeTemperatureLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        temperatureContainer.addSubview(view)
        return view
    }
}
