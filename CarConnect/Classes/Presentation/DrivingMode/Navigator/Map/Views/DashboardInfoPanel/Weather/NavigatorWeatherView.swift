//
//  NavigatorWeatherView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.05.2026.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

final class NavigatorWeatherView: UIView {
    private lazy var geoLocationAPI = GeoLocationAPI()
    
    private var weatherFetcher: WeatherFetcher?
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
        displayWeatherState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension NavigatorWeatherView {
    func initialize() {
        layer.cornerRadius = 10.landscapeHScale
        
        geoLocationAPI.didChangeAuthorizationStatus = { [weak self] status in
            self?.displayWeatherState(status: status)
        }
    }
    
    func displayWeatherState(status: CLAuthorizationStatus? = nil) {
        let status = status ?? geoLocationAPI.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            display(NavigatorWeatherPreloaderView())
            requestWeatherData()
        case .notDetermined:
            display(NavigatorWeatherNotAvailableView(reason: .locationAccessNeeded))
            requestWeatherData()
        case .denied, .restricted:
            display(NavigatorWeatherNotAvailableView(reason: .locationAccessNeeded))
        @unknown default:
            display(NavigatorWeatherNotAvailableView(reason: .notAvailable))
        }
    }
    
    func requestWeatherData() {
        let weatherFetcher = WeatherFetcher(useDefaultLocation: false, includeDailyForecast: false)
        self.weatherFetcher = weatherFetcher
        
        weatherFetcher.weatherData
            .skip(1)
            .drive(Binder(self) { base, weatherData in
                base.handleWeatherData(weatherData)
            })
            .disposed(by: disposeBag)
    }
    
    func handleWeatherData(_ weatherData: WeatherData?) {
        if let weatherData {
            display(NavigatorWeatherInfoView(weatherData: weatherData))
        } else {
            let reason: NavigatorWeatherNotAvailableView.Reason = {
                switch geoLocationAPI.authorizationStatus() {
                case .denied, .restricted:
                    return .locationAccessNeeded
                default:
                    return .notAvailable
                }
            }()
            display(NavigatorWeatherNotAvailableView(reason: reason))
        }
    }
    
    func display(_ view: UIView) {
        subviews.forEach { $0.removeFromSuperview() }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
