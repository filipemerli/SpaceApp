//
//  SceneDelegate.swift
//  SpaceApp
//
//  Created by Filipe Merli on 14/11/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let currentScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: currentScene)
        let navigationController = MainNavigationController(rootViewController: Self.factoryForListViewController())
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }

    static func factoryForListViewController() -> ListViewController {
        let viewModel = ListViewControllerViewModel(apiFetcher: API())
        return ListViewController(viewModel: viewModel)
    }
}

