//
//  WidgetsPreviewPhoneView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 27.02.2026.
//

import UIKit

final class WidgetsPreviewPhoneView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var imageView = makeImageView()
    lazy var snapshotView = makeSnapshotView()
    lazy var fakeWidgetView = makeFakeWidgetView()
    
    private let snapshot: UIImage
    
    init(snapshot: UIImage) {
        self.snapshot = snapshot
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension WidgetsPreviewPhoneView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension WidgetsPreviewPhoneView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 32.vScale),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            snapshotView.widthAnchor.constraint(equalToConstant: 124.vScale),
            snapshotView.heightAnchor.constraint(equalToConstant: 124.vScale),
            snapshotView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 38.scale),
            snapshotView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 81.vScale)
        ])
        
        NSLayoutConstraint.activate([
            fakeWidgetView.widthAnchor.constraint(equalToConstant: 124.vScale),
            fakeWidgetView.heightAnchor.constraint(equalToConstant: 124.vScale),
            fakeWidgetView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -38.scale),
            fakeWidgetView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 81.vScale)
        ])
    }
}

// MARK: Lazy initialization
private extension WidgetsPreviewPhoneView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.color_FFFFFF)
            .font(Fonts.Inter.semiBold(size: 14.scale))
            .lineHeight(17.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "WidgetsPreview.Phone.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "WidgetsPreview.Phone")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSnapshotView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 17.scale
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = snapshot
        view.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(view)
        return view
    }
    
    func makeFakeWidgetView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 17.scale
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "WidgetsPreview.Phone.Calendar")
        view.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(view)
        return view
    }
}
