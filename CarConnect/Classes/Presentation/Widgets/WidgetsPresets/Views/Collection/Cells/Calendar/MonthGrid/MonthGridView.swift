//
//  MonthGridView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 06.03.2026.
//

import UIKit

final class MonthGridView: CalendarStyleView {
    private enum Constants {
        static let columns = 7
        static let weekRows = 6
        static let totalDayCells = columns * weekRows

        static let designSize = CGSize(width: 165, height: 165)

        static let baseMonthFontSize: CGFloat = 10
        static let baseWeekdayFontSize: CGFloat = 9
        static let baseDayFontSize: CGFloat = 9

        static let baseMonthTopInset: CGFloat = 14
        static let baseMonthLeadingInset: CGFloat = 10
        static let baseMonthToWeekdaysSpacing: CGFloat = 8

        static let baseWeekdayRowHeight: CGFloat = 17
        static let baseWeekdayToGridSpacing: CGFloat = 3
        static let baseGridRowSpacing: CGFloat = 3

        static let baseHighlightSize: CGFloat = 17
        static let baseHighlightCornerRadius: CGFloat = 8.5
    }

    lazy var backgroundColorView = makeBackgroundColorView()
    lazy var backgroundImageView = makeBackgroundImageView()
    lazy var monthLabel = makeMonthLabel()
    lazy var weekdayStackView = makeWeekdayStackView()
    lazy var daysGridStackView = makeDaysGridStackView()

    private var weekdayLabels: [UILabel] = []
    private var dayLabels: [UILabel] = []
    private var dayBackgroundViews: [UIView] = []

    private var monthTopConstraint: NSLayoutConstraint?
    private var monthLeadingConstraint: NSLayoutConstraint?
    private var weekdayTopConstraint: NSLayoutConstraint?
    private var weekdayHeightConstraint: NSLayoutConstraint?
    private var daysGridTopConstraint: NSLayoutConstraint?

    private var shownDate: Date?
    private var configuration = WidgetCalendarConfiguration.default(for: .monthGrid)

    private lazy var calendar: Calendar = {
        var calendar = Calendar.current
        calendar.locale = Locale.current
        calendar.firstWeekday = 1 // Sunday
        return calendar
    }()

    private lazy var monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "MMMM"
        return formatter
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        makeConstraints()
        buildWeekdays()
        buildDaysGrid()
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateMetrics()
    }
    
    override func setup(configuration: WidgetCalendarConfiguration) {
        self.configuration = configuration
        self.shownDate = Date()
        
        updateMetrics()
        reloadData()
        updateBackground(configuration: configuration)
    }
}

// MARK: Private
private extension MonthGridView {
    func initialize() {
        backgroundColor = .clear
    }
    
    func updateBackground(configuration: WidgetCalendarConfiguration) {
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

    func reloadData() {
        guard let date = shownDate else { return }

        monthLabel.attributedText = monthFormatter
            .string(from: date)
            .uppercased()
            .attributed(with: makeMonthAttributes())

        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: startOfMonth)!.count
        let weekdayOfFirstDay = calendar.component(.weekday, from: startOfMonth)
        let leadingEmptyCells = weekdayOfFirstDay - 1

        let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        let shownComponents = calendar.dateComponents([.year, .month], from: date)

        let isShowingCurrentMonth =
            todayComponents.year == shownComponents.year &&
            todayComponents.month == shownComponents.month

        let todayDay = isShowingCurrentMonth ? todayComponents.day : nil

        for index in 0..<dayLabels.count {
            dayLabels[index].attributedText = nil
            dayBackgroundViews[index].isHidden = true
        }

        for day in 1...numberOfDaysInMonth {
            let index = leadingEmptyCells + (day - 1)
            guard index < dayLabels.count else { continue }

            let isToday = (todayDay == day)
            dayLabels[index].attributedText = "\(day)".attributed(with: makeDayAttributes())
            dayBackgroundViews[index].isHidden = !isToday
        }
    }

    func updateMetrics() {
        guard bounds.width > 0, bounds.height > 0 else { return }

        let scale = min(
            bounds.width / Constants.designSize.width,
            bounds.height / Constants.designSize.height
        )

        monthTopConstraint?.constant = Constants.baseMonthTopInset * scale
        monthLeadingConstraint?.constant = Constants.baseMonthLeadingInset * scale
        weekdayTopConstraint?.constant = Constants.baseMonthToWeekdaysSpacing * scale
        weekdayHeightConstraint?.constant = Constants.baseWeekdayRowHeight * scale
        daysGridTopConstraint?.constant = Constants.baseWeekdayToGridSpacing * scale
        daysGridStackView.spacing = Constants.baseGridRowSpacing * scale

        if let date = shownDate {
            monthLabel.attributedText = monthFormatter
                .string(from: date)
                .uppercased()
                .attributed(with: makeMonthAttributes())
        }

        for label in weekdayLabels {
            let text = label.text ?? ""
            label.attributedText = text.attributed(with: makeWeekdayAttributes(scale: scale))
        }

        let highlightSize = Constants.baseHighlightSize * scale
        let cornerRadius = Constants.baseHighlightCornerRadius * scale

        for backgroundView in dayBackgroundViews {
            backgroundView.layer.cornerRadius = cornerRadius

            for constraint in backgroundView.constraints {
                if constraint.firstAttribute == .width || constraint.firstAttribute == .height {
                    constraint.constant = highlightSize
                }
            }
        }

        reloadData()
    }
}

