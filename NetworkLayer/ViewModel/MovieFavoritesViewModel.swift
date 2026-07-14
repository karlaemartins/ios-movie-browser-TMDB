//
//  MovieFavoritesViewModel.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 14/07/26.
//

import Foundation

final class MovieFavoritesViewModel {

    private let favoritesStorage: FavoritesStorageProtocol

    private(set) var favoriteMovies: [Movie] = []

    init(favoritesStorage: FavoritesStorageProtocol = FavoritesStorageService.shared) {
        self.favoritesStorage = favoritesStorage
    }
    
    func loadFavorites() {
        favoriteMovies = favoritesStorage.fetchFavorites()
    }
    
    var numberOfMovies: Int {
        favoriteMovies.count
    }
    
    func movie(at index: Int) -> Movie {
        favoriteMovies[index]
    }
}
