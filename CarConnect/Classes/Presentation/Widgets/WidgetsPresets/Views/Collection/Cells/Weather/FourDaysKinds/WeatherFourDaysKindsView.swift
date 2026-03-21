//
//  WeatherFourDaysKindsView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 20.03.2026.
//

import UIKit

final class WeatherFourDaysKindsView: UIView {
    enum Metrics {
        case small, large
    }
    
    lazy var day1View = makeItemView()
    lazy var day2View = makeItemView()
    lazy var day3View = makeItemView()
    lazy var day4View = makeItemView()
    
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
extension WeatherFourDaysKindsView {
    func setup(configuration: WidgetWeatherConfiguration, daily: [WeatherSummary]) {
        daily.enumerated().forEach { index, weather in
            if index == 0 {
                day1View.setup(configuration: configuration, weather: weather)
            } else if index == 1 {
                day2View.setup(configuration: configuration, weather: weather)
            } else if index == 2 {
                day3View.setup(configuration: configuration, weather: weather)
            } else if index == 3 {
                day4View.setup(configuration: configuration, weather: weather)
            }
        }
    }
}

// MARK: Private
private extension WeatherFourDaysKindsView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension WeatherFourDaysKindsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            day1View.leadingAnchor.constraint(equalTo: leadingAnchor),
            day1View.topAnchor.constraint(equalTo: topAnchor),
            day1View.bottomAnchor.constraint(equalTo: bottomAnchor),
            day1View.widthAnchor.constraint(equalTo: day2View.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            day2View.leadingAnchor.constraint(equalTo: day1View.trailingAnchor, constant: 10.scale),
            day2View.topAnchor.constraint(equalTo: topAnchor),
            day2View.bottomAnchor.constraint(equalTo: bottomAnchor),
            day2View.widthAnchor.constraint(equalTo: day3View.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            day3View.leadingAnchor.constraint(equalTo: day2View.trailingAnchor, constant: 10.scale),
            day3View.topAnchor.constraint(equalTo: topAnchor),
            day3View.bottomAnchor.constraint(equalTo: bottomAnchor),
            day3View.widthAnchor.constraint(equalTo: day4View.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            day4View.leadingAnchor.constraint(equalTo: day3View.trailingAnchor, constant: 10.scale),
            day4View.trailingAnchor.constraint(equalTo: trailingAnchor),
            day4View.topAnchor.constraint(equalTo: topAnchor),
            day4View.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WeatherFourDaysKindsView {
    func makeItemView() -> WeatherFourDaysKindsItemView {
        let view = WeatherFourDaysKindsItemView(metrics: {
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
