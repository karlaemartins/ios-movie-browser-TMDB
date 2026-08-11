//
//  MovieServiceProtocol.swift
//  NetworkLayer
//
//  Created by Karla E. Martins Fernandes on 24/07/26.
//

import Foundation

protocol MovieServiceProtocol {
    
    func fetchGenres(
            completion: @escaping (Result<GenreResponse, NetworkError>) -> Void
        )
    
    func fetchPopularMovies(
        page: Int,
        completion: @escaping (Result<MovieResponse, NetworkError>) -> Void
    )
    
    func fetchMovieDetails(
        movieID: Int,
        completion: @escaping (Result<MovieDetail, NetworkError>) -> Void
    )
}
