//
//  WidgetsPresetsTemplatesCollectionView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 22.02.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class WidgetsPresetsTemplatesCollectionView: UICollectionView {
    private lazy var elements = [WidgetsPresetsTemplatesCollectionElement]()
    
    private lazy var didTapOpenHelperTrigger = PublishRelay<Void>()
    private lazy var didSelectTrigger = PublishRelay<WidgetsPresetsTemplatesCollectionElement>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WidgetsPresetsTemplatesCollectionView {
    func setup(elements: [WidgetsPresetsTemplatesCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didTapOpenHelper: Signal<Void> {
        didTapOpenHelperTrigger.asSignal()
    }
    
    var didSelect: Signal<WidgetsPresetsTemplatesCollectionElement> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension WidgetsPresetsTemplatesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch elements[indexPath.row] {
        case .openHelper:
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsCollectionHelperCell.self), for: indexPath) as! WidgetsPresetsCollectionHelperCell
            cell.didTapOpenHelper = { [weak self] in
                self?.didTapOpenHelperTrigger.accept(Void())
            }
            return cell
        case .textManually(_, let configuration):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateTextManuallyCell.self), for: indexPath) as! WidgetsPresetsTemplateTextManuallyCell
            cell.setup(configuration: configuration)
            return cell
        case .quoteAmbitionDrive(_, let element, let configuration):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateQuoteAmbitionDriveCell.self), for: indexPath) as! WidgetsPresetsTemplateQuoteAmbitionDriveCell
            cell.setup(element: element, configuration: configuration)
            return cell
        case .quoteMindsetGrowth(_, let element, let configuration):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateQuoteMindsetGrowthCell.self), for: indexPath) as! WidgetsPresetsTemplateQuoteMindsetGrowthCell
            cell.setup(element: element, configuration: configuration)
            return cell
        case .quoteLeadershipImpact(_, let element, let configuration):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateQuoteLeadershipImpactCell.self), for: indexPath) as! WidgetsPresetsTemplateQuoteLeadershipImpactCell
            cell.setup(element: element, configuration: configuration)
            return cell
        case .quoteLifeMeaning(_, let element, let configuration):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateQuoteLifeMeaningCell.self), for: indexPath) as! WidgetsPresetsTemplateQuoteLifeMeaningCell
            cell.setup(element: element, configuration: configuration)
            return cell
        case .calendar(_, let configuration):
            switch configuration.style {
            case .monthGrid:
                let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateMonthGridCell.self), for: indexPath) as! WidgetsPresetsTemplateMonthGridCell
                cell.setup(configuration: configuration)
                return cell
            case .weekdayAndDayNumberLarge:
                let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateWeekdayAndDayNumberLargeCell.self), for: indexPath) as! WidgetsPresetsTemplateWeekdayAndDayNumberLargeCell
                cell.setup(configuration: configuration)
                return cell
            case .dayNumberWithMonthGrid:
                let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateDayNumberWithMonthGridCell.self), for: indexPath) as! WidgetsPresetsTemplateDayNumberWithMonthGridCell
                cell.setup(configuration: configuration)
                return cell
            case .monthAbbrevAndDayNumberLarge:
                let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateMonthAbbrevAndDayNumberLargeCell.self), for: indexPath) as! WidgetsPresetsTemplateMonthAbbrevAndDayNumberLargeCell
                cell.setup(configuration: configuration)
                return cell
            case .monthDayAndWeekdayText:
                let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateMonthDayAndWeekdayTextCell.self), for: indexPath) as! WidgetsPresetsTemplateMonthDayAndWeekdayTextCell
                cell.setup(configuration: configuration)
                return cell
            case .stackedMonthDayWeekday:
                let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateStackedMonthDayWeekdayCell.self), for: indexPath) as! WidgetsPresetsTemplateStackedMonthDayWeekdayCell
                cell.setup(configuration: configuration)
                return cell
            }
        case .weather(_, let configuration, let weatherData):
            switch configuration.style {
            case .weatherIconTemperature:
                let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateWeatherIconTemperatureCell.self), for: indexPath) as! WidgetsPresetsTemplateWeatherIconTemperatureCell
                cell.setup(configuration: configuration, weatherData: weatherData)
                return cell
            case .currentWeatherSummary:
                let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateCurrentWeatherSummaryCell.self), for: indexPath) as! WidgetsPresetsTemplateCurrentWeatherSummaryCell
                cell.setup(configuration: configuration, weatherData: weatherData)
                return cell
            case .locationTemperature:
                let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateLocationTemperatureCell.self), for: indexPath) as! WidgetsPresetsTemplateLocationTemperatureCell
                cell.setup(configuration: configuration, weatherData: weatherData)
                return cell
            case .compactWeatherForecast:
                let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateCompactWeatherForecastCell.self), for: indexPath) as! WidgetsPresetsTemplateCompactWeatherForecastCell
                cell.setup(configuration: configuration, weatherData: weatherData)
                return cell
            case .todayTomorrowWeather:
                let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateTodayTomorrowWeatherCell.self), for: indexPath) as! WidgetsPresetsTemplateTodayTomorrowWeatherCell
                cell.setup(configuration: configuration, weatherData: weatherData)
                return cell
            case .weatherClock:
                let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateWeatherClockCell.self), for: indexPath) as! WidgetsPresetsTemplateWeatherClockCell
                cell.setup(configuration: configuration, weatherData: weatherData)
                return cell
            case .weatherConditionForecast:
                let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateWeatherConditionForecastCell.self), for: indexPath) as! WidgetsPresetsTemplateWeatherConditionForecastCell
                cell.setup(configuration: configuration, weatherData: weatherData)
                return cell
            case .digitalWeatherClock:
                let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateDigitalWeatherClockCell.self), for: indexPath) as! WidgetsPresetsTemplateDigitalWeatherClockCell
                cell.setup(configuration: configuration, weatherData: weatherData)
                return cell
            }
        case .clock(_, let configuration):
            switch configuration.style {
            case .digitalStacked:
                let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateDigitalStackedCell.self), for: indexPath) as! WidgetsPresetsTemplateDigitalStackedCell
                cell.setup(configuration: configuration)
                return cell
            case .digitalMirror:
                let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateDigitalMirrorCell.self), for: indexPath) as! WidgetsPresetsTemplateDigitalMirrorCell
                cell.setup(configuration: configuration)
                return cell
            case .digitalClassic:
                let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateDigitalClassicCell.self), for: indexPath) as! WidgetsPresetsTemplateDigitalClassicCell
                cell.setup(configuration: configuration)
                return cell
            case .splitFlap:
                let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateSplitFlapCell.self), for: indexPath) as! WidgetsPresetsTemplateSplitFlapCell
                cell.setup(configuration: configuration)
                return cell
            case .calendarClock:
                let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateCalendarClockCell.self), for: indexPath) as! WidgetsPresetsTemplateCalendarClockCell
                cell.setup(configuration: configuration)
                return cell
            case .analogClock:
                let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateAnalogClockCell.self), for: indexPath) as! WidgetsPresetsTemplateAnalogClockCell
                cell.setup(configuration: configuration)
                return cell
            }
        case .clockAIPreview(_, let configuration):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateClockAIPreviewCell.self), for: indexPath) as! WidgetsPresetsTemplateClockAIPreviewCell
            cell.setup(configuration: configuration, date: Date())
            return cell
        case let .carLogo(_, configuration, isUsersLogo, catalogsCount):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateCarLogoCell.self), for: indexPath) as! WidgetsPresetsTemplateCarLogoCell
            cell.setup(configuration: configuration, isUsersLogo: isUsersLogo, catalogsCount: catalogsCount)
            return cell
        case .aiPhoto(_, let configuration):
            if let configuration {
                let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateAIPhotoCell.self), for: indexPath) as! WidgetsPresetsTemplateAIPhotoCell
                cell.setup(configuration: configuration)
                return cell
            } else {
                return dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplateAIPhotoPlaceholderCell.self), for: indexPath)
            }
        case .photoWithText(_, let configuration):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: WidgetsPresetsTemplatePhotoWithTextCell.self), for: indexPath) as! WidgetsPresetsTemplatePhotoWithTextCell
            cell.setup(configuration: configuration)
            return cell
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension WidgetsPresetsTemplatesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch elements[indexPath.row] {
        case .openHelper:
            return CGSize(width: 343.scale, height: 149.scale)
        default:
            return CGSize(width: 165.scale, height: 165.scale)
        }
    }
}

