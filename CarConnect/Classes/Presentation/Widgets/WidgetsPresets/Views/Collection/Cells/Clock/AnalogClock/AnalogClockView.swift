//
//  AnalogClockView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 25.03.2026.
//

import UIKit

final class AnalogClockView: ClockStyleView {
    enum Metrics {
        case small, large
    }
    
    lazy var backgroundColorView = makeBackgroundColorView()
    lazy var backgroundImageView = makeBackgroundImageView()
    lazy var clockFaceView = makeClockFaceView()
    
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
        clockFaceView.timeFormat = configuration.timeFormat
        clockFaceView.setup(date: Date())
        
        updateBackground(configuration: configuration)
    }
}

// MARK: Private
private extension AnalogClockView {
    func initialize() {
        backgroundColor = UIColor.clear
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
private extension AnalogClockView {
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
        
        let inset: CGFloat = {
            switch metrics {
            case .small:
                return 10.scale
            case .large:
                return 20.scale
            }
        }()
        
        NSLayoutConstraint.activate([
            clockFaceView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            clockFaceView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            clockFaceView.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            clockFaceView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
    }
}

// MARK: Lazy initialization
private extension AnalogClockView {
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
    
    func makeClockFaceView() -> AnalogClockFaceView {
        let view = AnalogClockFaceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
