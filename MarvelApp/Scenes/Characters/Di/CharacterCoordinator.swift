//
//  CharCoordinator.swift
//  MarvelApp
//
//  Created by Emad Habib on 08/11/2024.
//
import Common
import UIKit

final class CharacterCoordinator: Coordinator {
    private let window: UIWindow
    private var navigationController: UINavigationController?
    
    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
        let charactersViewModel = CharactersListViewModel()
        let charactersViewController = CharactersListViewController(viewModel: charactersViewModel, flow: self)
        navigationController?.viewControllers = [charactersViewController]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

//MARK: Navigation
extension CharacterCoordinator {
    func navigateToSearchCharacters(from controller: UIViewController){
        let charactersViewModel = CharactersListViewModel()
        let searchCharactersViewController = SearchCharactersViewController(viewModel: charactersViewModel, flow: self)
        navigationController?.pushViewController(searchCharactersViewController, animated: true)
    }
    
    func navigateToCharacterDetail(with character: CharacterModel,from controller: UIViewController){
        let charactersViewModel = CharacterDetailViewModel(charModel: character)
        let charactersViewController = CharacterDetailViewController(viewModel: charactersViewModel, coordinator: self)
        navigationController?.pushViewController(charactersViewController, animated: true)
    }
    
    func navigateToMediaDetail(with media: [CharacterMediaModel],from controller: UIViewController){
        let mediaViewController = CharacterMediaViewController(media: media)
        mediaViewController.modalPresentationStyle = .fullScreen
        mediaViewController.modalTransitionStyle = .crossDissolve
        navigationController?.present(mediaViewController, animated: true)
    }
}
