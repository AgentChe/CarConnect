//
//  AnalogClockFaceView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 26.03.2026.
//

import UIKit

final class AnalogClockFaceView: UIView {
    var timeFormat: TimeFormat = .twelveHour {
        didSet {
            updateHands(for: currentDate)
        }
    }

    func setup(date: Date) {
        currentDate = date
        updateHands(for: date)
    }

    // MARK: - Private

    private let calendar = Calendar.current
    private var currentDate = Date()

    private let faceView = UIView()
    private let centerDotView = UIView()

    private let hourHandView = UIView()
    private let minuteHandView = UIView()

    private var numeralLabels: [UILabel] = []

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutClock()
        updateNumeralFrames()
        updateHands(for: currentDate)
    }
}

// MARK: - Setup
private extension AnalogClockFaceView {
    func initialize() {
        backgroundColor = .clear

        faceView.backgroundColor = UIColor(white: 0.92, alpha: 1)
        faceView.layer.masksToBounds = true
        addSubview(faceView)

        hourHandView.backgroundColor = .black
        minuteHandView.backgroundColor = .systemOrange

        faceView.addSubview(hourHandView)
        faceView.addSubview(minuteHandView)

        centerDotView.backgroundColor = .systemOrange
        faceView.addSubview(centerDotView)

        createNumerals()
    }

    func createNumerals() {
        numeralLabels.forEach { $0.removeFromSuperview() }
        numeralLabels.removeAll()

        for value in numeralValues() {
            let label = UILabel()
            label.text = "\(value)"
            label.textAlignment = .center
            label.textColor = .black
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.6
            faceView.addSubview(label)
            numeralLabels.append(label)
        }
    }

    func numeralValues() -> [Int] {
        [12] + Array(1...11)
    }
}

// MARK: - Layout
private extension AnalogClockFaceView {
    func layoutClock() {
        let side = min(bounds.width, bounds.height)
        let originX = (bounds.width - side) / 2
        let originY = (bounds.height - side) / 2

        faceView.frame = CGRect(x: originX, y: originY, width: side, height: side)
        faceView.layer.cornerRadius = side / 2

        let center = CGPoint(x: side / 2, y: side / 2)

        let hourHandWidth = 3.scale
        let hourHandLength = side * 0.24

        hourHandView.bounds = CGRect(
            x: 0,
            y: 0,
            width: hourHandWidth,
            height: hourHandLength
        )
        hourHandView.center = center
        hourHandView.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        hourHandView.layer.position = center
        hourHandView.layer.cornerRadius = hourHandWidth / 2

        let minuteHandWidth = 2.scale
        let minuteHandLength = side * 0.32

        minuteHandView.bounds = CGRect(
            x: 0,
            y: 0,
            width: minuteHandWidth,
            height: minuteHandLength
        )
        minuteHandView.center = center
        minuteHandView.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        minuteHandView.layer.position = center
        minuteHandView.layer.cornerRadius = minuteHandWidth / 2

        let dotSize = side * 0.09
        centerDotView.frame = CGRect(
            x: center.x - dotSize / 2,
            y: center.y - dotSize / 2,
            width: dotSize,
            height: dotSize
        )
        centerDotView.layer.cornerRadius = dotSize / 2
    }

    func updateNumeralFrames() {
        let side = faceView.bounds.width
        guard side > 0 else { return }

        let center = CGPoint(x: side / 2, y: side / 2)
        let values = numeralValues()
        let count = values.count

        let labelSize = side * 0.12
        let fontSize = side * 0.09
        let radius = side * 0.40

        for (index, label) in numeralLabels.enumerated() {
            label.font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)

            let angle = (-CGFloat.pi / 2) + (CGFloat(index) * 2 * .pi / CGFloat(count))
            let x = center.x + cos(angle) * radius
            let y = center.y + sin(angle) * radius

            label.frame = CGRect(
                x: x - labelSize / 2,
                y: y - labelSize / 2,
                width: labelSize,
                height: labelSize
            )
        }
    }
}

// MARK: - Hands
private extension AnalogClockFaceView {
    func updateHands(for date: Date) {
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)

        let hour = CGFloat(components.hour ?? 0)
        let minute = CGFloat(components.minute ?? 0)
        let second = CGFloat(components.second ?? 0)

        let minuteProgress = (minute + second / 60) / 60
        let minuteAngle = 2 * CGFloat.pi * minuteProgress

        let normalizedHour: CGFloat
        switch timeFormat {
        case .twelveHour:
            normalizedHour = hour.truncatingRemainder(dividingBy: 12)
        case .twentyFourHour:
            normalizedHour = hour.truncatingRemainder(dividingBy: 12)
        }

        let hourProgress = (normalizedHour + minute / 60 + second / 3600) / 12
        let hourAngle = 2 * CGFloat.pi * hourProgress

        hourHandView.transform = CGAffineTransform(rotationAngle: hourAngle)
        minuteHandView.transform = CGAffineTransform(rotationAngle: minuteAngle)
    }
}
