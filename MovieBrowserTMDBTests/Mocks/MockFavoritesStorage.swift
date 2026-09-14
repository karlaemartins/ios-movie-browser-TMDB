//
//  MockFavoritesStorage.swift
//  MovieBrowserTMDBTests
//
//  Created by Karla E. Martins Fernandes on 15/07/26.
//

import Foundation
@testable import NetworkLayer

final class MockFavoritesStorage: FavoritesStorageProtocol {
    var favoriteMovies: [Movie] = []
    var isFavoriteResult = false
    
    var saveCalled = false
    var removeCalled = false
    var savedMovie: Movie?
    var removedMovie: Movie?

    func save(_ movie: Movie) {
        saveCalled = true
        savedMovie = movie
    }

    func remove(_ movie: Movie) {
        removeCalled = true
        removedMovie = movie
    }

    func isFavorite(_ movie: Movie) -> Bool {
        isFavoriteResult
    }

    func fetchFavorites() -> [Movie] {
        favoriteMovies
    }
}
