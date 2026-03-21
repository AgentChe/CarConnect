//
//  WeatherFourDaysKindsItemView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 20.03.2026.
//

import UIKit

final class WeatherFourDaysKindsItemView: UIView {
    enum Metrics {
        case small, large
    }
    
    lazy var kindView = makeKindView()
    lazy var temperatureLabel = makeLabel()
    lazy var dayLabel = makeLabel()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WeatherFourDaysKindsItemView {
    func setup(configuration: WidgetWeatherConfiguration, weather: WeatherSummary) {
        kindView.setup(icon: weather.condition)
        
        let temperature: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(configuration.textColor)
                .font(configuration.font.uiFont(baseSize: 12.scale))
                .textAlignment(.center)
            let temperature: String = {
                let temperature = weather.temperature
                
                switch configuration.temperatureType {
                case .celsius:
                    return "\(Int(temperature.celsius.rounded()))"
                case .fahrenheit:
                    return "\(Int(temperature.fahrenheit.rounded()))"
                }
            }()
            return temperature.attributed(with: attrs)
        }()
        temperatureLabel.attributedText = temperature
        
        let day: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(configuration.textColor)
                .font(configuration.font.uiFont(baseSize: 10.scale))
                .textAlignment(.center)
            return dateFormatter.string(from: weather.date).attributed(with: attrs)
        }()
        dayLabel.attributedText = day
    }
}

// MARK: Private
private extension WeatherFourDaysKindsItemView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension WeatherFourDaysKindsItemView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            kindView.widthAnchor.constraint(equalToConstant: {
                switch metrics {
                case .small:
                    return 18.scale
                case .large:
                    return 18.scale
                }
            }()),
            kindView.heightAnchor.constraint(equalToConstant: {
                switch metrics {
                case .small:
                    return 18.scale
                case .large:
                    return 18.scale
                }
            }()),
            kindView.topAnchor.constraint(equalTo: topAnchor),
            kindView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            temperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            temperatureLabel.bottomAnchor.constraint(equalTo: dayLabel.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            dayLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            dayLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WeatherFourDaysKindsItemView {
    func makeKindView() -> WeatherKindImageView {
        let view = WeatherKindImageView()
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
