//
//  SceneDelegate.swift
//  Soccer
//
//  Created by Андрей Чернышев on 13.09.2022.
//

import UIKit
import SpotifyiOS

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = SplashViewController.make()
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        SpotifyConnectionService.shared.handleURL(url)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Переподключаемся при каждом выходе на передний план (если токен есть).
        SpotifyConnectionService.shared.connect()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Корректно отключаемся, иначе Spotify не узнает что можно освободить соединение.
        SpotifyConnectionService.shared.disconnect()
    }
}
