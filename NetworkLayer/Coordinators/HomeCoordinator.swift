//
//  HomeCoordinator.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 09/04/26.
//

import UIKit

class HomeCoordinator {

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let movieListVC = MovieListViewController()

        movieListVC.onMovieSelected = { [weak self] movie, genres in
            guard let self = self else { return }

            let detailVC = MovieDetailViewController(movie: movie, genres: genres)
            self.navigationController.pushViewController(detailVC, animated: true)
        }

        movieListVC.onFavoritesSelected = { [weak self] in
            guard let self = self else { return }

            let favoritesVC = MovieFavoritesViewController()
            self.navigationController.pushViewController(favoritesVC, animated: true)
        }

        navigationController.pushViewController(movieListVC, animated: false)
    }
        
    }

