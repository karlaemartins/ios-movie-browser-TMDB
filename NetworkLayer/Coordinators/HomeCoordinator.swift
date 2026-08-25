//
//  HomeCoordinator.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 09/04/26.
//

import UIKit

class HomeCoordinator {
    
    private let imageLoader: ImageLoading

    let navigationController: UINavigationController

    init(navigationController: UINavigationController, imageLoader: ImageLoading) {
        self.navigationController = navigationController
        self.imageLoader = imageLoader
    }

    func start() {
        let movieListVC = MovieListViewController(imageLoader: imageLoader)

        movieListVC.onMovieSelected = { [weak self] movie, genres in
            guard let self = self else { return }

            let detailVC = MovieDetailViewController(movie: movie, genres: genres)
            self.navigationController.pushViewController(detailVC, animated: true)
        }

        movieListVC.onFavoritesSelected = { [weak self] in
            guard let self = self else { return }

            let favoritesVC = MovieFavoritesViewController(imageLoader: imageLoader)
            
            favoritesVC.onMovieSelected = { [weak self] movie in
                guard let self = self else { return }

                let detailVC = MovieDetailViewController(movie: movie, genres: "")
                self.navigationController.pushViewController(detailVC, animated: true)
            }
            
            self.navigationController.pushViewController(favoritesVC, animated: true)
        }

        navigationController.pushViewController(movieListVC, animated: false)
    }
        
    }