// MARK: Private
private extension WidgetsPresetsTemplatesCollectionView {
    func initialize() {
        // Text
        register(WidgetsPresetsTemplateQuoteAmbitionDriveCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateQuoteAmbitionDriveCell.self))
        register(WidgetsPresetsTemplateQuoteMindsetGrowthCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateQuoteMindsetGrowthCell.self))
        register(WidgetsPresetsTemplateQuoteLeadershipImpactCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateQuoteLeadershipImpactCell.self))
        register(WidgetsPresetsTemplateQuoteLifeMeaningCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateQuoteLifeMeaningCell.self))
        register(WidgetsPresetsTemplateTextManuallyCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateTextManuallyCell.self))
        
        // Calendar
        register(WidgetsPresetsTemplateMonthGridCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateMonthGridCell.self))
        register(WidgetsPresetsTemplateWeekdayAndDayNumberLargeCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateWeekdayAndDayNumberLargeCell.self))
        register(WidgetsPresetsTemplateDayNumberWithMonthGridCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateDayNumberWithMonthGridCell.self))
        register(WidgetsPresetsTemplateMonthAbbrevAndDayNumberLargeCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateMonthAbbrevAndDayNumberLargeCell.self))
        register(WidgetsPresetsTemplateMonthDayAndWeekdayTextCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateMonthDayAndWeekdayTextCell.self))
        register(WidgetsPresetsTemplateStackedMonthDayWeekdayCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateStackedMonthDayWeekdayCell.self))
        
        // Weather
        register(WidgetsPresetsTemplateDigitalWeatherClockCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateDigitalWeatherClockCell.self))
        register(WidgetsPresetsTemplateWeatherConditionForecastCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateWeatherConditionForecastCell.self))
        register(WidgetsPresetsTemplateWeatherClockCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateWeatherClockCell.self))
        register(WidgetsPresetsTemplateTodayTomorrowWeatherCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateTodayTomorrowWeatherCell.self))
        register(WidgetsPresetsTemplateCompactWeatherForecastCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateCompactWeatherForecastCell.self))
        register(WidgetsPresetsTemplateLocationTemperatureCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateLocationTemperatureCell.self))
        register(WidgetsPresetsTemplateCurrentWeatherSummaryCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateCurrentWeatherSummaryCell.self))
        register(WidgetsPresetsTemplateWeatherIconTemperatureCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateWeatherIconTemperatureCell.self))
        
        // Clock
        register(WidgetsPresetsTemplateAnalogClockCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateAnalogClockCell.self))
        register(WidgetsPresetsTemplateCalendarClockCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateCalendarClockCell.self))
        register(WidgetsPresetsTemplateSplitFlapCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateSplitFlapCell.self))
        register(WidgetsPresetsTemplateDigitalClassicCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateDigitalClassicCell.self))
        register(WidgetsPresetsTemplateDigitalMirrorCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateDigitalMirrorCell.self))
        register(WidgetsPresetsTemplateDigitalStackedCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateDigitalStackedCell.self))
        register(WidgetsPresetsTemplateClockAIPreviewCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateClockAIPreviewCell.self))
        
        // CarLogo
        register(WidgetsPresetsTemplateCarLogoCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateCarLogoCell.self))
        
        // Photo
        register(WidgetsPresetsTemplateAIPhotoCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateAIPhotoCell.self))
        register(WidgetsPresetsTemplateAIPhotoPlaceholderCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplateAIPhotoPlaceholderCell.self))
        register(WidgetsPresetsTemplatePhotoWithTextCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsTemplatePhotoWithTextCell.self))
        
        // Helper
        register(WidgetsPresetsCollectionHelperCell.self, forCellWithReuseIdentifier: String(describing: WidgetsPresetsCollectionHelperCell.self))
        
        dataSource = self
        delegate = self
        
        backgroundColor = UIColor.clear
        contentInset = UIEdgeInsets(vertical: 12.scale)
        setContentOffset(CGPoint(x: 0, y: -12.scale), animated: false)
        showsVerticalScrollIndicator = false 
    }
}
