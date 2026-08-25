//
//  AppCoordinator.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 01/04/26.
//

import UIKit

class AppCoordinator {

    let navigationController: UINavigationController
    var childCoordinators: [AnyObject] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let imageLoader = ImageLoader()
        
        let homeCoordinator = HomeCoordinator(
            navigationController: navigationController,
            imageLoader: imageLoader
        )
        
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
}