// MARK: Build UI
private extension MonthGridView {
    func buildWeekdays() {
        let weekdaySymbols = ["S", "M", "T", "W", "T", "F", "S"]

        weekdaySymbols.forEach { symbol in
            let label = UILabel()
            label.text = symbol
            label.translatesAutoresizingMaskIntoConstraints = false

            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(label)

            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
            ])

            weekdayLabels.append(label)
            weekdayStackView.addArrangedSubview(container)
        }
    }

    func buildDaysGrid() {
        for _ in 0..<Constants.weekRows {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.alignment = .fill
            rowStack.distribution = .fillEqually
            rowStack.spacing = 0
            rowStack.translatesAutoresizingMaskIntoConstraints = false

            for _ in 0..<Constants.columns {
                let cellView = UIView()
                cellView.translatesAutoresizingMaskIntoConstraints = false

                let highlightView = UIView()
                highlightView.translatesAutoresizingMaskIntoConstraints = false
                highlightView.backgroundColor = Appearance.color_FF4539
                highlightView.isHidden = true

                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false

                cellView.addSubview(highlightView)
                cellView.addSubview(label)

                NSLayoutConstraint.activate([
                    highlightView.centerXAnchor.constraint(equalTo: cellView.centerXAnchor),
                    highlightView.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
                    highlightView.widthAnchor.constraint(equalToConstant: Constants.baseHighlightSize),
                    highlightView.heightAnchor.constraint(equalToConstant: Constants.baseHighlightSize),

                    label.centerXAnchor.constraint(equalTo: cellView.centerXAnchor),
                    label.centerYAnchor.constraint(equalTo: cellView.centerYAnchor)
                ])

                dayLabels.append(label)
                dayBackgroundViews.append(highlightView)
                rowStack.addArrangedSubview(cellView)
            }

            daysGridStackView.addArrangedSubview(rowStack)
        }
    }
}

// MARK: Attributes
private extension MonthGridView {
    func currentScale() -> CGFloat {
        guard bounds.width > 0, bounds.height > 0 else { return 1 }

        return min(
            bounds.width / Constants.designSize.width,
            bounds.height / Constants.designSize.height
        )
    }

    func makeMonthAttributes() -> TextAttributes {
        let scale = currentScale()

        return TextAttributes()
            .textColor(Appearance.color_FF4539)
            .font(configuration.font.uiFont(baseSize: Constants.baseMonthFontSize * scale))
            .textAlignment(.left)
    }

    func makeWeekdayAttributes(scale: CGFloat) -> TextAttributes {
        TextAttributes()
            .textColor(configuration.fontColor.withAlphaComponent(0.5))
            .font(configuration.font.uiFont(baseSize: Constants.baseWeekdayFontSize * scale))
            .textAlignment(.center)
    }

    func makeDayAttributes() -> TextAttributes {
        let scale = currentScale()

        return TextAttributes()
            .textColor(configuration.fontColor)
            .font(configuration.font.uiFont(baseSize: Constants.baseDayFontSize * scale))
            .textAlignment(.center)
    }
}

// MARK: Constraints
private extension MonthGridView {
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
        
        monthTopConstraint = monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.baseMonthTopInset)
        monthLeadingConstraint = monthLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.baseMonthLeadingInset)

        weekdayTopConstraint = weekdayStackView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: Constants.baseMonthToWeekdaysSpacing)
        weekdayHeightConstraint = weekdayStackView.heightAnchor.constraint(equalToConstant: Constants.baseWeekdayRowHeight)

        daysGridTopConstraint = daysGridStackView.topAnchor.constraint(equalTo: weekdayStackView.bottomAnchor, constant: Constants.baseWeekdayToGridSpacing)

        NSLayoutConstraint.activate([
            monthTopConstraint!,
            monthLeadingConstraint!
        ])

        NSLayoutConstraint.activate([
            weekdayStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            weekdayStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            weekdayTopConstraint!,
            weekdayHeightConstraint!
        ])

        NSLayoutConstraint.activate([
            daysGridStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            daysGridStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            daysGridTopConstraint!,
            daysGridStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension MonthGridView {
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
    
    func makeMonthLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }

    func makeWeekdayStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }

    func makeDaysGridStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = Constants.baseGridRowSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
