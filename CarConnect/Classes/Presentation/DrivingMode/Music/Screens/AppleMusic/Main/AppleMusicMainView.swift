//
//  AppleMusicMainView.swift
//  CarConnect
//
//  Created by Андрей Чернышев on 12.03.2026.
//

import UIKit

final class AppleMusicMainView: UIView {
    
    lazy var collectionView = makeLibraryCollection()
    lazy var dropDownButton = makeDropdownButton()
    lazy var searchField = makeSearchField()
    private lazy var loaderView = makeLoaderView()
    private lazy var authView = makeAuthorizationView()
    private lazy var navigationStack = makeNavigationStack()
    private lazy var searchEmptyView = makeEmptySearchView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AppleMusicMainView {
    func setupAuthState(isAuthorized: Bool) {
        collectionView.isHidden = !isAuthorized
        authView.isHidden = isAuthorized
        searchField.isHidden = !isAuthorized
        if !isAuthorized {
            loaderView.stopSpinningAnimation()
        }
    }
    
    func searchResult(isEmpty: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.collectionView.isHidden = isEmpty
            self.searchEmptyView.isHidden = !isEmpty
        }
    }
    
    func setLoadingState(isLoading: Bool) {
        collectionView.isHidden = isLoading
        if isLoading {
            loaderView.startSpinningAnimation()
        } else {
            loaderView.stopSpinningAnimation()
        }
    }
}

// MARK: Private
private extension AppleMusicMainView {
    func initialize() {
        backgroundColor = Appearance.color_080A0C
        dropDownButton.setMusicSource(.appleMusic)
    }
}

// MARK: Make constraints
private extension AppleMusicMainView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            authView.centerXAnchor.constraint(equalTo: centerXAnchor),
            authView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            navigationStack.topAnchor.constraint(equalTo: topAnchor),
            navigationStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dropDownButton.topAnchor.constraint(equalTo: navigationStack.topAnchor, constant: 19.landscapeVScale),
            dropDownButton.bottomAnchor.constraint(equalTo: navigationStack.bottomAnchor, constant: -4.landscapeVScale),
            dropDownButton.leadingAnchor.constraint(equalTo: navigationStack.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            searchField.centerYAnchor.constraint(equalTo: dropDownButton.centerYAnchor),
            searchField.leadingAnchor.constraint(equalTo: dropDownButton.trailingAnchor, constant: 10.landscapeHScale),
            searchField.trailingAnchor.constraint(equalTo: navigationStack.trailingAnchor, constant: -108.landscapeHScale),
            searchField.heightAnchor.constraint(equalToConstant: 40.landscapeVScale),
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: navigationStack.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            searchEmptyView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            searchEmptyView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
        ])
    }
}

// MARK: Lazy initialization
private extension AppleMusicMainView {
    func makeDropdownButton() -> DropdownButtonView {
        let view = DropdownButtonView()
        view.translatesAutoresizingMaskIntoConstraints = false
        navigationStack.addSubview(view)
        return view
    }
    
    func makeSearchField() -> SearchFieldView {
        let view = SearchFieldView()
        view.translatesAutoresizingMaskIntoConstraints = false
        navigationStack.addSubview(view)
        return view
    }
    
    func makeNavigationStack() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Appearance.color_080A0C
        addSubview(view)
        return view
    }
    
    func makeLibraryCollection() -> AppleMusicMainCollectionView {
        let view = AppleMusicMainCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAuthorizationView() -> AppleMusicAuthorizationView {
        let view = AppleMusicAuthorizationView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmptySearchView() -> AppleMusicLibraryEmptyView {
        let view = AppleMusicLibraryEmptyView()
        view.setup(
            for: "AppleMusic.EmptySearch.Title".localized,
            subtitle: "AppleMusic.EmptySearch.Subtitle".localized
        )
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLoaderView() -> AppleMusicLoaderView {
        let view = AppleMusicLoaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
