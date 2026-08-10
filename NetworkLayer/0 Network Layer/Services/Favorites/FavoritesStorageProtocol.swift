//
//  FavoritesStorageProtocol.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 09/07/26.
//

import Foundation

protocol FavoritesStorageProtocol {
    func save(_ movie: Movie)
    func remove(_ movie: Movie)
    func isFavorite(_ movie: Movie) -> Bool
    func fetchFavorites() -> [Movie]
}
