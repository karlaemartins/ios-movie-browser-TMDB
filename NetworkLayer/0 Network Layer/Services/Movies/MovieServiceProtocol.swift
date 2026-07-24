//
//  MovieServiceProtocol.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 24/07/26.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchMovieDetails(
        movieID: Int,
        completion: @escaping (Result<MovieDetail, Error>) -> Void
    )
}
