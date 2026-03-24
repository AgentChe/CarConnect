//
//  WidgetWeatherView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 21.03.2026.
//

import UIKit

final class WidgetWeatherView: UIView {
    lazy var scrollView = makeScrollView()
    lazy var container = makeContainer()
    lazy var weatherStyleView = makeWeatherStyleView()
    lazy var previewWidgetButton = makePreviewWidgetButton()
    lazy var configurationTabView = makeConfigurationTabView()
    lazy var fieldsContainer = makeFieldsContainer()
    lazy var fontView = makeFontView()
    lazy var fontColorView = makeFontColorView()
    lazy var timeFormatView = makeTimeFormatView()
    lazy var locationView = makeLocationView()
    lazy var temperatureTypeView = makeTemperatureTypeView()
    lazy var restoreDefaultButton = makeRestoreDefaultButton()
    lazy var helperButton = makeHelperButton()
    lazy var removeButton = makeRemoveButton()
    
    private let editableMode: Bool
    private let configuration: WidgetWeatherConfiguration
    
    init(editableMode: Bool, configuration: WidgetWeatherConfiguration) {
        self.editableMode = editableMode
        self.configuration = configuration
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WidgetWeatherView {
    func setup(configuration: WidgetWeatherConfiguration, weatherData: WeatherData) {
        weatherStyleView.setup(configuration: configuration, weatherData: weatherData)
    }
    
    func setup(configurationTabItem: WidgetBuilderConfigurationTabItemButton.Item) {
        configurationTabView.setup(selected: configurationTabItem)
        
        setupFields(configurationTabItem: configurationTabItem)
    }
    
    func makeSnapshotResultView() -> UIImage? {
        let targetBounds = weatherStyleView.bounds
        guard targetBounds.width > 0, targetBounds.height > 0 else { return nil }

        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        format.opaque = weatherStyleView.isOpaque

        let renderer = UIGraphicsImageRenderer(size: targetBounds.size, format: format)

        if weatherStyleView.window != nil {
            return renderer.image { _ in
                weatherStyleView.drawHierarchy(in: targetBounds, afterScreenUpdates: true)
            }
        } else {
            return renderer.image { ctx in
                weatherStyleView.layer.render(in: ctx.cgContext)
            }
        }
    }
}

// MARK: Private
private extension WidgetWeatherView {
    func initialize() {
        backgroundColor = Appearance.color_21232A
    }
    
    func setupFields(configurationTabItem: WidgetBuilderConfigurationTabItemButton.Item) {
        fieldsContainer.subviews.forEach { $0.removeFromSuperview() }
        
        fontView.isHidden = configurationTabItem == .widgetSettings
        fontColorView.isHidden = configurationTabItem == .widgetSettings
        timeFormatView.isHidden = configurationTabItem == .visualEditor
        locationView.isHidden = configurationTabItem == .visualEditor
        temperatureTypeView.isHidden = configurationTabItem == .visualEditor
        
        switch configurationTabItem {
        case .visualEditor:
            setupVisualEditorFields()
        case .widgetSettings:
            setupWidgetsSettingsFields()
        }
    }
    
    func setupVisualEditorFields() {
        fieldsContainer.addSubview(fontView)
        fieldsContainer.addSubview(fontColorView)
        
        NSLayoutConstraint.activate([
            fontView.leadingAnchor.constraint(equalTo: fieldsContainer.leadingAnchor),
            fontView.trailingAnchor.constraint(equalTo: fieldsContainer.trailingAnchor),
            fontView.topAnchor.constraint(equalTo: fieldsContainer.topAnchor),
            fontView.heightAnchor.constraint(equalToConstant: 86.scale)
        ])
        
        NSLayoutConstraint.activate([
            fontColorView.leadingAnchor.constraint(equalTo: fieldsContainer.leadingAnchor),
            fontColorView.trailingAnchor.constraint(equalTo: fieldsContainer.trailingAnchor),
            fontColorView.topAnchor.constraint(equalTo: fontView.bottomAnchor, constant: 24.scale),
            fontColorView.bottomAnchor.constraint(equalTo: fieldsContainer.bottomAnchor),
            fontColorView.heightAnchor.constraint(equalToConstant: 86.scale)
        ])
    }
    
    func setupWidgetsSettingsFields() {
        fieldsContainer.addSubview(timeFormatView)
        fieldsContainer.addSubview(locationView)
        fieldsContainer.addSubview(temperatureTypeView)
        
        NSLayoutConstraint.activate([
            timeFormatView.leadingAnchor.constraint(equalTo: fieldsContainer.leadingAnchor),
            timeFormatView.trailingAnchor.constraint(equalTo: fieldsContainer.trailingAnchor),
            timeFormatView.topAnchor.constraint(equalTo: fieldsContainer.topAnchor),
            timeFormatView.heightAnchor.constraint(equalToConstant: 48.scale)
        ])
        
        NSLayoutConstraint.activate([
            locationView.leadingAnchor.constraint(equalTo: fieldsContainer.leadingAnchor),
            locationView.trailingAnchor.constraint(equalTo: fieldsContainer.trailingAnchor),
            locationView.topAnchor.constraint(equalTo: timeFormatView.bottomAnchor, constant: 12.scale),
            locationView.heightAnchor.constraint(equalToConstant: 48.scale)
        ])
        
        NSLayoutConstraint.activate([
            temperatureTypeView.leadingAnchor.constraint(equalTo: fieldsContainer.leadingAnchor),
            temperatureTypeView.trailingAnchor.constraint(equalTo: fieldsContainer.trailingAnchor),
            temperatureTypeView.topAnchor.constraint(equalTo: locationView.bottomAnchor, constant: 12.scale),
            temperatureTypeView.bottomAnchor.constraint(equalTo: fieldsContainer.bottomAnchor),
            temperatureTypeView.heightAnchor.constraint(equalToConstant: 48.scale)
        ])
    }
}

// MARK: Make constraints
private extension WidgetWeatherView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            container.topAnchor.constraint(equalTo: scrollView.topAnchor),
            container.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            weatherStyleView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            weatherStyleView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            weatherStyleView.topAnchor.constraint(equalTo: container.topAnchor, constant: 16.scale),
            weatherStyleView.heightAnchor.constraint(equalTo: weatherStyleView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            previewWidgetButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            previewWidgetButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            previewWidgetButton.heightAnchor.constraint(equalToConstant: 51.scale),
            previewWidgetButton.topAnchor.constraint(equalTo: weatherStyleView.bottomAnchor, constant: 12.scale),
        ])
        
