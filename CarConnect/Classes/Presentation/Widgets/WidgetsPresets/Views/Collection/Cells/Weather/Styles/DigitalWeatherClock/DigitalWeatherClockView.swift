//
//  DigitalWeatherClockView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 18.03.2026.
//

import UIKit
 
final class DigitalWeatherClockView: WeatherStyleView {
    enum Metrics {
        case small, large
    }
    
    lazy var todayLabel = makeLabel()
    lazy var temperatureLabel = makeLabel()
    lazy var timeContainer = makeTimeContainer()
    lazy var timeLabel = makeTimeLabel()
    
    private let metrics: Metrics
    
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
        let date = Date()
        
        backgroundColor = backgroundColor(celsius: weatherData.current.temperature.celsius)
        
        let today: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(configuration.textColor)
                .font(configuration.font.uiFont(baseSize: {
                    switch metrics {
                    case .small:
                        return 28.scale
                    case .large:
                        return 28.scale
                    }
                }()))
                .textAlignment(.left)
            return "WidgetsPresets.Weather.Today".localized.attributed(with: attrs)
        }()
        todayLabel.attributedText = today
        
        let temperature: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(configuration.textColor)
                .font(configuration.font.uiFont(baseSize: {
                    switch metrics {
                    case .small:
                        return 40.scale
                    case .large:
                        return 40.scale
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
        
        let time: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(configuration.textColor)
                .font(configuration.font.uiFont(baseSize: {
                    switch metrics {
                    case .small:
                        return 28.scale
                    case .large:
                        return 28.scale
                    }
                }()))
                .textAlignment(.center)
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
    }
}

// MARK: Private
private extension DigitalWeatherClockView {
    func initialize() {
        backgroundColor = UIColor.clear
        layer.cornerRadius = 10.scale
        layer.masksToBounds = true
    }
    
    func backgroundColor(celsius: Double) -> UIColor {
        let points: [(temp: Double, color: UIColor)] = [
            (-30, UIColor(hex: "#1E3A8A")), // deep cold blue
            (-10, UIColor(hex: "#3B82F6")), // cold blue
            (0,   UIColor(hex: "#7DD3FC")), // icy light blue
            (10,  UIColor(hex: "#CFEF9D")), // soft fresh green-yellow
            (20,  UIColor(hex: "#FFD166")), // warm yellow
            (27,  UIColor(hex: "#FF7B1A")), // required color
            (35,  UIColor(hex: "#FF5A36"))  // hot orange-red
        ]
        
        if celsius <= points[0].temp { return points[0].color }
        if celsius >= points[points.count - 1].temp { return points[points.count - 1].color }
        
        for i in 0..<(points.count - 1) {
            let left = points[i]
            let right = points[i + 1]
            
            if celsius >= left.temp && celsius <= right.temp {
                let progress = (celsius - left.temp) / (right.temp - left.temp)
                return UIColor.interpolate(from: left.color, to: right.color, progress: progress)
            }
        }
        
        return UIColor(hex: "#FF7B1A")
    }
}

// MARK: Make constraints
private extension DigitalWeatherClockView {
    func makeConstraints() {
        let insets: CGFloat = {
            switch metrics {
            case .small:
                return 12.scale
            case .large:
                return 12.scale
            }
        }()
        
        NSLayoutConstraint.activate([
            todayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets),
            todayLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets),
            todayLabel.topAnchor.constraint(equalTo: topAnchor, constant: insets)
        ])
        
        NSLayoutConstraint.activate([
            temperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets),
            temperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets),
            temperatureLabel.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: {
                switch metrics {
                case .small:
                    return 2.scale
                case .large:
                    return 2.scale
                }
            }())
        ])
        
        NSLayoutConstraint.activate([
            timeContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets),
            timeContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets),
            timeContainer.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: {
                switch metrics {
                case .small:
                    return 5.scale
                case .large:
                    return 5.scale
                }
            }())
        ])
        
        let timeInsets: CGFloat = {
            switch metrics {
            case .small:
                return 10.scale
            case .large:
                return 10.scale
            }
        }()
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: timeContainer.leadingAnchor, constant: timeInsets),
            timeLabel.trailingAnchor.constraint(equalTo: timeContainer.trailingAnchor, constant: -timeInsets),
            timeLabel.topAnchor.constraint(equalTo: timeContainer.topAnchor, constant: timeInsets),
            timeLabel.bottomAnchor.constraint(equalTo: timeContainer.bottomAnchor, constant: -timeInsets)
        ])
    }
}

// MARK: Lazy initialization
private extension DigitalWeatherClockView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTimeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.color_FFFFFF.withAlphaComponent(0.12)
        view.layer.cornerRadius = 8.scale
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.color_FFFFFF.cgColor
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
}

// MARK: Additional
private extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = (
                (int >> 16) & 0xFF,
                (int >> 8) & 0xFF,
                int & 0xFF
            )
        default:
            (r, g, b) = (0, 0, 0)
        }
        
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: 1
        )
    }
    
    static func interpolate(from: UIColor, to: UIColor, progress: Double) -> UIColor {
        let p = max(0, min(1, progress))
        
        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var a1: CGFloat = 0
        
        var r2: CGFloat = 0
        var g2: CGFloat = 0
        var b2: CGFloat = 0
        var a2: CGFloat = 0
        
        from.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        to.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return UIColor(
            red: r1 + (r2 - r1) * CGFloat(p),
            green: g1 + (g2 - g1) * CGFloat(p),
            blue: b1 + (b2 - b1) * CGFloat(p),
            alpha: a1 + (a2 - a1) * CGFloat(p)
        )
    }
}
