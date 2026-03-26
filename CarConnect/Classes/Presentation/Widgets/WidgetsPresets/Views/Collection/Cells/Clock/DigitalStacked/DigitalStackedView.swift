//
//  DigitalStackedView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 25.03.2026.
//

import UIKit

final class DigitalStackedView: ClockStyleView {
    enum Metrics {
        case small, large
    }
    
    lazy var backgroundColorView = makeBackgroundColorView()
    lazy var backgroundImageView = makeBackgroundImageView()
    lazy var hoursLabel = makeLabel()
    lazy var minutesLabel = makeLabel()
    
    private lazy var hours24Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter
    }()
    private lazy var minutesFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        return formatter
    }()
    private lazy var hours12Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh"
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
        updateTime(configuration: configuration)
        updateBackground(configuration: configuration)
    }
}

// MARK: Private
private extension DigitalStackedView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    func updateTime(configuration: WidgetClockConfiguration) {
        let date = Date()
        
        let fontSize: CGFloat = {
            switch metrics {
            case .small:
                return 51.scale
            case .large:
                return 102.scale
            }
        }()
        
        let hours: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(configuration.textColor.wrappedValue)
                .font(configuration.font.uiFont(baseSize: fontSize))
                .textAlignment(.center)
            
            let formatter: DateFormatter = {
                switch configuration.timeFormat {
                case .twelveHour:
                    return hours12Formatter
                case .twentyFourHour:
                    return hours24Formatter
                }
            }()
            
            return formatter.string(from: date).attributed(with: attrs)
        }()
        hoursLabel.attributedText = hours
        
        let minutes: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(configuration.textColor.wrappedValue)
                .font(configuration.font.uiFont(baseSize: fontSize))
                .textAlignment(.center)
            return minutesFormatter.string(from: date).attributed(with: attrs)
        }()
        minutesLabel.attributedText = minutes
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
private extension DigitalStackedView {
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
        
        let spacer: CGFloat = {
            switch metrics {
            case .small:
                return 6.scale
            case .large:
                return 12.scale
            }
        }()
        
        NSLayoutConstraint.activate([
            hoursLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            hoursLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -spacer)
        ])
        
        NSLayoutConstraint.activate([
            minutesLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            minutesLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: spacer)
        ])
    }
}

// MARK: Lazy initialization
private extension DigitalStackedView {
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
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
