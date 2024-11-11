//
//  MainCoordinator.swift
//  MarvelApp
//
//  Created by Emad Habib on 07/11/2024.
//

import Foundation
import Common
import UIKit

public enum AppChildCoordinator {
    case signed
    // case signUp, login, onboarding, etc
}
public class AppDIContainer {
    
}
public class AppCoordinator: Coordinator {
    
    private let window: UIWindow
    private var childCoordinators = [AppChildCoordinator: Coordinator]()
    private let appDIContainer: AppDIContainer
    
    // MARK: - Initializer
    public init(window: UIWindow, appDIContainer: AppDIContainer) {
        self.window = window
        self.appDIContainer = appDIContainer
    }
    
    public func start() {
        navigateToSignedFlow()
    }
    
    fileprivate func navigateToSignedFlow() {
        //    let tabBar = UITabBarController()
        //    let coordinator = SignedCoordinator(tabBarController: tabBar,
        //                                        appDIContainer: appDIContainer)
        //
        //    self.window.rootViewController = tabBar
        //    self.window.makeKeyAndVisible()
        //
        //    childCoordinators[.signed] = coordinator
        //    coordinator.start()
    }
}
