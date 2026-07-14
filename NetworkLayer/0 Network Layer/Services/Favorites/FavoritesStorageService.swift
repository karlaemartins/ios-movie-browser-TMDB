//
//  FavoritesStorageService.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 14/07/26.
//

import Foundation

final class FavoritesStorageService: FavoritesStorageProtocol {

    static let shared = FavoritesStorageService()

    private let favoritesKey = "favorite_movies"

    private init() { }

    func save(_ movie: Movie) {
        var favorites = fetchFavorites()

        favorites.append(movie)

        do {
            let data = try JSONEncoder().encode(favorites)
            UserDefaults.standard.set(data, forKey: favoritesKey)
        } catch {
            print("Erro ao salvar favoritos: \(error.localizedDescription)")
        }
    }

    func remove(_ movie: Movie) {
        var favorites = fetchFavorites()

        favorites.removeAll { $0.id == movie.id }

        do {
            let data = try JSONEncoder().encode(favorites)
            UserDefaults.standard.set(data, forKey: favoritesKey)
        } catch {
            print("Erro ao remover favorito: \(error.localizedDescription)")
        }
    }

    func isFavorite(_ movie: Movie) -> Bool {
        let favorites = fetchFavorites()
        return favorites.contains { $0.id == movie.id }
    }

    func fetchFavorites() -> [Movie] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey) else {
            return []
        }

        do {
            return try JSONDecoder().decode([Movie].self, from: data)
        } catch {
            print("Erro ao carregar favoritos: \(error.localizedDescription)")
            return []
        }
    }
}
