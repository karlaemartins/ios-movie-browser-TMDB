//
//  HomeCoordinator.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 09/04/26.
//

import UIKit

class HomeCoordinator {

    private let imageLoader: ImageLoading
    private let movieService: MovieServiceProtocol
    private let favoritesStorage: FavoritesStorageProtocol

    let navigationController: UINavigationController

    init(navigationController: UINavigationController, imageLoader: ImageLoading, movieService: MovieServiceProtocol, favoritesStorage: FavoritesStorageProtocol) {
        self.navigationController = navigationController
        self.imageLoader = imageLoader
        self.movieService = movieService
        self.favoritesStorage = favoritesStorage
    }

    func start() {
        let movieListViewModel = MovieListViewModel(
            movieService: movieService
        )

        let movieListVC = MovieListViewController(
            imageLoader: imageLoader,
            viewModel: movieListViewModel
        )

        movieListVC.onMovieSelected = { [weak self] movie, genres in
            guard let self = self else { return }

            let detailViewModel = MovieDetailViewModel(
                movie: movie,
                genres: genres,
                movieService: self.movieService,
                favoritesStorage: self.favoritesStorage
            )

            let detailVC = MovieDetailViewController(
                viewModel: detailViewModel,
                imageLoader: self.imageLoader
            )

            self.navigationController.pushViewController(detailVC, animated: true)
        }

        movieListVC.onFavoritesSelected = { [weak self] in
            guard let self = self else { return }

            let favoritesViewModel = MovieFavoritesViewModel(
                favoritesStorage: self.favoritesStorage
            )

            let favoritesVC = MovieFavoritesViewController(
                imageLoader: self.imageLoader,
                viewModel: favoritesViewModel
            )

            favoritesVC.onMovieSelected = { [weak self] movie in
                guard let self = self else { return }

                let detailViewModel = MovieDetailViewModel(
                    movie: movie,
                    genres: "",
                    movieService: self.movieService,
                    favoritesStorage: self.favoritesStorage
                )

                let detailVC = MovieDetailViewController(
                    viewModel: detailViewModel,
                    imageLoader: self.imageLoader
                )

                self.navigationController.pushViewController(detailVC, animated: true)
            }

            self.navigationController.pushViewController(favoritesVC, animated: true)
        }

        navigationController.pushViewController(movieListVC, animated: false)
    }
}
