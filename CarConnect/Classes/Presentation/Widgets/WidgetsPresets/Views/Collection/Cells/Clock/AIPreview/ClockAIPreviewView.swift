//
//  ClockAIPreviewView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 01.04.2026.
//

import UIKit
import Kingfisher

final class ClockAIPreviewView: UIView {
    enum Metrics {
        case small, large
    }
    
    lazy var imageView = makeImageView()
    lazy var timeLabel = makeLabel()
    lazy var dateLabel = makeLabel()
    lazy var aiGeneratedView = makeAIGeneratedView()
    
    private lazy var hours24Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    private lazy var hours12Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE\ndd, MMM"
        return formatter
    }()
    
    private let metrics: Metrics
    
    init(metrics: Metrics ) {
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
extension ClockAIPreviewView {
    func setup(configuration: WidgetClockAIPreviewConfiguration, date: Date) {
        imageView.kf.cancelDownloadTask()
        imageView.kf.setImage(with: configuration.url)
        
        let time: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(configuration.textColor.wrappedValue.withAlphaComponent(0.6))
                .font(configuration.font.uiFont(baseSize:{
                    switch metrics {
                    case .small:
                        return 30.scale
                    case .large:
                        return 60.scale
                    }
                }()))
                .textAlignment(.center)
            
            let formatter: DateFormatter = {
                switch configuration.timeFormat {
                case .twelveHour:
                    return hours12Formatter
                case .twentyFourHour:
                    return hours24Formatter
                }
            }()
            
            let time = formatter.string(from: date)
            return time.attributed(with: attrs)
        }()
        timeLabel.attributedText = time
        
        let dateString: NSAttributedString = {
            let attrs = TextAttributes()
                .textColor(configuration.textColor.wrappedValue)
                .font(configuration.font.uiFont(baseSize: {
                    switch metrics {
                    case .small:
                        return 20.scale
                    case .large:
                        return 40.scale
                    }
                }()))
                .textAlignment(.center)
            
            let dateString = dateFormatter.string(from: date)
            return dateString.attributed(with: attrs)
        }()
        dateLabel.attributedText = dateString
    }
}

// MARK: Private
private extension ClockAIPreviewView {
    func initialize() {
        backgroundColor = UIColor.clear
        layer.cornerRadius = 10.scale
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension ClockAIPreviewView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: {
                switch metrics {
                case .small:
                    return 12.scale
                case .large:
                    return 24.scale
                }
            }())
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: {
                switch metrics {
                case .small:
                    return -12.scale
                case .large:
                    return -24.scale
                }
            }())
        ])
        
        NSLayoutConstraint.activate([
            aiGeneratedView.widthAnchor.constraint(equalToConstant: {
                switch metrics {
                case .small:
                    return 48.scale
                case .large:
                    return 96.scale
                }
            }()),
            aiGeneratedView.heightAnchor.constraint(equalToConstant: {
                switch metrics {
                case .small:
                    return 26.scale
                case .large:
                    return 52.scale
                }
            }()),
            aiGeneratedView.topAnchor.constraint(equalTo: topAnchor, constant: {
                switch metrics {
                case .small:
                    return 8.scale
                case .large:
                    return 16.scale
                }
            }()),
            aiGeneratedView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: {
                switch metrics {
                case .small:
                    return -8.scale
                case .large:
                    return -16.scale
                }
            }())
        ])
    }
}

// MARK: Lazy initialization
private extension ClockAIPreviewView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeGradientView() -> GradientView {
        let view = GradientView()
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.gradientLayer.cornerRadius = 10.scale
        view.gradientLayer.masksToBounds = true
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        view.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.gradientLayer.locations = [
            NSNumber(value: 0),
            NSNumber(value: 1)
        ]
        view.gradientLayer.colors = [
            Appearance.color_000000.withAlphaComponent(0).cgColor,
            Appearance.color_000000.withAlphaComponent(0.24).cgColor,
        ]
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAIGeneratedView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "WidgetsPresents.AIGenerated")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
