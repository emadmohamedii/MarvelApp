//
//  UIViewController+NavBar.swift
//  CommonUI
//
//  Created by Emad Habib on 08/11/2024.
//

import UIKit

public extension UIViewController {
    
    // Customize the navigation bar with a search button and a middle image
    func customizeNavigationBar(withImage imageName: String, searchAction: Selector?) {
        // Ensure we are working with a navigation controller
        guard let navigationController = self.navigationController else { return }
        
        // Set the background color or any other attributes for the navigation bar if needed
        navigationController.navigationBar.barTintColor = .white
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        // Add the search button to the navigation bar (right side)
        if let action = searchAction {
            let searchButton = UIBarButtonItem(
                image: UIImage(systemName: "magnifyingglass"),
                style: .plain,
                target: self,
                action: action
            )
            searchButton.tintColor = .red
            navigationItem.rightBarButtonItem = searchButton
        }
        
        // Add a middle image to the navigation bar (title view)
        let logoImageView = UIImageView(image: UIImage(named: imageName))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 40) // Customize frame size as needed
        
        navigationItem.titleView = logoImageView
    }
    
    func setupNavigationBarAppearance(){
        // Set a global appearance for the navigation bar
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .black // Set your custom color here
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white] // Change title color
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white] // Large title color
        
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
    
    func customizeNavigationBarForBackButton() {        
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    // Action for the custom back button
    @objc private func backButtonTapped() {
        // Custom behavior for back button (you can add custom actions here before popping the view controller)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Method to hide the navigation bar but keep the back button visible
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // Method to show the navigation bar if it was previously hidden
    func showNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
