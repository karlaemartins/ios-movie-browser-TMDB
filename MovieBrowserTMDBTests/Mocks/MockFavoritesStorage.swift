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

    var saveCalled = false
    var removeCalled = false

    func save(_ movie: Movie) {
        saveCalled = true
        favoriteMovies.append(movie)
    }

    func remove(_ movie: Movie) {
        removeCalled = true
        favoriteMovies.removeAll { $0.id == movie.id }
    }

    func isFavorite(_ movie: Movie) -> Bool {
        favoriteMovies.contains { $0.id == movie.id }
    }

    func fetchFavorites() -> [Movie] {
        favoriteMovies
    }
}
