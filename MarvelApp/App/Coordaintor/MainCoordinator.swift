//
//  MainCoordinator.swift
//  MarvelApp
//
//  Created by Emad Habib on 07/11/2024.
//

import Foundation
import Common
import CommonUI
import UIKit

public enum AppChildCoordinator {
    case chars
}

public class AppCoordinator: Coordinator {
    
    private let window: UIWindow
    private var childCoordinators = [AppChildCoordinator: Coordinator]()
    private var navigationController: UINavigationController
    
    // MARK: - Initializer
    public init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
        navigationController.setupNavigationBarAppearance()
    }
    
    public func start() {
        navigateToCharsFlow()
    }
    
    fileprivate func navigateToCharsFlow() {
        let coordinator = CharacterCoordinator(window: window, navigationController: navigationController)
        childCoordinators[.chars] = coordinator
        coordinator.start()
    }
}
