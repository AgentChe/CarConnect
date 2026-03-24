//
//  WeatherFetcher.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 20.03.2026.
//

import RxSwift
import RxCocoa

final class WeatherFetcher {
    private lazy var weatherAPI = WeatherAPI()
    private lazy var geoLocationAPI = GeoLocationAPI()
    
    private let disposeBag = DisposeBag()
    
    private let trigger = BehaviorRelay<WeatherData?>(value: nil)
    
    var weatherData: Driver<WeatherData?> {
        trigger.asDriver()
    }
    
    init(location: Location) {
        Observable<WeatherData?>.create { [weak self] observer in
            guard let self else {
                observer.onNext(nil)
                observer.onCompleted()
                return Disposables.create()
            }
            
            let task = Task {
                let weather = try? await self.weatherAPI.fetchWeather(location: location)
                
                if !Task.isCancelled {
                    observer.onNext(weather)
                    observer.onCompleted()
                }
            }
            
            return Disposables.create {
                task.cancel()
            }
        }
        .asDriver(onErrorJustReturn: nil)
        .drive(onNext: { [weak self] weatherData in
            self?.trigger.accept(weatherData)
        })
        .disposed(by: disposeBag)
    }
    
    init() {
        Single<Location>
            .create { [weak self] single in
                guard let self else { return Disposables.create() }
                
                self.geoLocationAPI.requestMyLocation { location in
                    single(.success(location ?? Location.newYork()))
                }
                
                return Disposables.create()
            }
            .asDriver(onErrorDriveWith: .never())
            .flatMapLatest { [weak self] location -> Driver<WeatherData?> in
                Observable<WeatherData?>.create { observer in
                    guard let self else {
                        observer.onNext(nil)
                        observer.onCompleted()
                        return Disposables.create()
                    }
                    
                    let task = Task {
                        let weather = try? await self.weatherAPI.fetchWeather(location: location)
                        
                        if !Task.isCancelled {
                            observer.onNext(weather)
                            observer.onCompleted()
                        }
                    }
                    
                    return Disposables.create {
                        task.cancel()
                    }
                }
                .asDriver(onErrorJustReturn: nil)
            }
            .drive(onNext: { [weak self] weatherData in
                self?.trigger.accept(weatherData)
            })
            .disposed(by: disposeBag)
    }
}
