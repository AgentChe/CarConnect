//
//  MusicSourceMenuView.swift
//  CarConnect
//
//  Created by Vitaliy Zagorodnov on 23.04.2026.
//

import UIKit

class MusicSourceMenuView: UIView {
    lazy var dropDownButton = makeDropdownButton()
    private lazy var container = makeContainer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MusicSourceMenuView {
    func setup(for rect: CGRect) {
        NSLayoutConstraint.activate([
            dropDownButton.topAnchor.constraint(equalTo: topAnchor, constant: rect.minY),
            dropDownButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: rect.minX),
            
            container.topAnchor.constraint(equalTo: dropDownButton.bottomAnchor, constant: 24.landscapeVScale),
            container.leadingAnchor.constraint(equalTo: dropDownButton.leadingAnchor)
        ])
        
        dropDownButton.setMusicSource(.appleMusic)
        dropDownButton.isExpanded = true
        
        [MusicSource.spotify, .appleMusic, .radio].forEach { source in
            let button = MusicSourceButton()
            button.setup(source: source)
            container.addArrangedSubview(button)
        }
    }
}

// MARK: Private
private extension MusicSourceMenuView {
    func initialize() {
        backgroundColor = Appearance.color_080A0C
        
    }
}

// MARK: Lazy initialization
private extension MusicSourceMenuView {
    func makeDropdownButton() -> DropdownButtonView {
        let view = DropdownButtonView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIStackView {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 32.landscapeHScale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
