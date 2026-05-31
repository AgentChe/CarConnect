//
//  SceneDelegate.swift
//  Soccer
//
//  Created by Андрей Чернышев on 13.09.2022.
//

import UIKit
import SpotifyiOS

// TODO: Live activity - adding a vehicle из flutter
// TODO: Live activity - driving mode из flutter
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        
        let isDrivingModeNavigatorLink = connectionOptions.urlContexts.contains(where: { DeepLink.isDrivingModeNavigator($0.url) })

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = SplashViewController.make(deepLinkIntent: isDrivingModeNavigatorLink ? .openDrivingModeNavigator : nil)
        window?.makeKeyAndVisible()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Переподключаемся при каждом выходе на передний план (если токен есть).
        SpotifyConnectionService.shared.connect()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Корректно отключаемся, иначе Spotify не узнает что можно освободить соединение.
        SpotifyConnectionService.shared.disconnect()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        SceneDelegateMediator.shared.send(openURLContexts: URLContexts)
    }
}
