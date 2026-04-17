//
//  MusicPlayerProgressView.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 24.03.2026.
//

import Foundation
import UIKit

protocol MusicPlayerProgressDelegate: AnyObject {
    func valueDidChange(value: TimeInterval)
}

final class MusicPlayerProgressView: UIView {
    private lazy var progressSlider = makeSlider()
    private lazy var container = makeContainer()
    private lazy var currentLabel = makeTimeLabel()
    private lazy var durationLabel = makeTimeLabel()
    
    weak var delegate: MusicPlayerProgressDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension TimeInterval {
    
    var timeFormat: Duration.TimeFormatStyle {
        self > 3600
        ? .time(pattern: .hourMinuteSecond(padHourToLength: 2))
        : .time(pattern: .minuteSecond(padMinuteToLength: 2))
    }
}
extension MusicPlayerProgressView {
    func setup(current: TimeInterval, duration: TimeInterval) {
        progressSlider.minimumValue = 0
        progressSlider.maximumValue = Float(duration)
        if !progressSlider.isTracking {
            progressSlider.setValue(Float(current), animated: true)
        }
        
        currentLabel.attributedText = Duration.seconds(current).formatted(current.timeFormat).attributed(with: .time)
        durationLabel.attributedText = Duration.seconds(duration).formatted(duration.timeFormat).attributed(with: .time)
    }
}

private extension MusicPlayerProgressView {
    @objc func valueDidChange(_ sender: UISlider) {
        delegate?.valueDidChange(value: TimeInterval(sender.value))
    }
}

// MARK: Private
private extension MusicPlayerProgressView {
    func initialize() {
        currentLabel.attributedText = "2:48".attributed(with: .time)
        durationLabel.attributedText = "10:48".attributed(with: .time)
        progressSlider.addTarget(self, action: #selector(valueDidChange), for: [.touchUpInside, .touchUpOutside])
        [currentLabel, progressSlider, durationLabel].forEach(container.addArrangedSubview)
    }
}
// MARK: Make constraints
private extension MusicPlayerProgressView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
// MARK: Lazy initialization
private extension MusicPlayerProgressView {
    func makeSlider() -> UISlider {
        let view = UISlider()
        view.maximumValue = 100
        view.value = 50
        view.minimumTrackTintColor = Appearance.color_FFFFFF
        view.maximumTrackTintColor = Appearance.color_FFFFFF.withAlphaComponent(0.16)
        view.setThumbImage(UIImage(named: "Player.Thumb"), for: .normal)
        view.tintColor = Appearance.color_FFFFFF
        
        return view
    }
    
    func makeTimeLabel() -> UILabel {
        let view = UILabel()
        view.layer.opacity = 0.6
        return view
    }
    
    func makeContainer() -> UIStackView {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10.landscapeHScale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

private extension TextAttributes {
    static let time = TextAttributes()
        .font(Fonts.Inter.medium(size: 16.landscapeVScale))
        .lineHeight(20.landscapeVScale)
        .textColor(Appearance.color_FFFFFF)
}
