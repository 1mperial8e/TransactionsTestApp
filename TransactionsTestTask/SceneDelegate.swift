//
//  SceneDelegate.swift
//  TransactionsTestTask
//
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private lazy var appRouter: AppRouter = {
        let navigationController = UINavigationController()
        return AppRouterImpl(navigationController: navigationController)
    }()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = appRouter.navigationController
        appRouter.showDashboard()
        self.window = window
        window.makeKeyAndVisible()
    }

}