        NSLayoutConstraint.activate([
            configurationTabView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            configurationTabView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            configurationTabView.heightAnchor.constraint(equalToConstant: 48.scale),
            configurationTabView.topAnchor.constraint(equalTo: previewWidgetButton.bottomAnchor, constant: 24.scale),
        ])
        
        NSLayoutConstraint.activate([
            fieldsContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            fieldsContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            fieldsContainer.topAnchor.constraint(equalTo: configurationTabView.bottomAnchor, constant: 24.scale),
            fieldsContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
        
        NSLayoutConstraint.activate([
            restoreDefaultButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            restoreDefaultButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            restoreDefaultButton.heightAnchor.constraint(equalToConstant: 51.scale),
            restoreDefaultButton.topAnchor.constraint(equalTo: fieldsContainer.bottomAnchor, constant: 32.scale)
        ])
        
        if let helperButton {
            NSLayoutConstraint.activate([
                helperButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
                helperButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
                helperButton.heightAnchor.constraint(equalToConstant: 51.scale),
                helperButton.topAnchor.constraint(equalTo: restoreDefaultButton.bottomAnchor, constant: 12.scale),
                helperButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
        }
        
        if let removeButton {
            NSLayoutConstraint.activate([
                removeButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
                removeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
                removeButton.heightAnchor.constraint(equalToConstant: 51.scale),
                removeButton.topAnchor.constraint(equalTo: restoreDefaultButton.bottomAnchor, constant: 12.scale),
                removeButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
        }
    }
}

// MARK: Lazy initialization
private extension WidgetWeatherView {
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.contentInset = UIEdgeInsets(vertical: 8.scale)
        view.setContentOffset(CGPoint(x: 0, y: 8.scale), animated: false)
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeWeatherStyleView() -> WeatherStyleView {
        let view: WeatherStyleView = {
            switch configuration.style {
            case .weatherIconTemperature:
                return WeatherIconTemperatureView(metrics: .large)
            case .currentWeatherSummary:
                return CurrentWeatherSummaryView(metrics: .large)
            case .locationTemperature:
                return LocationTemperatureView(metrics: .large)
            case .compactWeatherForecast:
                return CompactWeatherForecastView(metrics: .large)
            case .todayTomorrowWeather:
                return TodayTomorrowWeatherView(metrics: .large)
            case .weatherClock:
                return WeatherClockView(metrics: .large)
            case .weatherConditionForecast:
                return WeatherConditionForecastView(metrics: .large)
            case .digitalWeatherClock:
                return DigitalWeatherClockView(metrics: .large)
            }
        }()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makePreviewWidgetButton() -> WidgetBuilderPreviewWidgetButton {
        let view = WidgetBuilderPreviewWidgetButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeConfigurationTabView() -> WidgetBuilderConfigurationTabView {
        let view = WidgetBuilderConfigurationTabView()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeFieldsContainer() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeFontView() -> WidgetBuilderFontView {
        let view = WidgetBuilderFontView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeFontColorView() -> WidgetBuilderFontColorView {
        let view = WidgetBuilderFontColorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeTimeFormatView() -> WidgetBuilderTimeFormatView {
        let view = WidgetBuilderTimeFormatView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeLocationView() -> WidgetBuilderLocationView {
        let view = WidgetBuilderLocationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeTemperatureTypeView() -> WidgetBuilderTemperatureTypeView {
        let view = WidgetBuilderTemperatureTypeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeRestoreDefaultButton() -> WidgetBuilderRestoreDefaultButton {
        let view = WidgetBuilderRestoreDefaultButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeHelperButton() -> WidgetBuilderHelperButton? {
        guard !editableMode else { return nil }
        
        let view = WidgetBuilderHelperButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeRemoveButton() -> WidgetsBuilderRemoveButton? {
        guard editableMode else { return nil }
        
        let view = WidgetsBuilderRemoveButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
