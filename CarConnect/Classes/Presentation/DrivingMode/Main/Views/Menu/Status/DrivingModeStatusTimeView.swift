//
//  DrivingModeStatusTimeView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 12.03.2026.
//

import UIKit

final class DrivingModeStatusTimeView: UIView {
    lazy var label = makeLabel()
    
    deinit {
        timer?.invalidate()
    }
    
    private var timer: Timer?
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.color_FFFFFF)
        .font(Fonts.Inter.semiBold(size: 16.landscapeHScale))
        .textAlignment(.center)
    
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension DrivingModeStatusTimeView {
    func initialize() {
        backgroundColor = UIColor.clear
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.update()
        }
    }
    
    func update() {
        let time = formatter.string(from: Date())
        label.attributedText = time.attributed(with: attrs)
    }
}

// MARK: Make constraints
private extension DrivingModeStatusTimeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension DrivingModeStatusTimeView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
